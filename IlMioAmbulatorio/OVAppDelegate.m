//
//  OVAppDelegate.m
//  IlMioAmbulatorio
//
//  Created by Andrea on 25/01/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVAppDelegate.h"
#import "AMSlideOutNavigationController.h"
#import "OVGlobals.h"

@implementation OVAppDelegate

- (void)userDidLogout
{
//    OVLoginViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UINavigationController* controller = [storyboard instantiateInitialViewController];
    self.window.rootViewController = controller;
}

- (void)userDidLogin
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    // Define a AMSlideOutNavigationController object
    self.slideOut = [AMSlideOutNavigationController slideOutNavigation];
    UIViewController *controller = nil;
    // Add a section
    [self.slideOut addSectionWithTitle:@"Menu"];
    // Add element to created section
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVHomeViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Home" // Element name
                                          andIcon:@"iconHome.png"]; // Element icon
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVPatientViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Pazienti"
                                          andIcon:@"iconPatients"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVEventViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Eventi"
                                          andIcon:@"iconEvent"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVTeamViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Team"
                                          andIcon:@"iconGroup"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVReportViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Documenti"
                                          andIcon:@"iconFolder"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVClinicViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Sedi"
                                          andIcon:@"iconClinic"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVPerformanceViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Prestazioni"
                                          andIcon:@"iconPerformance"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"OVAccountViewController"];
    [self.slideOut addViewControllerToLastSection:controller
                                           tagged:1
                                        withTitle:@"Account"
                                          andIcon:@"iconAccount"];
    
    [self.window setRootViewController:self.slideOut];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:granted forKey:kDefaultsGranted];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"OVData"];
    self.dataDocument = [[UIManagedDocument alloc] initWithFileURL:url];

    [self useDocument];
    
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
	    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
	    splitViewController.delegate = (id)navigationController.topViewController;
	}
    
    return YES;
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.dataDocument.fileURL path]])
    {
        [self.dataDocument saveToURL:self.dataDocument.fileURL
                    forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       
                   }];
    }
    else if(self.dataDocument.documentState == UIDocumentStateClosed)
    {
        [self.dataDocument openWithCompletionHandler:^(BOOL success) {
            
        }];
    }
    else if(self.dataDocument.documentState == UIDocumentStateNormal)
    {
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
