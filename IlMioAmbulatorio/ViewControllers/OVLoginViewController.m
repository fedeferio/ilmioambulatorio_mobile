//
//  OVLoginViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 25/01/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVLoginViewController.h"
#import "AFHTTPClient.h"
#import "OVAppDelegate.h"

@interface OVLoginViewController ()

@end

@implementation OVLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)actionLogin:(id)sender
{
    [((OVAppDelegate*) [UIApplication sharedApplication].delegate) userDidLogin];
    
    return;
    
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://webapp.ilmioambulatorio.it/"]];
    //	[httpClient setDefaultHeader:@"X-CSRF-Token" value:[PMUserHandler sharedHelper].tokenCSRF];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary* loginParams = @{@"username":@"Gregory.House",@"password":@"password"};
    
	[httpClient postPath:@""
              parameters:loginParams
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     NSError* error;
                     
                     id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
                     
                    
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 }];
}

@end
