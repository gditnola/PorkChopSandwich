//
//  RouteTask.h
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/26/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class PorkChopSandwichViewController; //have to use this forward declaration instead of an import to get objective c to compile the circular reference

#define routeTaskServiceURL @"http://tasks.arcgisonline.com/ArcGIS/rest/services/NetworkAnalysis/ESRI_Route_NA/NAServer/Route"

@interface RouteTask : NSObject {
    PorkChopSandwichViewController *delegate;
}


@property (nonatomic,retain) AGSRouteTask *routeTask;
@property (nonatomic,retain) AGSRouteTaskParameters *routeTaskParams;
@property (nonatomic,retain) AGSRouteTaskResult *routeTaskResult;

-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate;
-(void)getRoute:(NSArray *)stops;
-(void)getRoute:(NSArray *)stops withBarriers:(NSArray *) barriers;
-(NSMutableArray *)getCustomRouteFrom:(AGSGraphic *)startFeature To:(NSArray *)stops WithId:(NSString *)featureId;

@end
