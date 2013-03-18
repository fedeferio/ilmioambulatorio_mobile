//
//  OVReportDetailViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Report.h"

@interface OVReportDetailViewController : CoreDataTableViewController <UITableViewDelegate, UITableViewDataSource,
UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) Report *report;
@property (strong, nonatomic) NSArray *teams;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTeams;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property int teamIndex;
@property (weak, nonatomic) IBOutlet UILabel *labelTitlePatient;

@end
