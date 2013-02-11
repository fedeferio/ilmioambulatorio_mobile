//
//  OVPatientDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientDataHelper.h"
#import "AFHTTPClient.h"

@implementation OVPatientDataHelper

static OVPatientDataHelper *sharedHelper;

+(OVPatientDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVPatientDataHelper alloc] init];
    }
    
    return sharedHelper;
}

+(id)alloc
{
    NSAssert(sharedHelper == nil, @"Generic error message");
    return [super alloc];
}

-(void)loadData:(void(^)())successBlock
{
    //NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"patients" ofType:@"json"]];
    //self.patients = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost"]];
   
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"patients.json"
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     NSError* error;
                     
                     self.patients = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                     successBlock();
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 }];
    
    
}

@end
