//
//  DXAppDelegate.m
//  DXGoogleGeocoding
//
//  Created by Maxim on 10/11/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "DXGoogleGeocoder.h"

@implementation DXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // Test Methods
    
    [self testReverseGeocoding];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 
#pragma mark - Functionality Test Methods

- (void)testReverseGeocoding {
    
    CLLocationDegrees latitude = 37.323417;
    CLLocationDegrees longitude = -122.032163;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
//    [[DXGoogleGeocoder shared] setLanguageCode:@"ru"];
//    [[DXGoogleGeocoder shared] setLanguageCode:@"en"];
    
    [[DXGoogleGeocoder shared] reverseGeocodingWithLocation:location completionBlock:^(NSArray *googleAddressesArray) {
        if (googleAddressesArray.count != 0) {
            DXGoogleAddress *googleAddress = [googleAddressesArray objectAtIndex:0];
            NSLog(@"Country : %@", googleAddress.country);
            NSLog(@"AdministrativeAreaLevel_1 : %@", googleAddress.administrativeAreaLevel_1);
            NSLog(@"City : %@", googleAddress.cityOrTown);
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

@end
