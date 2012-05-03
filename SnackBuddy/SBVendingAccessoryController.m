//
//  SBVendingAccessoryController.m
//  SnackBuddy
//
//  Created by David Switzer on 5/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SBVendingAccessoryController.h"
#import "RemoteVendingProtocol.h"

typedef enum
{
    COMM_STATE_IDLE,
    COMM_STATE_SENDING,
    COMM_STATE_WAITING_RESPONSE,
    COMM_STATE_RECEIVING,
    COMM_STATE_COMMLOST
} VendingCommState;

@implementation SBVendingAccessoryController
{
    VendingCommState commState;
    
    // Incoming and outbound packets
    struct RemoteVendingPacket inPacket;
    struct RemoteVendingPacket outPacket;
}

@synthesize delegate;

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        // Register with notification center for connection notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:    @selector(accessoryConnected:) name:EAAccessoryDidConnectNotification object:nil];
    
        // Also register for disconnection notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDisconnected:) name:EAAccessoryDidDisconnectNotification object:nil];
    
        // Activate notifications from EAAccessoryManager
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
        
        _accessory = nil;
        _session = nil;
        _protocolString = [NSString stringWithString:@"com.acme.remotevending"];
        
        return self;
    }
    else 
    {
        return nil;
    }
}

-(BOOL)openSession
{
    _session = [[EASession alloc] initWithAccessory:_accessory
                                       forProtocol:_protocolString];
    if (_session != nil)
    {
        [[_session inputStream] setDelegate:self];
        [[_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                         forMode:NSDefaultRunLoopMode];
        [[_session inputStream] open];
        [[_session outputStream] setDelegate:self];
        [[_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                          forMode:NSDefaultRunLoopMode];
        [[_session outputStream] open];
        
        return YES;
    }
    else 
    {
        return NO;
    }
}


-(BOOL)pollForVendingAccessory
{
    // Check the list of connected accessories to see if any supports our protocol
    NSArray *accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    for (EAAccessory *nextAccessory in accessoryList)
    {
        for (NSString *protocolString in nextAccessory.protocolStrings)
        {
            if ([protocolString isEqualToString:_protocolString])
            {
                // We like this accessory
                _accessory = nextAccessory;
                // Open a session
                return [self openSession];
            }
        }
    }
    
    return NO;
}

-(void)done
{
    if (_accessory != nil)
    {
        [_accessory setDelegate:nil];
        _accessory = nil;
        if (_session != nil)
        {
            [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
             [[_session inputStream] setDelegate:nil];
             [[_session inputStream] close];
             [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
             [[_session outputStream] setDelegate:nil];
             [[_session outputStream] close];
            _session = nil;
        }
    }
    
    // Clean up notification registrations
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}

-(void)accessoryConnected:(NSNotification *)notification
{
    // Get the NSAccessory object from the notification payload
    EAAccessory *connAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    // Check the protocol strings for the protocol we support
    for (NSString *protocol in connAccessory.protocolStrings)
    {
        if ([protocol isEqualToString:_protocolString])
        {
            // We like this accessory
            _accessory = connAccessory;
            if (![self openSession])
            {
                NSLog(@"SBVendingAccessoryController::accessoryConnected -- failed to open session");
            }
            break;
        }
    }
}

-(NSInteger)requestPriceForProduct:(NSString *)productId
{
    return REMOTEVENDINGRESULT_SUCCESS;
}

-(NSInteger)requestStockForProduct:(NSString *)productId
{
    return REMOTEVENDINGRESULT_SUCCESS;
}

-(NSInteger)requestPurchaseProduct:(NSString *)productId
{
    return REMOTEVENDINGRESULT_SUCCESS;
}


-(void)handleAccessoryDisconnected
{
    [_accessory setDelegate:nil];
    _accessory = nil;
    if (_session != nil)
    {
        [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session inputStream] setDelegate:nil];
        [[_session inputStream] close];
        [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session outputStream] setDelegate:nil];
        [[_session outputStream] close];
        _session = nil;
    }
}

-(void)accessoryDisconnected:(NSNotification *)notification
{
    EAAccessory *disconnAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    if (disconnAccessory.connectionID == _accessory.connectionID)
    {
        // Our accessory went away
        [self handleAccessoryDisconnected];
    }
}


-(void)accessoryDidDisconnect:(id)accessory
{
    EAAccessory *disconnAccessory = (EAAccessory *)accessory;
    if (disconnAccessory.connectionID == _accessory.connectionID)
    {
        [self handleAccessoryDisconnected];
    }
}

- (void)stream:(NSStream*)theStream handleEvent:(NSStreamEvent)streamEvent
{
    switch (streamEvent)
    {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
            break;
        case NSStreamEventHasSpaceAvailable:
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            break;   
    }
}

@end
