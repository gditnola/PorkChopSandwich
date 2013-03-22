//
//  IdentifyTask.h
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 3/19/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
@class PorkChopSandwichViewController; //have to use this forward declaration instead of an import to get objective c to compile the circular reference

@interface IdentifyTask : NSObject {
    PorkChopSandwichViewController *delegate;
}

-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate;
-(void)idenitfyFeatureAtPoint:(AGSPoint *)mapPoint;

@end
