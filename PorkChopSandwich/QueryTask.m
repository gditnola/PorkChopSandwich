//
//  QueryTasks.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/21/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "QueryTask.h"


@implementation QueryTask



-(void)getActivePlatforms{
    NSLog(@"QueryTask.getActivePlatforms()");
    NSURL* url = [NSURL URLWithString:activePlatformsLayerURL];
    AGSQueryTask* queryTask = [[AGSQueryTask alloc] initWithURL: url];
    
    //query example
    /*
     AGSQuery* query = [AGSQuery query];
     query.where = @"POP2000 > 1000000";
     query.outFields = [NSArray arrayWithObjects: @"STATE_NAME", @"POP2000", nil];
     */
    
    //spatial query example
    /*
     AGSQuery* query = [AGSQuery query];
     query.geometry = env;
     query.spatialRelationship =  AGSSpatialRelationshipIntersects;
     */
    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"1=1";
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    queryTask.delegate = self;
    
    NSOperation *operation = [queryTask executeWithQuery:query];
}

-(void)getProtractions {
    NSLog(@"QueryTask.getProtractions()");
    NSURL* url = [NSURL URLWithString:protractionsURL];
    AGSQueryTask* queryTask = [[AGSQueryTask alloc] initWithURL: url];

    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"MMS_REGION='G'";
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    //queryTask.delegate = self;
    
    
    [queryTask executeWithQuery:query];
}

#pragma mark AGSQueryTaskDelegate

//results are returned
/*- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
    NSLog(@"QueryTask.queryTask() started");
	//get feature, and load in to table
	self.featureSet = featureSet;
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
}*/

@end
