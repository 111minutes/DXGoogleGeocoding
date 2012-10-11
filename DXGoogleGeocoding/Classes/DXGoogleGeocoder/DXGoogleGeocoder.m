//
//  DXGoogleGeocoder.m
//  DXGoogleGeocoding
//
//  Created by Maxim on 10/11/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXGoogleGeocoder.h"
#import "AFNetworking.h"

const NSString *BASE_MAPS_GOOGLEAPIS_URL = @"http://maps.googleapis.com/maps/api/geocode";

const NSString *kStatus = @"status";
const NSString *kResults = @"results";
const NSString *kAddressComponents = @"address_components";
const NSString *kTypes = @"types";
const NSString *kFormattedAddress = @"formatted_address";
const NSString *kRoute = @"route";
const NSString *kAdministrativeAreaLevel_1 = @"administrative_area_level_1";
const NSString *kAdministrativeAreaLevel_2 = @"administrative_area_level_2";
const NSString *kAdministrativeAreaLevel_3 = @"administrative_area_level_3";
const NSString *kCountry = @"country";
const NSString *kLocality = @"locality";    // Like City or Town
const NSString *kStreetNumber = @"street_number";
const NSString *kPostalCode = @"postal_code";
const NSString *kGeometry = @"geometry";
const NSString *kLocation = @"location";
const NSString *kLat = @"lat";
const NSString *kLng = @"lng";
const NSString *kLongName = @"long_name";
const NSString *cStatusOK = @"OK";

@implementation DXGoogleGeocoder

+ (DXGoogleGeocoder *)shared {
    static DXGoogleGeocoder *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [DXGoogleGeocoder new];
    });
    return shared;
}

- (void)reverseGeocodingWithLocation:(CLLocation *)location
                     completionBlock:(void(^)(NSArray *googleAddressesArray))completionBlock
                        failureBlock:(void(^)(NSError *error))failureBlock {
    if (!location) {
        if (failureBlock) {
            failureBlock([NSError errorWithDomain:@"" code:0 userInfo:nil]);
        }
        return ;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/json?latlng=%f,%f&sensor=true", BASE_MAPS_GOOGLEAPIS_URL, location.coordinate.latitude, location.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *addressComponentsArray = [self googleAddressesArrayFromResponseDict:JSON];
        if (completionBlock) {
            completionBlock(addressComponentsArray);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    [operation start];
}

- (NSArray *)googleAddressesArrayFromResponseDict:(NSDictionary *)response {
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *status = [response valueForKey:(NSString *)kStatus];
    
    if ([status isEqualToString:(NSString *)cStatusOK]) {
        NSArray *resultsArray = [response valueForKey:(NSString *)kResults];
        for (NSDictionary *result in resultsArray) {
            
            DXGoogleAddress *googleAddress = [self googleAddressFromAddressDict:result];
            [array addObject:googleAddress];
        }
    }
    
    return array;
}

- (DXGoogleAddress *)googleAddressFromAddressDict:(NSDictionary *)addressDict {
    
    DXGoogleAddress *googleAddress = [DXGoogleAddress new];
    
    NSArray *addressComponentsArray = [addressDict valueForKey:(NSString *)kAddressComponents];
    NSDictionary *typesMapping = [self typesAddressComponentsMapping];
    for (NSDictionary *component in addressComponentsArray) {
        id types = [component valueForKey:(NSString *)kTypes];
        if ([types isKindOfClass:[NSArray class]]) {
            for (NSString *type in types) {
                NSString *key = [typesMapping valueForKey:type];
                if (key) {
                    NSString *value = [component valueForKey:(NSString *)kLongName];
                    [googleAddress setValue:value forKey:key];
                    break ;
                }
            }
        }
    }
    
    NSString *formattedAddress = [addressDict valueForKey:(NSString *)kFormattedAddress];
    googleAddress.formattedAddress = formattedAddress;
    
    googleAddress.latitude = [addressDict valueForKeyPath:[NSString stringWithFormat:@"%@.%@.%@", kGeometry, kLocation, kLat]];
    googleAddress.longitude = [addressDict valueForKeyPath:[NSString stringWithFormat:@"%@.%@.%@", kGeometry, kLocation, kLng]];
    
    return googleAddress;
}

- (NSDictionary *)typesAddressComponentsMapping {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    
    [mapping setValue:@"streetNumber" forKey:(NSString *)kStreetNumber];
    [mapping setValue:@"route" forKey:(NSString *)kRoute];
    [mapping setValue:@"cityOrTown" forKey:(NSString *)kLocality];
    [mapping setValue:@"administrativeAreaLevel_1" forKey:(NSString *)kAdministrativeAreaLevel_1];
    [mapping setValue:@"administrativeAreaLevel_2" forKey:(NSString *)kAdministrativeAreaLevel_2];
    [mapping setValue:@"administrativeAreaLevel_3" forKey:(NSString *)kAdministrativeAreaLevel_3];
    [mapping setValue:@"country" forKey:(NSString *)kCountry];
    [mapping setValue:@"postalCode" forKey:(NSString *)kPostalCode];
    
    return mapping;
}


@end
