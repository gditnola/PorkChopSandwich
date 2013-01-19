//
//  PorkChopSandwichViewController.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "PorkChopSandwichViewController.h"

@interface PorkChopSandwichViewController ()

@end

@implementation PorkChopSandwichViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMap];

}

/*
 Right now this is a brute force load of hard coded feature layers from ArcGIS Online feature services.  This
 obviously presents some problems when the app is disconnected, when the ArcGIS Online subscription expires.  Hard
 coding obviously also isn't ideal.
 
 Watch out for the drawing order.  Each successive feature layer to be added to the mapView is drawn on top of the
 previous.
 */
-(void)loadMap {
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Protractions/FeatureServer/0" withTitle:@"Protractions"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Blocks/FeatureServer/0" withTitle:@"Blocks"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Platforms_-_Active/FeatureServer/0" withTitle:@"Active Platforms"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Platforms_-_Proposed/FeatureServer/0" withTitle:@"Proposed Platforms"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Platforms_-_Removed/FeatureServer/0" withTitle:@"Removed Platforms"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Pipelines/FeatureServer/0" withTitle:@"Pipelines"];
    
    [self addFeatureLayer:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Active_Lease_Polygons/FeatureServer/0" withTitle:@"Active Leases"];
    
    [self addFeatureLayer:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer" withTitle:@"Topographic"];
}

/*
 Adds the feature layer with the specified url and title to the webMap.
 */
-(void)addFeatureLayer:(NSString *)urlString withTitle:(NSString *)title{
    NSURL* url = [NSURL URLWithString: urlString];
    AGSFeatureLayer* featureLayer = [AGSFeatureLayer featureServiceLayerWithURL: url mode: AGSFeatureLayerModeOnDemand];
    
    [self.mapView addMapLayer:featureLayer withName: title];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
