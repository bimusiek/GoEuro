//
//  AutocompletionModel.h
//  GoEuro
//
//  Created by Michał Hernas on 12/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MLPAutoCompleteTextField.h>
#import <MapKit/MapKit.h>

@class RKObjectManager;

@interface AutocompletionModel : NSObject <MLPAutoCompletionObject>
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocation *latestLocation;

+(NSDictionary*)mapDescription;
+ (void)map:(RKObjectManager*)objectManager;
- (double)distance;
@end
