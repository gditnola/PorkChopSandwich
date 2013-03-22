//
//  IdentifyTask.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 3/19/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "IdentifyTask.h"

@implementation IdentifyTask

//start implementing this.. need to follow the same pattern as QueryTask
//with something like:
-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate{
    if(self = [super init]) {
        delegate = pcsDelegate;
    }
    return self;
 }


/**
 The delegate is the PCSViewController so that is where the results will be returned.
 */
-(void)idenitfyFeatureAtPoint:(AGSPoint *)mapPoint {
    
}

@end
