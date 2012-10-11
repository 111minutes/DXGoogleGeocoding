//
//  DXGoogleGeocoder.h
//  DXGoogleGeocoding
//
//  Created by Maxim on 10/11/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DXGoogleAddress.h"

@interface DXGoogleGeocoder : NSObject

+ (DXGoogleGeocoder *)shared;

- (void)reverseGeocodingWithLocation:(CLLocation *)location
                     completionBlock:(void(^)(NSArray *googleAddressesArray))completionBlock
                        failureBlock:(void(^)(NSError *error))failureBlock;


//list of supported language codes see here https://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1
@property (nonatomic, strong) NSString *languageCode;   //the language in which to return results


@end
