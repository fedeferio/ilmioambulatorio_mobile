//
//  OVPatientDetailViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import <MobileCoreServices/MobileCoreServices.h>


typedef enum {
    kTypeNormal = 0,
    kTypeTelephone
} FieldType;


@interface OVPatientDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
                                           UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,
                                           UIAlertViewDelegate>
{
    float _tableHeight;
    int _textIndex;
    BOOL _didEdit;
}

@property (nonatomic, retain) UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) Patient *patient;
@property (strong, nonatomic) NSDictionary *patientTemp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayTable;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) NSMutableString *path;
@property (weak, nonatomic) UITextField* currentTextField;

@end
