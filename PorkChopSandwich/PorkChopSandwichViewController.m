//
//  PorkChopSandwichViewController.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "PorkChopSandwichViewController.h"
#import "PorkChopSandwichAppDelegate.h"
#import "QueryTask.h"

@interface PorkChopSandwichViewController ()

@end

@implementation PorkChopSandwichViewController

- (void)viewDidLoad
{
    [self setupRoute];
    [super viewDidLoad];
    NSLog(@"PorkChopSandwichViewController.viewDidLoad()");
    
 //   NSString *protractionsURL = @"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Protractions/FeatureServer/0";
	
	//set up query task against layer, specify the delegate
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:@"http://services.arcgis.com/CZNThfVV3neRiGdR/arcgis/rest/services/Protractions/FeatureServer/0"]];
	self.queryTask.delegate = self;
	
	//return all fields in query
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:@"*", nil];
    self.query.where = @"1=1";
 //   self.queryTask = [QueryTask alloc];
    
    [self loadWebMap];
    //[self loadMap];

}




-(void)loadWebMap {
    NSLog(@"PorkChopSandwichViewController.loadWebMap()");
    self.webMap = [AGSWebMap webMapWithItemId:@"21aef546308844d0b3bfd71782842772" credential:nil];
    self.webMap.delegate = self;
    [self.webMap openIntoMapView:self.mapView];
}

-(void)unselectLayer {
    NSLog(@"unselectLayer()");
    //AGSWebMapBaseMap *baseMap = self.webMap.baseMap;
    //NSLog(@"Layer Count: %u",baseMap.baseMapLayers.count);

//    for(int i=0; i<baseMap.baseMapLayers.count; i++) {
//        NSLog(@"Layer: %@",baseMap.baseMapLayers[i]);
//    }
    
    
    //id protraction;
/*    AGSWebMapLayerInfo *layerInfo = (AGSWebMapLayerInfo *)baseMap.baseMapLayers[0];
    NSLog(@"Testing layerInfo...");
    const char* className = class_getName([layerInfo class]);
    NSLog(@"yourObject is a: %s", className);
    NSLog(@"layerInfo.layerId: %@", [layerInfo layerId]);
    if(layerInfo == nil) {
        NSLog(@"layerInfo is nil");
    }
    else {
        NSLog(@"layerInfo is not nil");
    }
    
    if(layerInfo.layers == nil) {
        NSLog(@"layerInfo.layers is nil");
    }
    else {
        NSLog(@"layerInfo.layers is not nil");
    }
    NSLog(@"BaseMap layer count: %u", layerInfo.layers.count);
 */
 /*   AGSWebMapLayerInfo *protractionsLayer;
    NSLog(@"operationalLayers.count = %u", self.webMap.operationalLayers.count);
    for(int i=0; i<self.webMap.operationalLayers.count; i++) {
        AGSWebMapLayerInfo *layerInfo = (AGSWebMapLayerInfo *)self.webMap.operationalLayers[i];
        NSString *layerTitle = layerInfo.title;
        NSLog(@"Layer: %@",layerTitle);

        if([layerTitle isEqualToString:@"Protractions"]) {
            NSLog(@"Found Protractions Layer");
            protractionsLayer = layerInfo;
        }
    }
    
    NSLog(@"Deleting protractions from array");
   // protractionsLayer.visibility = false;
  */
  
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
    //cbm debug.. remove  below code
    //[self unselectLayer];
    //cbm debug.. remove above code
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//begin TableView methods
-(void)setupRoute {
    /*
     //this will setup grouped tableview
     NSArray *monday = [[NSArray alloc]
                       initWithObjects:@"Stop 1",@"Stop 2",@"Stop3",nil];
    NSArray *tuesday = [[NSArray alloc]
                        initWithObjects:@"Stop 1",@"Stop 2",@"Stop3",nil];
    NSArray *wednesday = [[NSArray alloc]
                          initWithObjects:@"Stop 1",@"Stop 2",@"Stop3",nil];
    NSArray *thursday = [[NSArray alloc]
                         initWithObjects:@"Stop 1",@"Stop 2",@"Stop3",nil];
    NSArray *friday = [[NSArray alloc]
                       initWithObjects:@"Stop 1",@"Stop 2",@"Stop3",nil];
    
    self.daysOfWeek = [[NSDictionary alloc]
                       initWithObjectsAndKeys:monday,@"Monday",tuesday,
                       @"Tuesday",wednesday,@"Wednesday",thursday,@"Thursday",
                       friday,@"Friday",nil];
    
    self.routes =[[self.daysOfWeek allKeys]
                  sortedArrayUsingSelector:@selector(compare:)];
     */
    
    self.route = [self loadRouteFeatures];
    
}

-(NSArray *)loadRouteFeatures {
    NSArray *route = [[NSArray alloc]
     initWithObjects:@"Stop 1",@"Stop 2",@"Stop 3",@"Stop 4",@"Stop 5",@"Stop 6",@"Stop 7",@"Stop 8",
     @"Stop 9",@"Stop 10",nil];
    
    //for now we will hardcode a route
    //lets just get the 10 first features in the Active Platforms Layer to start
    
    
    return route;
}

-(void) printFeatures {
    AGSWebMapLayerInfo *activePlatformsLayer;
    NSLog(@"operationalLayers.count = %u", self.webMap.operationalLayers.count);
    for(int i=0; i<self.webMap.operationalLayers.count; i++) {
        AGSWebMapLayerInfo *layerInfo = (AGSWebMapLayerInfo *)self.webMap.operationalLayers[i];
        NSString *layerTitle = layerInfo.title;
        NSLog(@"Layer: %@",layerTitle);
        
        if([layerTitle isEqualToString:@"Platforms - Active - Platforms_-_Active"]) {
            NSLog(@"Found Protractions Layer");
            activePlatformsLayer = layerInfo;
        }
    }
    
   // QueryTask *queryTask = [QueryTask alloc];
   // [queryTask getActivePlatforms];
   // [queryTask getProtractions]
    
    
    NSLog(@"features.count = %u", self.featureSet.features.count);
    
    //AGSGraphic *feature = [queryTask.featureSet.features objectAtIndex:0];
    
//[self.queryTask getActivePlatforms];
}

#pragma mark Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return [self.route count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    //return [self.route objectAtIndex:section];
    return @"Today's Inspections";
}

- (NSInteger)tableView:(UITableView *)table
 numberOfRowsInSection:(NSInteger)section {
   //grouped
    // NSArray *listData =[self.daysOfWeek objectForKey:
   //                     [self.routes objectAtIndex:section]];
   // return [listData count];
    return [self.route count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    //NSArray *listData =[self.daysOfWeek objectForKey:
    //                    [self.routes objectAtIndex:[indexPath section]]];
    
    UITableViewCell * cell = [tableView
                              dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
        
        /*cell = [[[UITableViewCell alloc]
         initWithStyle:UITableViewCellStyleSubtitle
         reuseIdentifier:SimpleTableIdentifier] autorelease];
         */
    }
    
    NSUInteger row = [indexPath row];
    //grouped
    //cell.textLabel.text = [listData objectAtIndex:row];
    cell.textLabel.text = [self.route objectAtIndex:row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //grouped
    //NSArray *listData =[self.daysOfWeek objectForKey:
    //                    [self.routes objectAtIndex:[indexPath section]]];
    NSUInteger row = [indexPath row];
    
    //grouped
    //NSString *rowValue = [listData objectAtIndex:row];
    
    NSString *rowValue = [self.route objectAtIndex:row];
    
    NSString *message = [[NSString alloc] initWithFormat:rowValue];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"You selected"
                          message:message delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [self.queryTask executeWithQuery:self.query];
    [alert show];
    [self printFeatures];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//end TableView methods

#pragma mark AGSQueryTaskDelegate

//results are returned
 -(void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
    NSLog(@"ViewController.queryTask() started");
	//get feature, and load in to table
	self.featureSet = featureSet;
    NSLog(@"features.count = %u", self.featureSet.features.count);
    NSLog(@"ViewController.queryTask() finsihed");
}

//if there's an error with the query display it to the user
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    NSLog(@"hit queryTask error method");
    NSLog(@"Error localizedDesc: %@", [error localizedDescription]);
    NSLog(@"Error localizedFailureReason: %@", [error localizedFailureReason]);
	[alertView show];
}
@end
