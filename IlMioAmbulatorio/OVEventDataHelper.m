//
//  OVEventDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVEventDataHelper.h"
#import "AFHTTPClient.h"

@implementation OVEventDataHelper

static OVEventDataHelper *sharedHelper;

+(OVEventDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVEventDataHelper alloc] init];
    }
    
    return sharedHelper;
}

+(id)alloc
{
    NSAssert(sharedHelper == nil, @"Generic error message");
    return [super alloc];
}

-(void)loadData:(void (^)())successBlock
{
    NSString* a = @"[{\"id\":5,\"start\":\"2013-02-21 9:00:00\",\"end\":\"2013-02-21 9:30:00\",\"title\":\"Emma Swan\",\"body\":\"Emma Swan - Operazione\"},{\"id\":6,\"start\":\"2013-02-21 11:00:00\",\"end\":\"2013-02-21 11:15:00\",\"title\":\"John Doe\",\"body\":\"John Doe - Visita Ambulatoriale\"}]";
    NSData* data = [a dataUsingEncoding:NSUTF8StringEncoding];
    self.events = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];

    successBlock();
    
    return;
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ilmioambulatorio.dev/app_dev.php/"]];
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"mobile/calendar"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.events = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    successBlock();
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];
}

@end
