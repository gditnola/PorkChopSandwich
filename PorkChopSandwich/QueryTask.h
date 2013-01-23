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

#define activePlatformsLayerURL @"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Platforms_-_Active/FeatureServer/0"
#define protractionsURL @"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Protractions/FeatureServer/0"

@interface QueryTask : NSObject <AGSQueryTaskDelegate>

@property (nonatomic, strong) AGSFeatureSet *featureSet;

-(void)getActivePlatforms;
-(void)getProtractions;

@end
