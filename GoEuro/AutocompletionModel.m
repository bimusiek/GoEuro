//
//  AutocompletionModel.m
//  GoEuro
//
//  Created by Michał Hernas on 12/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import "AutocompletionModel.h"
#import <RestKit.h>
#import <RKCLLocationValueTransformer.h>

@implementation AutocompletionModel
- (NSString *)autocompleteString {
    return self.name;
}

+ (void)map:(RKObjectManager*)objectManager {
    
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[AutocompletionModel class]];
    [mapping addAttributeMappingsFromDictionary:[AutocompletionModel mapDescription]];
    
    RKAttributeMapping *attributeMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"geo_position" toKeyPath:@"location"];
    attributeMapping.valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    [mapping addPropertyMapping:attributeMapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"v2/position/suggest/en/:name" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (double)distance {
    CLLocationDistance dist = [self.latestLocation distanceFromLocation:self.location];
    NSLog(@"Distance %0.f", dist);
    return dist;
}

+(NSDictionary*)mapDescription {
    return @{
             @"_id": @"_id",
             @"name": @"name"
             };
}
@end
