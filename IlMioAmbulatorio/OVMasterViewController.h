//
//  OVMasterViewController.h
//  IlMioAmbulatorio
//
//  Created by Andrea on 25/01/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OVDetailViewController;

@interface OVMasterViewController : UITableViewController

@property (strong, nonatomic) OVDetailViewController *detailViewController;

@end
