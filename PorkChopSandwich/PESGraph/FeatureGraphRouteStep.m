//
//  FeatureGraphRouteStep.m
//  FeatureGraph
//
//  Created by Peter Snyder on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeatureGraphRouteStep.h"
#import "FeatureGraphNode.h"
#import "FeatureGraphEdge.h"

@implementation FeatureGraphRouteStep

@synthesize node, edge, isBeginningStep, isEndingStep;

#pragma mark -
#pragma mark Initilizers

- (id)init
{
    self = [super init];

    if (self) {
        
        isBeginningStep = NO;
        isEndingStep = NO;
    }
    
    return self;
}

- (id)initWithNode:(FeatureGraphNode *)aNode andEdge:(FeatureGraphEdge *)anEdge
{    
    self = [super init];
    
    if (self) {
        
        isBeginningStep = NO;
        isEndingStep = (anEdge == nil);
    }
    
    return self;
}

- (id)initWithNode:(FeatureGraphNode *)aNode andEdge:(FeatureGraphEdge *)anEdge asBeginning:(bool)isBeginning
{    
    self = [super init];
    
    if (self) {
        
        isBeginningStep = isBeginning;
        isEndingStep = (anEdge == nil);
    }
    
    return self;
}

#pragma mark -
#pragma mark Property Implementations
- (bool)isEndingStep
{
    return (self.edge == nil);
}


@end
