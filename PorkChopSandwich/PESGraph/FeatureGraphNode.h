//
//  FeatureNode.h
//  FeatureGraph
//
//  Created by Peter Snyder on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

/**
	Represents a single node in a graph.  Each node must have a unique, string identifier in the graph (used
    internally for dictionary look ups).  Each node can also optionally have a title and a dictionary for
    to hold further information about each node (eg latitude and longitude, or references to other objects, etc.)
 */
@interface FeatureGraphNode : NSObject {

    /**
        A unique string identifer for this edge.  Must be unique among all other
        nodes in the graph
     */
    NSString *identifier;

    /**
        An optional description of the node point.
     */
    NSString *title;

    /**
        Optional further key-value pairs describing the node
     */
    NSMutableDictionary *additionalData;
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSMutableDictionary *additionalData;
@property (nonatomic, retain) AGSGraphic *feature;

/**
	Convenience method to return an initialized and un-retained node
	@param anIdentifier a unique identifier for the node.  Must be unique for all nodes in a graph
    @returns an initialized and un-retained edge
 */
+ (FeatureGraphNode *)nodeWithIdentifier:(NSString *)anIdentifier AndFeature:(AGSGraphic *)feature;

@end