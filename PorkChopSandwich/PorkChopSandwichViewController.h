//
//  PorkChopSandwichViewController.h
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/13/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface PorkChopSandwichViewController : UIViewController <AGSWebMapDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@end
