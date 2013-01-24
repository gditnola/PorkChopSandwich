//
//  QueryTasks.h
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/21/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
//#import "PorkChopSandwichViewController.h"
@class PorkChopSandwichViewController; //have to use this forward declaration instead of an import to get objective c to compile the circular reference

#define activePlatformsLayerURL @"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Platforms_-_Active/FeatureServer/0"
#define protractionsURL @"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Protractions/FeatureServer/0"

@interface QueryTask : NSObject {//<AGSQueryTaskDelegate>
    PorkChopSandwichViewController *delegate;
}

@property (nonatomic, strong) AGSFeatureSet *featureSet;
//@property (nonatomic, strong) PorkChopSandwichViewController *delegate;
@property (nonatomic,retain) AGSQueryTask *queryTask;
//@property (nonatomic,retain) AGSQuery *query;

-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate;
-(void)getActivePlatforms;
-(void)getProtractions;-(void)getActivePlatforms:(NSString *)complexId strNumber:(NSString *)strNumber strName:(NSString *)strName;
-(void)getActivePlatforms:(NSString *)strName;
-(NSOperation *)getActivePlatformsWhereStrNameIn:(NSString *)inClause;

@end
