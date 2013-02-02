//
//  PorkChopSandwichViewController.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "PorkChopSandwichViewController.h"
#import "PorkChopSandwichAppDelegate.h"
#import "FeatureGraphNode.h"
#import "QueryTask.h"

@interface PorkChopSandwichViewController ()

@end

@implementation PorkChopSandwichViewController {
    NSMutableDictionary *routeDictionary;
    NSMutableArray *routeFeatures;
    NSMutableArray *routeKeys;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebMap];
    //[self loadMap];
    self.queryTask = [[QueryTask alloc] initWithDelegate:self];
    self.routeTask =[[RouteTask alloc] initWithDelegate:self];
    [self initCurrentLocation];
    [self initRouteFeatures];
    [routeTableView setHidden:true];
    NSLog(@"PorkChopSandwichViewController.viewDidLoad()");

}

- (IBAction)toggle:(UIButton *)sender {
    NSLog(@"toggle");
    //[self setupRoute];
    if([routeTableView isHidden]) {
        [routeTableView reloadData];
        [routeTableView setHidden:false];
    }
    else {
        [routeTableView setHidden:true];
    }
    
    //[self addRouteToMap];
    //[self.mapView removeMapLayerWithName:@"Protractions"];
    
    NSLog(@"calculated route: ");
    for(int i=0; i<routeFeatures.count; i++) {
        AGSGraphic *feature = routeFeatures[i];
        NSString *strName = [feature.attributes objectForKey:@"STR_NAME"];
        NSLog(@"%u: %@", i, strName);
    }
}



-(void)loadWebMap {
    NSLog(@"PorkChopSandwichViewController.loadWebMap()");
    self.webMap = [AGSWebMap webMapWithItemId:@"21aef546308844d0b3bfd71782842772" credential:nil];
    self.webMap.delegate = self;
    [self.webMap openIntoMapView:self.mapView];
}

-(void)unselectLayer {
    NSLog(@"unselectLayer()");

  
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
    [self addRouteToMap];
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
    NSLog(@"setupRoute()");

    self.route = routeKeys;
    //[self.routeTask getRoute:self.queryTask.featureSet.features]; //for esri GASRouteTask
    //actually calculate the route
    
    AGSGraphic *feature = routeFeatures[0];
    AGSPoint *testPoint = feature.geometry; //end point for this edge
    
    routeFeatures = [self.routeTask getCustomRouteFrom:self.currentLocation To:routeFeatures WithId:@"STR_NAME"];
    //[self addRouteToMap];
    NSLog(@"my routeFeatures.count = %u", routeFeatures.count);
    routeKeys = [[NSMutableArray alloc] init];
    for(int i=0; i<routeFeatures.count; i++) {
        AGSGraphic *graphic = routeFeatures[i];
        NSString *strName = [graphic.attributes objectForKey:@"STR_NAME"];
        if(strName != nil) {
            NSLog(@"adding route stop: %@", strName);
            [routeKeys addObject:strName];
        }
    }
    NSLog(@"routeKeys.count = %u", routeKeys.count);
    
    self.route = routeKeys;
    
    NSLog(@"self.route.count = %u", self.route.count);
    for(int i=0; i<self.route.count; i++) {
        NSString *routeStop = self.route[i];
        NSLog(@"route stop: %@", routeStop);
    }
    
    [routeTableView reloadData];
    NSLog(@"finished setupRoute()");
    
}

-(void)addRouteToMap {
    NSLog(@"addRouteToMap()");
    AGSGraphicsLayer* stopsLayer = [AGSGraphicsLayer graphicsLayer];
    AGSGraphicsLayer* routeLayer = [AGSGraphicsLayer graphicsLayer];//lines connecting stops
    
    [self.mapView addMapLayer:stopsLayer withName:@"Stops"];
    [self.mapView addMapLayer:routeLayer withName:@"Route"];
    
    AGSSimpleMarkerSymbol* stopFillSymbol = [[AGSSimpleMarkerSymbol alloc] init];
    stopFillSymbol.style = AGSSimpleMarkerSymbolStyleCircle;
    stopFillSymbol.size = 8;
    stopFillSymbol.color = [[UIColor greenColor] colorWithAlphaComponent:0.75];
    stopFillSymbol.outline.color = [UIColor darkGrayColor];
    
    AGSSimpleLineSymbol* routeFillSymbol = [[AGSSimpleLineSymbol alloc] init];
    routeFillSymbol.style = AGSSimpleLineSymbolStyleDash;
    //routeFillSymbol.size = 3;
    routeFillSymbol.color = [[UIColor greenColor] colorWithAlphaComponent:1];
    routeFillSymbol.width = 2;
    
    //featureSet.features is the result of a Query task.
    //It is an array of AGSGraphic objects containing
    //geometries, but not symbols.
    AGSGraphic *firstStopGraphic = routeFeatures[0];
    int i=0;
    for (AGSGraphic *stopGraphic in routeFeatures) {
        i++;
        stopGraphic.symbol = stopFillSymbol;
        //add the graphic to the layer
        [stopsLayer addGraphic:stopGraphic];
        AGSPoint *stopPoint = stopGraphic.geometry;
        
        if(i<routeFeatures.count) { //don't add if there are no more nodes
            //create line graphic from this node to next node
            AGSGraphic *nextGraphic = routeFeatures[i];
            AGSPoint *nextPoint = nextGraphic.geometry;
            AGSMutablePolyline *routeLine = [[AGSMutablePolyline alloc]initWithSpatialReference:nextPoint.spatialReference];

            [routeLine addPathToPolyline];
            [routeLine addPointToPath:stopPoint];
            [routeLine addPointToPath:nextPoint];
            
            //Create the Graphic, using the symbol and
            //geometry created earlier
            AGSGraphic* routeGraphic =
            [AGSGraphic graphicWithGeometry:routeLine
                                 symbol:routeFillSymbol
                             attributes:nil
                   infoTemplateDelegate:nil];
            
            [routeLayer addGraphic:routeGraphic];
        }
    }

    [self.mapView zoomToGeometry:firstStopGraphic.geometry withPadding:0 animated:true];
    //Tell the layer to redraw itself
    [stopsLayer dataChanged];
    [routeLayer dataChanged];
}

-(void)initCurrentLocation {
    NSLog(@"initCurrentLocation()");
    //create a marker symbol to be used by our Graphic
    AGSSimpleMarkerSymbol *myMarkerSymbol =
	[AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    
    //Create an AGSPoint (which inherits from AGSGeometry) that
    //defines where the Graphic will be drawn
    AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:102100];
    //(-10097851.350057,3205756.622786)
    
    AGSPoint* myMarkerPoint =
	[AGSPoint pointWithX:-10097851.350057
                       y:3205756.622786
		spatialReference:spatialReference];
    
    //Create the Graphic, using the symbol and
    //geometry created earlier
    self.currentLocation = 
	[AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:myMarkerSymbol
                         attributes:nil
               infoTemplateDelegate:nil];
    
    if(self.currentLocation == nil) {
        NSLog(@"currentLocation is nil");
    }
    else {
        NSLog(@"currentLocation is not nil");
    }
    
    //Add the graphic to the Graphics layer
    //[myGraphicsLayer addGraphic:myGraphic];
    
    //Tell the layer to redraw itself
    //[myGraphicsLayer dataChanged];
}


-(void)initRouteFeatures {
    //for now we will hardcode a route
    //lets just get the 10 first features in the Active Platforms Layer to start
    
    NSString *inClause = @"('A-Magnolia TLP', 'A-Red Hawk Spar', 'A-Gunnison Spar', 'A-Nansen Spar', 'A-Boomvang Spar', 'A-Hoover Spar', 'A(Perdido)', 'A-Brutus TLP', 'A-Front Runner')";
    [self.queryTask getActivePlatformsWhereStrNameIn:inClause];
    //[operation waitUntilFinished];
}

-(NSMutableArray *)loadRouteFeatures {
   // NSMutableArray *route = [[NSArray alloc]
   //  initWithObjects:@"Stop 1",@"Stop 2",@"Stop 3",@"Stop 4",@"Stop 5",@"Stop 6",@"Stop 7",@"Stop 8",@"Stop 9",@"Stop 10",nil];
    
    
    NSMutableArray *route = [[NSMutableArray alloc]init];
    routeFeatures = [[NSMutableArray alloc]init];
    if(routeDictionary == Nil) {
    routeDictionary = [[NSMutableDictionary alloc] init];
    
    NSLog(@"loadRouteFeatures.count = %u", self.queryTask.featureSet.features.count);
    //[route initwi];
   
    for(int i=0; i<self.queryTask.featureSet.features.count; i++) {
        AGSGraphic *feature = [self.queryTask.featureSet.features objectAtIndex:i];
        NSString *strName = [feature.attributes objectForKey:@"STR_NAME"];
        [route addObject:strName];
        [routeFeatures addObject:feature];
        NSLog(@"added structure name = %@", strName );
        [routeDictionary setObject:feature forKey:strName];
    }
    
    AGSGraphic *testFeature = [routeDictionary objectForKey:@"A-Magnolia TLP"];
    NSString *testComplexId = [testFeature.attributes objectForKey:@"COMPLEX_ID"];
    NSLog(@"testing dictionary key of A-Magnolia TLP's complex_id = %@", testComplexId);
    //above should have waited til finished, now can get features from delegate
    }
    
    [self setupRoute];
    NSLog(@"finished loadRouteFeatures()");
    return route;
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
    return @"Scheduled Inspections";
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
    //[self.queryTask executeWithQuery:self.query];
    //[self.queryTask getActivePlatforms];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//end TableView methods

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
    NSLog(@"QueryTask.queryTask() started");
	//get feature, and load in to table
	self.queryTask.featureSet = featureSet;
    NSLog(@"features.count = %u", self.queryTask.featureSet.features.count);
    
    if(routeDictionary == Nil) {
        routeKeys = [self loadRouteFeatures];
    }
    
    //AGSGraphic *feature = [featureSet.features objectAtIndex:0];
    //NSArray *allKeys = [feature.attributes allKeys];
    //for(int i=0; i<allKeys.count; i++) {
    //    NSLog(@"Key: %@", allKeys[i]);
    //}
    
    //COMPLEX_ID, STR_NUMBER, STR_NAME
    //NSString *complexId = [feature.attributes objectForKey:@"COMPLEX_ID"];
    //NSString *strNumber = [feature.attributes objectForKey:@"STR_NUMBER"];
    //NSString *strName = [feature.attributes objectForKey:@"STR_NAME"];
    
    //NSLog(@"complexId: %@", complexId);
    //NSLog(@"strNumber: %@", strNumber);
    //NSLog(@"strName: %@", strName);
    
    NSLog(@"QueryTask.queryTask() finsihed");
}

//if there's an error with the query display it to the user
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

- (void) routeTask:(AGSRouteTask*)routeTask operation:(NSOperation*)op didSolveWithResult:(AGSRouteTaskResult*) routeTaskResult{
	NSLog(@"Returned routeTask results");
     
     // we know that we are only dealing with 1 route...
     self.routeTask.routeTaskResult = [routeTaskResult.routeResults lastObject];
    
    NSLog(@" Calculated Route With %u stops.", self.routeTask.routeTaskResult.routeResults.count);
     /*if (self.routeResult) {
     // symbolize the returned route graphic
     self.routeResult.routeGraphic.symbol = [self routeSymbol];
     
     // add the route graphic to the graphic's layer
     [self.graphicsLayer addGraphic:self.routeResult.routeGraphic];
     
     // enable the next button so the user can traverse directions
     self.nextBtn.enabled = YES;
     
     // remove the stop graphics from the graphics layer
     // careful not to attempt to mutate the graphics array while
     // it is being enumerated
     NSMutableArray *graphics = [self.graphicsLayer.graphics mutableCopy];
     for (AGSGraphic *g in graphics) {
     if ([g isKindOfClass:[AGSStopGraphic class]]) {
     [self.graphicsLayer removeGraphic:g];
     }
     }
     
     // add the returned stops...it's possible these came back in a different order
     // because we specified findBestSequence
     for (AGSStopGraphic *sg in self.routeResult.stopGraphics) {
     
     // get the sequence from the attribetus
     BOOL exists;
     NSInteger sequence = [sg attributeAsIntForKey:@"Sequence" exists:&exists];
     
     // create a composite symbol using the sequence number
     sg.symbol = [self stopSymbolWithNumber:sequence];
     
     // add the graphic
     [self.graphicsLayer addGraphic:sg];
     }
     
     */
}

- (void) routeTask:(AGSRouteTask*)routeTask operation:(NSOperation*)op didFailSolveWithError:(NSError*) error{
    NSLog(@"Route Tasking: %@",error);
}


@end
