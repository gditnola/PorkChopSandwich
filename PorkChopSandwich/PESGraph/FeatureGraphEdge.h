//
//  FeatureGraphEdge.h
//  FeatureGraph
//
//  Created by Peter Snyder on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeatureGraphEdge : NSObject {
    
    /**
        The weight of this edge from its starting point to its ending point.
        Defaults to 1
     */
    NSNumber *weight;

    /**
        An optional description of this edge, such as the road it depicts or
        the airline flight its represents, etc.
     */
    NSString *name;
}

@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, assign) NSString *name;

/**
	Convenience initializer that allows for setting the edge's name and number in 
        a single call
	@param aName a description of the information (ex road, flight path, etc.) depcited
        by this edge
	@param aNumber the weight to assign to this edge
	@returns an initialized and un-retained edge
 */
+ (FeatureGraphEdge *)edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber;

/**
    Convenience initializer that allows for setting the edge's name at initilization
    @param aName a description of the information (ex road, flight path, etc.) depcited
        by this edge
    @returns an initialized and un-retained edge
 */
+ (FeatureGraphEdge *)edgeWithName:(NSString *)aName;


@end
