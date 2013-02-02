//
//  RouteTask.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/26/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "RouteTask.h"
#import "PorkChopSandwichViewController.h"
#import "FeatureGraph.h"
#import "FeatureGraphRoute.h"
#import "FeatureGraphNode.h"
#import "FeatureGraphRouteStep.h"
#import "FeatureGraphEdge.h"

@implementation RouteTask

-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate{
    if(self = [super init]) {
        delegate = pcsDelegate;
    }
    NSURL *routeTaskUrl = [NSURL URLWithString:routeTaskServiceURL];
	self.routeTask = [AGSRouteTask routeTaskWithURL:routeTaskUrl];
    self.routeTask.delegate = delegate;
    return self;
}

//since ESRI only provides street directions inside North America and Europe,
//it does not solve our flight path problem
//this method will bypass esri and manually calculate the
//shortest route using Dijkstra's algorithm to calculate the shortest route
-(NSMutableArray *)getCustomRouteFrom:(AGSGraphic *)startFeature To:(NSArray *)stops WithId:(NSString *)featureId{
    NSLog(@"getCustomRoute() start");
    AGSPoint *currentLocationPoint = startFeature.geometry; //end point for this edge
    NSMutableArray *shortestRoute = [[NSMutableArray alloc] init];
    
    //create start node
    //use featureId of @"STR_NAME" for platforms
    //for the start node, just key it as @"Current Location"
    FeatureGraphNode *startNode = [FeatureGraphNode nodeWithIdentifier:@"Current Location" AndFeature:startFeature];
    
    FeatureGraph *graph = [self createFeatureGraph:stops WithStartNode:startNode AndId:featureId];
    
    
    NSArray *steps = [graph shortestRouteFromNode:startNode];
    
    NSLog(@"steps.count = %u", steps.count);
    //NSArray *steps = route;
    for(int i=0; i<steps.count; i++) {
        FeatureGraphNode *node = steps[i];
        
        AGSGraphic *feature = node.feature;
        NSString *identifier = [feature.attributes objectForKey:featureId];
        [shortestRoute addObject:feature];
    }

    return shortestRoute;
}

-(FeatureGraphNode *) createFeatureGraphNode:(AGSGraphic *) feature WithId:(NSString *)featureId{
    //NSLog(@"createFeatureGraphNodeWithFeatureId() = %@", featureId);
    NSString *identifier = [feature.attributes objectForKey:featureId];
    FeatureGraphNode *node = [FeatureGraphNode nodeWithIdentifier:identifier AndFeature:feature];
    return node;
}


//use @"STR_NAME" for featureId of platforms
-(FeatureGraph *) createFeatureGraph:(NSArray *)features WithStartNode:(FeatureGraphNode *)startNode AndId:(NSString *)featureId{
    NSLog(@"createFeatureGraph() start");
    FeatureGraph *graph = [[FeatureGraph alloc] init];
    
    AGSPoint *startPoint;
    AGSPoint *endPoint;
    
    //create each feature node
    NSMutableArray *graphNodes = [[NSMutableArray alloc] init];
    [graphNodes addObject:startNode];
    for(int i=0; i<features.count; i++) {
        AGSGraphic *feature = features[i];
        FeatureGraphNode *node = [self createFeatureGraphNode:feature WithId:featureId];
        [graphNodes addObject:node];
    }
    
    

    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    //project first coordinate to geometry of others
    FeatureGraphNode *firstGraphNode = graphNodes[0];
    AGSPoint *firstPoint = firstGraphNode.feature.geometry;

    firstGraphNode.feature.geometry = firstPoint;

        //add a graph with distance for each feature to each other feature
    for(int i=0; i<graphNodes.count; i++) {
        FeatureGraphNode *startGraphNode = graphNodes[i];
        AGSGraphic *startFeature = startGraphNode.feature;
        
        //first create a line between the two points
        AGSPoint *startPoint = (AGSPoint *)startFeature.geometry; //start point for this edge
  
        for(int j=0; j<graphNodes.count; j++) {
            if(i!=j) {//dont' want to create edge if start point and end point are the same
                FeatureGraphNode *endGraphNode = graphNodes[j];
                AGSGraphic *endFeature = endGraphNode.feature;
                AGSPoint *endPoint = endFeature.geometry; //end point for this edge

                double pointDistance = [startPoint distanceToPoint:endPoint];

                double distance = [startPoint distanceToPoint:endPoint];

                NSString *edgeName = startGraphNode.identifier;
                edgeName = [edgeName stringByAppendingString:@" <-> "];
                edgeName = [edgeName stringByAppendingString:endGraphNode.identifier];

                [graph addBiDirectionalEdge:[FeatureGraphEdge edgeWithName:edgeName andWeight:[NSNumber numberWithDouble:distance]] fromNode:startGraphNode toNode:endGraphNode];
            }
            
        }
        
        
    }
    
    return graph;
}

//parameter: array of AGSGraphic objects
-(void)getRoute:(NSArray *)stops {
	NSLog(@"RouteTask.getRoute() with %u stops.", stops.count);


	// set the stop and polygon barriers on the parameters object
	if (stops.count > 0) {
		[self.routeTaskParams setStopsWithFeatures:stops];
	}

	// this generalizes the route graphics that are returned
	self.routeTaskParams.outputGeometryPrecision = 0.1; //was 5, but in meters
	self.routeTaskParams.outputGeometryPrecisionUnits = AGSUnitsMiles;
    
    // return the graphic representing the entire route, generalized by the previous
    // 2 properties: outputGeometryPrecision and outputGeometryPrecisionUnits
	self.routeTaskParams.returnRouteGraphics = YES;
    
	// this returns turn-by-turn directions
	self.routeTaskParams.returnDirections = YES;
	
	// the next 3 lines will cause the task to find the
	// best route regardless of the stop input order
	self.routeTaskParams.findBestSequence = YES;
	self.routeTaskParams.preserveFirstStop = YES;
	self.routeTaskParams.preserveLastStop = NO;
	
	// since we used "findBestSequence" we need to
	// get the newly reordered stops
	self.routeTaskParams.returnStopGraphics = YES;
	
	// ensure the graphics are returned in our map's spatial reference
    AGSGraphic *feature = (AGSGraphic *)stops[0];
	self.routeTaskParams.outSpatialReference = [feature geometry].spatialReference;//self.mapView.spatialReference;
	
	// let's ignore invalid locations
	self.routeTaskParams.ignoreInvalidLocations = YES;
	
	// you can also set additional properties here that should
	// be considered during analysis.
	// See the conceptual help for Routing task.
	
	// execute the route task
	[self.routeTask solveWithParameters:self.routeTaskParams];
}

-(void)getRoute:(NSArray *)stops withBarriers:(NSArray *) barriers {
    NSLog(@"RouteTask.getRouteWithBarriers()");
}

@end
