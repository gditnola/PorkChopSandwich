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

@interface PorkChopSandwichViewController : UIViewController <AGSWebMapDelegate, AGSQueryTaskDelegate, AGSRouteTaskDelegate, AGSMapViewTouchDelegate, AGSMapViewCalloutDelegate>
{
    IBOutlet UITableView* routeTableView;
    IBOutlet UIView* layerTableView;
    IBOutlet UIButton* scheduleButton;
    IBOutlet UIButton* layerButton;
    IBOutlet UIButton* zoomOutButton;
}
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSWebMap *webMap;

//route tableview
//@property (nonatomic,retain) NSDictionary *daysOfWeek;
@property (nonatomic,retain) NSMutableArray *route;
@property (nonatomic,retain) QueryTask *queryTask;
@property (nonatomic,retain) RouteTask *routeTask;
@property (nonatomic,retain) AGSGraphic *currentLocation;

- (IBAction)toggle:(UIButton *)sender;
- (IBAction)showSchedule:(UIButton *)sender;
- (IBAction)showLayers:(UIButton *)sender;
- (IBAction)zoomOut:(UIButton *)sender;

@end
