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
#import "OVGlobals.h"
#import "GradientButton.h"

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
    
    [self.buttonLogin setGradientTint:[UIColor colorWithRed:238.0/255.0 green:148.0/255.0 blue:37.0/255.0 alpha:1]];
    [self.buttonLogin setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.buttonLogin.titleLabel setShadowOffset:CGSizeMake(0, -1)];
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

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary* loginParams = @{@"_username":self.textUser.text,@"_password":self.textPassword.text};
    
	[httpClient postPath:@"security/token/create.json"
              parameters:loginParams
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     NSError* error;
                     
                     id jResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                     [[NSUserDefaults standardUserDefaults] setObject:jResult[@"WSSE"] forKey:@"loginToken"];
                     
                     // Load user data
                     UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
                     [OVGlobals updateAll:doc];
                     
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
