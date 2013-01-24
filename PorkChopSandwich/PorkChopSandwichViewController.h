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

@interface PorkChopSandwichViewController : UIViewController <AGSWebMapDelegate, AGSQueryTaskDelegate> {
    IBOutlet UITableView* routeTableView;
    
}
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSWebMap *webMap;

//route tableview
//@property (nonatomic,retain) NSDictionary *daysOfWeek;
@property (nonatomic,retain) NSMutableArray *route;
@property (nonatomic,retain) QueryTask *queryTask;

- (IBAction)toggle:(UIButton *)sender;

@end
