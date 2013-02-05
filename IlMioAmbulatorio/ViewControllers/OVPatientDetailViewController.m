//
//  OVPatientDetailViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientDetailViewController.h"
#import "OVPatientDataHelper.h"

@interface OVPatientDetailViewController ()

@end

@implementation OVPatientDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDictionary *patient = [self searchPatientById:self.patientId];
    [self.labelName setText:patient[@"name"]];
    [self.imageView setImage:[UIImage imageNamed:patient[@"image"]]];
    
}

- (NSDictionary *)searchPatientById:(int)patientId
{
    for (NSDictionary *dictionary in [OVPatientDataHelper sharedHelper].patients) {
        if([dictionary[@"id"] intValue] == patientId)
        {
            return dictionary;
        }
    }
    
    return nil;
}

@end
