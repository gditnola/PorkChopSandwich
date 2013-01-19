//
//  PorkChopSandwichViewController.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "PorkChopSandwichViewController.h"
#import "PorkChopSandwichAppDelegate.h"

@interface PorkChopSandwichViewController ()

@property (nonatomic, strong) AGSWebMap *webMap;

@end

@implementation PorkChopSandwichViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PorkChopSandwichViewController.viewDidLoad()");
    [self loadWebMap];
    //[self loadMap];

}

-(void)loadWebMap {
    NSLog(@"PorkChopSandwichViewController.loadWebMap()");
    self.webMap = [AGSWebMap webMapWithItemId:@"21aef546308844d0b3bfd71782842772" credential:nil];
    self.webMap.delegate = self;
    [self.webMap openIntoMapView:self.mapView];
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

//delegate methods
- (void) webMapDidLoad:(AGSWebMap*) webMap {
    //webmap data was retrieved successfully
    NSLog(@"webMap was retrieved successfully.");
}

- (void) webMap:(AGSWebMap *)webMap didFailToLoadWithError:(NSError *)error {
    //webmap data was not retrieved
    //alert the user
    NSLog(@"Error while loading webmap: %@",[error localizedDescription]);
}

-(void)didOpenWebMap:(AGSWebMap*)webMap intoMapView:(AGSMapView*)mapView{
   	//web map finished opening
     NSLog(@"webMap finished opening.");
}

-(void)webMap:(AGSWebMap*)wm didLoadLayer:(AGSLayer*)layer{
    //layer in web map loaded properly
     NSLog(@"webMap loaded layer: %@", [layer name]);
}

-(void)webMap:(AGSWebMap*)wm didFailToLoadLayer:(NSString*)layerTitle url:(NSURL*)url baseLayer:(BOOL)baseLayer federated:(BOOL)federated withError:(NSError*)error{
    NSLog(@"Error while loading layer: %@",[error localizedDescription]);
    
    //you can skip loading this layer
    //[self.webMap continueOpenAndSkipCurrentLayer];
    
    //or you can try loading it with proper credentials if the error was security related
    //[self.webMap continueOpenWithCredential:credential];
}

@end
