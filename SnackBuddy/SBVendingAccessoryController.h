//
//  SBVendingAccessoryController.h
//  SnackBuddy
//
//  Created by David Switzer on 5/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

// RemoteVendingDelegate protocol declaration
@protocol RemoteVendingDelegate <NSObject>

-(NSInteger)vendingMachineDidProcessRequest:(NSString *)statusMsg;

@end


@interface SBVendingAccessoryController : NSObject<EAAccessoryDelegate, NSStreamDelegate>
{
    EAAccessory *_accessory;
    EASession *_session;
    NSString *_protocolString;
}

@property(nonatomic, weak) id<RemoteVendingDelegate> delegate;

-(id)init;
-(BOOL)pollForVendingAccessory;
-(void)done;
-(void)accessoryConnected:(NSNotification *)notification;
-(void)accessoryDisconnected:(NSNotification *)notification;

-(NSInteger)requestStockForProduct:(NSString *)productId;
-(NSInteger)requestPriceForProduct:(NSString *)productId;
-(NSInteger)requestPurchaseProduct:(NSString *)productId;


// EAAccessoryDelegate protocol
-(void)accessoryDidDisconnect:(id)accessory;

// NSStreamDelegate protocol
- (void)stream:(NSStream*)theStream handleEvent:(NSStreamEvent)streamEvent;

@end
