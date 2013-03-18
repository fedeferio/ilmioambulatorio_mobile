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

#define kColorOrange [UIColor colorWithRed:238.0/255.0 green:148.0/255.0 blue:37.0/255.0 alpha:1]

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
    
    self.textUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.textUser.leftViewMode = UITextFieldViewModeAlways;
    self.textUser.background = [[UIImage imageNamed:@"textField.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];

    
    self.textPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.textPassword.leftViewMode = UITextFieldViewModeAlways;
    self.textPassword.background = [[UIImage imageNamed:@"textField.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [self.navigationController.navigationBar setTintColor:kColorOrange];
    [self setTitle:@"Login"];
    
    [self.buttonLogin setGradientTint:kColorOrange];
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
    
    // Show loading circle
    [self.progressHUD show:YES];
    // Define AFHTTPClient object using web application URL
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Get user login paramaters
    NSDictionary* loginParams = @{@"_username":self.textUser.text,@"_password":self.textPassword.text};
    // Get token from web application sending login parameters (username and password)
	[httpClient postPath:@"security/token/create.json"
              parameters:loginParams
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     NSError* error;
                     // Get JSON response and store token in application
                     id jResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                     [[NSUserDefaults standardUserDefaults] setObject:jResult[@"WSSE"] forKey:@"loginToken"];
                     // Update application data
                     UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
                     [OVGlobals updateAll:doc];
                     [((OVAppDelegate*) [UIApplication sharedApplication].delegate) userDidLogin];
                     // Hide loading circle
                     [self.progressHUD hide:YES];                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     // Define alertView with login error info
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
