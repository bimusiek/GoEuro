//
//  ClosestLocations.h
//  GoEuro
//
//  Created by Michał Hernas on 13/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RKObjectManager;
@interface ClosestLocations : NSObject
@property (strong, nonatomic) RKObjectManager *objectManager;
- (void)downloadForString:(NSString*)location success:(void (^)(NSArray*))success;
- (void)updateLocation:(CLLocation*)location;
@end
