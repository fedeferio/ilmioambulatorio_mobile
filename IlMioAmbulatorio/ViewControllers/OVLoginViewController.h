//
//  OVLoginViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 25/01/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class GradientButton;

@interface OVLoginViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet GradientButton *buttonLogin;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end
