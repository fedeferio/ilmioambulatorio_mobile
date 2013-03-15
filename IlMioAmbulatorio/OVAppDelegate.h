//
//  OVAppDelegate.h
//  IlMioAmbulatorio
//
//  Created by Andrea on 25/01/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMSlideOutNavigationController;

@interface OVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AMSlideOutNavigationController *slideOut;
@property (strong, nonatomic) UIManagedDocument *dataDocument;

-(void)userDidLogin;
- (void)userDidLogout;

@end
