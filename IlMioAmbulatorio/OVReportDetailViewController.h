//
//  OVReportDetailViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Report.h"

@interface OVReportDetailViewController : CoreDataTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) Report* report;

@end
