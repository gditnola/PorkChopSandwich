//
//  QueryTasks.m
//  PorkChopSandwich
//
//  Created by Charlie McChesney on 1/21/13.
//  Copyright (c) 2013 GDIT. All rights reserved.
//

#import "QueryTask.h"


@implementation QueryTask


-(id)initWithDelegate:(PorkChopSandwichViewController *) pcsDelegate{
    if(self = [super init]) {
        delegate = pcsDelegate;
    }
    return self;
}


-(void)getActivePlatforms{
    NSLog(@"QueryTask.getActivePlatforms()");
    NSURL* url = [NSURL URLWithString:activePlatformsLayerURL];
    self.queryTask = [[AGSQueryTask alloc] initWithURL: url];
    
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
    self.queryTask.delegate = delegate;
    
    [self.queryTask executeWithQuery:query];
}

-(void)getActivePlatforms:(NSString *)complexId stringNumber:(NSString *)stringNumber stringName:(NSString *)stringName {
    NSLog(@"QueryTask.getActivePlatforms()");
    NSURL* url = [NSURL URLWithString:activePlatformsLayerURL];
    self.queryTask = [[AGSQueryTask alloc] initWithURL: url];

    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"COMPLEX_ID='";
    query.where = [query.where stringByAppendingString:complexId];
    query.where = [query.where stringByAppendingString:@"' and STR_NUMBER = '"];
    query.where = [query.where stringByAppendingString:stringNumber];
    query.where = [query.where stringByAppendingString:@"' and STR_NAME = '"];
    query.where = [query.where stringByAppendingString:stringName];
    query.where = [query.where stringByAppendingString:@"'"];
    
    //appending strings result = [result stringByAppendingString:string1];
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    self.queryTask.delegate = delegate;
    
    [self.queryTask executeWithQuery:query];
}

-(void)getActivePlatforms:(NSString *)strName {
    NSURL* url = [NSURL URLWithString:activePlatformsLayerURL];
    self.queryTask = [[AGSQueryTask alloc] initWithURL: url];
    
    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"STR_NAME='";
    query.where = [query.where stringByAppendingString:strName];
    query.where = [query.where stringByAppendingString:@"'"];
    
    //appending strings result = [result stringByAppendingString:string1];
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    self.queryTask.delegate = delegate;
    
    [self.queryTask executeWithQuery:query];
}

-(NSOperation *)getActivePlatformsWhereStrNameIn:(NSString *)inClause {
    NSLog(@"getActivePlatformsWhereStrNameIn()");
    NSURL* url = [NSURL URLWithString:activePlatformsLayerURL];
    self.queryTask = [[AGSQueryTask alloc] initWithURL: url];
    
    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"STR_NAME in";
    query.where = [query.where stringByAppendingString:inClause];
    
    //appending strings result = [result stringByAppendingString:string1];
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    self.queryTask.delegate = delegate;
    
    NSOperation *operation = [self.queryTask executeWithQuery:query];
    return operation;
    //[operation waitUntilFinished];//want to wait until finished, so we can load the initial objects
    //while(![operation isFinished]) {
        
    //}
    //NSLog(@"Operation finished.");
}

-(void)getProtractions {
    NSLog(@"QueryTask.getProtractions()");
    NSURL* url = [NSURL URLWithString:protractionsURL];
    self.queryTask = [[AGSQueryTask alloc] initWithURL: url];

    AGSQuery *query = [AGSQuery query];
    query.outFields = [NSArray arrayWithObjects:@"*", nil];
    query.where = @"MMS_REGION='G'";
    
    //looks like you need to set a delegate (maybe the ViewController) as in:
    self.queryTask.delegate = delegate;
    
    
    [self.queryTask executeWithQuery:query];
}


@end
