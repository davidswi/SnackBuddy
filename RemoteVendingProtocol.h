//
//  remoteVendingProtocol.h
//  SnackBuddy
//
//  Created by David Switzer on 5/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#ifndef REMOTEVENDINGPROTOCOL_H
#define REMOTEVENDINGPROTOCOL_H

enum RemoteVendingCommand 
{
    REMOTEVENDINGCMD_REQUESTPRODUCTSTOCK,   // Request stock for product ID (iOS app to accessory)
    REMOTEVENDINGCMD_PRODUCTSTOCK,          // Stock for product ID (accessory to iOS app)
    REMOTEVENDINGCMD_REQUESTPRODUCTPRICE,   // Request product price for product ID (iOS app to accessory)
    REMOTEVENDINGCMD_PRODUCTPRICE,          // Product price for product ID (accessory to iOS app)
    REMOTEVENDINGCMD_REQUESTBUYPRODUCT,     // Request purchase for product ID (iOS app to accessory)        
    REMOTEVENDINGCMD_BUYPRODUCT             // Purchase result (accessory to iOS app)
};

enum RemoteVendingResult
{
    REMOTEVENDINGRESULT_SUCCESS,
    REMOTEVENDINGRESULT_PENDING,
    REMOTEVENDINGRESULT_INVALIDREQUEST,
    REMOTEVENDINGRESULT_PRODUCTIDUNKNOWN,
    REMOTEVENDINGRESULT_DATAUNAVAILABLE,
    REMOTEVENDINGRESULT_INSUFFICIENTFUNDS,
    REMOTEVENDINGRESULT_OUTOFSTOCK,
    REMOTEVENDINGRESULT_HARDWAREFAILURE
};

// Structure of all packets exchanged between iOS app and accessory
struct RemoteVendingPacket
{
    uint8_t cmd;
    uint8_t product_id[4];
    uint8_t payload_len;
    union
    {
        uint8_t error_code;
        uint8_t stock_count[4];
        uint8_t price_in_cents[4]; // Assume nothing costs more than $99.99
    } payload;
};

#endif
