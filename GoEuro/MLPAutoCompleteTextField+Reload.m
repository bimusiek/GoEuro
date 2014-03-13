//
//  MLPAutoCompleteTextField+Reload.m
//  GoEuro
//
//  Created by Michał Hernas on 13/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import "MLPAutoCompleteTextField+Reload.h"

@implementation MLPAutoCompleteTextField (Reload)
- (void)reload {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fetchAutoCompleteSuggestions)
                                               object:nil];
    
    [self performSelector:@selector(fetchAutoCompleteSuggestions)
               withObject:nil
               afterDelay:self.autoCompleteFetchRequestDelay];
}
@end
