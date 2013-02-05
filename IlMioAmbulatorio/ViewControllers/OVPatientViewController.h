//
//  OVPatientViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OVPatientViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
