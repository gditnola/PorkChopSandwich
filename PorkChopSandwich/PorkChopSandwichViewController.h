//
//  PorkChopSandwichViewController.h
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "QueryTask.h"
#import "RouteTask.h"
#import "IdentifyTask.h"

@interface PorkChopSandwichViewController : UIViewController <AGSWebMapDelegate, AGSQueryTaskDelegate, AGSRouteTaskDelegate, AGSMapViewTouchDelegate, AGSMapViewCalloutDelegate, AGSIdentifyTaskDelegate, AGSPopupsContainerDelegate>
{
    IBOutlet UITableView* routeTableView;
    IBOutlet UIView* layerTableView;
    IBOutlet UIButton* scheduleHideButton;
    IBOutlet UIButton* layerHideButton;
    IBOutlet UIButton* zoomOutButton;
}
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSWebMap *webMap;

//route tableview
//@property (nonatomic,retain) NSDictionary *daysOfWeek;
@property (nonatomic,retain) NSMutableArray *route;
@property (nonatomic,retain) QueryTask *queryTask;
@property (nonatomic,retain) RouteTask *routeTask;
@property (nonatomic,retain) IdentifyTask *identifyTask;
@property (nonatomic,retain) AGSGraphic *currentLocation;

- (IBAction)showSchedule:(UIButton *)sender;
- (IBAction)showLayers:(UIButton *)sender;
- (IBAction)zoomOut:(UIButton *)sender;
- (IBAction)hide:(UIButton *)sender;
- (IBAction)toggleLayer:(UISwitch *)sender;

@end
