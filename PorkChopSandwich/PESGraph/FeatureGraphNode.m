//
//  FeatureNode.m
//  FeatureGraph
//
//  Created by Peter Snyder on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeatureGraphNode.h"

@implementation FeatureGraphNode

@synthesize identifier;
@synthesize title;
@synthesize additionalData;


+ (FeatureGraphNode *)nodeWithIdentifier:(NSString *)anIdentifier AndFeature:(AGSGraphic *)feature{

    FeatureGraphNode *aNode = [[FeatureGraphNode alloc] init];
    
    aNode.identifier = anIdentifier;
    aNode.feature = feature;
    
    return aNode;
}


@end
