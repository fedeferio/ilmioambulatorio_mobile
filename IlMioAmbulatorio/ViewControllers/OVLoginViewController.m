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
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.progressHUD setMode:MBProgressHUDModeIndeterminate];
    [self.progressHUD setLabelText:@"Loading"];
    [self.view addSubview:self.progressHUD];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)actionLogin:(id)sender
{
    [self.textPassword resignFirstResponder];
    [self.textUser resignFirstResponder];
    
    [self.progressHUD show:YES];

    //TODO:
    [((OVAppDelegate*) [UIApplication sharedApplication].delegate) userDidLogin];

	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ilmioambulatorio.dev/app_dev.php/"]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary* loginParams = @{@"_username":self.textUser.text,@"_password":self.textPassword.text};
    
	[httpClient postPath:@"security/token/create.json"
              parameters:loginParams
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     NSError* error;
                     
                     id jResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                     [[NSUserDefaults standardUserDefaults] setObject:jResult[@"WSSE"] forKey:@"loginToken"];
                     [((OVAppDelegate*) [UIApplication sharedApplication].delegate) userDidLogin];
                     
                     [self.progressHUD hide:YES];
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",)
                                                                    message:NSLocalizedString(@"LoginError",)
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                     
                     [self.progressHUD hide:YES];
                     [alert show];
                 }];
    
    return;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.textUser)
    {
        [self.textPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
