//
//  FeatureGraphRoute.m
//  FeatureGraph
//
//  Created by Peter Snyder on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeatureGraphRoute.h"
#import "FeatureGraphRouteStep.h"
#import "FeatureGraphNode.h"
#import "FeatureGraphEdge.h"

@implementation FeatureGraphRoute

@synthesize steps;

- (id)init
{
    self = [super init];

    if (self) {

        steps = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addStepFromNode:(FeatureGraphNode *)aNode withEdge:(FeatureGraphEdge *)anEdge
{
    FeatureGraphRouteStep *aStep = [[FeatureGraphRouteStep alloc] initWithNode:aNode
                                                                andEdge:anEdge
                                                            asBeginning:([steps count] == 0)];
    
    [steps addObject:aStep];
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"Start: \n"];
    
    for (FeatureGraphRouteStep *aStep in steps) {
        
        if (aStep.edge) {

            [string appendFormat:@"\t%@ -> \n", aStep.node.identifier, aStep.edge];

        } else {
            
            [string appendFormat:@"\t%@ (End)", aStep.node.identifier];
            
        }
    }

    return string;
}

- (NSUInteger)count {
    
    return [steps count];    
}

- (FeatureGraphNode *)startingNode {
    
    return ([self count] > 0) ? [[steps objectAtIndex:0] node] : nil;
}

- (FeatureGraphNode *)endingNode {
    
    return ([self count] > 0) ? [[steps objectAtIndex:([self count] - 1)] node] : nil;
}

- (float)length {
    
    float totalLength = 0;
    
    for (FeatureGraphRouteStep *aStep in steps) {
        
        if (aStep.edge) {

            totalLength += [aStep.edge.weight floatValue];
        }
    }
 
    return totalLength;
}

@end
