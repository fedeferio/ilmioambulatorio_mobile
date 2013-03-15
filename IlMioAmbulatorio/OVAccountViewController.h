//
//  OVAccountViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "GradientButton.h"

typedef enum {
    kTypeNormal = 0
} FieldType;

@interface OVAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *arrayTable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Account *account;
@property (weak, nonatomic) IBOutlet GradientButton *buttonLogout;

@end
