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
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ilmioambulatorio.dev/app_dev.php/"]];
    [httpClient setDefaultHeader:@"x-wsse" value:loginToken];
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"mobile/patients"
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
