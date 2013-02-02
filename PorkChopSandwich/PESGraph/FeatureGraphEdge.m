//
//  FeatureGraphEdge.m
//  FeatureGraph
//
//  Created by Peter Snyder on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeatureGraphEdge.h"

@implementation FeatureGraphEdge

#pragma mark -
#pragma mark Class Methods

+ (FeatureGraphEdge *)edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber {
    
    FeatureGraphEdge *anEdge = [[FeatureGraphEdge alloc] init];

    anEdge.weight = aNumber;
    anEdge.name = aName;
    
    return anEdge;
}

+ (FeatureGraphEdge *)edgeWithName:(NSString *)aName {

    FeatureGraphEdge *anEdge = [[FeatureGraphEdge alloc] init];
    
    anEdge.name = aName;
    
    return anEdge;
}

#pragma mark -
#pragma mark Initilizers

- (id)init
{
    self = [super init];

    if (self) {
        
        // Set the default weight of the edge to be 1
        self.weight = [NSNumber numberWithInt:1];
    }
    
    return self;
}

#pragma mark -
#pragma mark Overrides

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Edge: %@ with Weight:%@", self.name, self.weight];
}


@end
