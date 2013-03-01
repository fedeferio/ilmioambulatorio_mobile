//
//  OVHomeViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 01/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OVEventViewController.h"

@interface OVHomeViewController : OVEventViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelTitolo;
@property (weak, nonatomic) IBOutlet UIButton *buttonCerca;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRisultati;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPrestazioni;

@property (strong, nonatomic) NSArray *performances;
@property (strong, nonatomic) NSArray *availabilities;
@property int performanceIndex;

@end
