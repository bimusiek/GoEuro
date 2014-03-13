//
//  ClosestLocations.m
//  GoEuro
//
//  Created by Michał Hernas on 13/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import "ClosestLocations.h"
#import <RestKit.h>
#import "AutocompletionModel.h"
#import <NSString+UrlEncode.h>

@interface ClosestLocations()
@property (nonatomic, strong) CLLocation *latestLocation;
@end

@implementation ClosestLocations
- (id)init {
    if(self = [super init])
    {
        [self initRestKit];
    }
    return self;
}

- (void)initRestKit {
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://www.goeuro.com/GoEuroAPI/rest/api/"]];
    [AutocompletionModel map:self.objectManager];
    
}
- (void)downloadForString:(NSString*)location success:(void (^)(NSArray*))success {
    
    NSString *path = [NSString stringWithFormat:@"v2/position/suggest/en/%@", [location urlEncode]];
    [[RKObjectManager sharedManager]  getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if(success) {
            success([self sortByDistance:[mappingResult array]]);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

-(NSArray*)sortByDistance:(NSArray*)locations {
    return[locations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        AutocompletionModel *first = (AutocompletionModel*)a;
        AutocompletionModel *second = (AutocompletionModel*)b;
        first.latestLocation = self.latestLocation;
        second.latestLocation = self.latestLocation;
        
        if ([first distance] < [second distance])
            return NSOrderedAscending;
        else if ([first distance] > [second distance])
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    return locations;
}

-(void)updateLocation:(CLLocation *)location {
    self.latestLocation = location;
}
@end
