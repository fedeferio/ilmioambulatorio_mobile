//
//  OVClinicDetailViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clinic.h"

typedef enum {
    kTypeNormal = 0
} FieldType;

@interface OVClinicDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) Clinic *clinic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayTable;

@end
