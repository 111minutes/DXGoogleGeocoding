//
//  DXGoogleAddress.h
//  DXGoogleGeocoding
//
//  Created by Maxim on 10/11/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXGoogleAddress : NSObject

@property (nonatomic, strong) NSString *formattedAddress;
@property (nonatomic, strong) NSString *streetNumber;
@property (nonatomic, strong) NSString *route;
@property (nonatomic, strong) NSString *cityOrTown;
@property (nonatomic, strong) NSString *administrativeAreaLevel_1;
@property (nonatomic, strong) NSString *administrativeAreaLevel_2;
@property (nonatomic, strong) NSString *administrativeAreaLevel_3;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, assign) NSNumber *latitude;
@property (nonatomic, assign) NSNumber *longitude;

@end
