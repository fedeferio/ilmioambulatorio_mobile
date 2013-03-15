//
//  OVPatientDetailViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientDetailViewController.h"
#import "OVPatientDataHelper.h"
#import "OVAppDelegate.h"
#import "OVTableTextCell.h"

@interface OVPatientDetailViewController ()

@end

@implementation OVPatientDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Store data in temp structure
    NSArray *keys = [[[self.patient entity] attributesByName] allKeys];
    self.patientTemp = [self.patient dictionaryWithValuesForKeys:keys];
    
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Salva"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(saveFields)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.hidesBackButton = YES;
    barButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = barButton;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.labelName setText:self.patient.name];
    //[self.imageView setImage:[UIImage imageNamed:patient[@"image"]]];
    
    if(self.patient.image != nil && ![self.patient.image isEqualToString:@""])
    {
        NSData* imgData = [NSData dataWithContentsOfFile:self.patient.image];
        UIImage *image = [UIImage imageWithData:imgData];
        
        [self.buttonImage setImage:image forState:UIControlStateNormal];
        self.path = [NSMutableString stringWithString:self.patient.image];
        
    }
    
    self.arrayTable = @[
                        @{@"label": @"Name", @"placeholder": @"Name", @"tag": @(1), @"type":@(kTypeNormal), @"field":@"name"},
                        @{@"label": @"Surname", @"placeholder": @"Surname", @"tag": @(2), @"type":@(kTypeNormal), @"field":@"surname"},
                        @{@"label": @"Phone", @"placeholder": @"Phone", @"tag": @(3), @"type":@(kTypeTelephone), @"field":@"phone"}
                        ];
    
}

- (void)goBack
{
    if(_didEdit)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                            message:@"Hai effettuato delle modifiche. Vuoi uscire dalla pagina?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Sì", nil];
        [alertView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
    }
    if(buttonIndex > 0)
    {
        [self.patient setValuesForKeysWithDictionary:self.patientTemp];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveFields
{
    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
    }
    
    [self.patient setImage:self.path];
    
    UIManagedDocument* document = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
    _didEdit = NO;
    // Store data in temp structure
    NSArray *keys = [[[self.patient entity] attributesByName] allKeys];
    self.patientTemp = [self.patient dictionaryWithValuesForKeys:keys];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = self.tableView.frame;
    CGRect keyboard;
    NSTimeInterval interval;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboard];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&interval];
    
    _tableHeight = rect.size.height;
    
    rect.size.height = keyboard.origin.y - rect.origin.y - 44;
    [UIView animateWithDuration:interval animations:^{
        [self.tableView setFrame:rect];
    }];
    
    [self scrollToRow];
}

- (void)scrollToRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_textIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect rect = self.tableView.frame;
    CGRect keyboard;
    NSTimeInterval interval;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboard];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&interval];
    
    rect.size.height = _tableHeight;
    [UIView animateWithDuration:interval animations:^{
        [self.tableView setFrame:rect];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    _textIndex = textField.tag;
    [self scrollToRow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* field = self.arrayTable[textField.tag][@"field"];
    NSString* method = [NSString stringWithFormat:@"set%@:", [field capitalizedString]];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.patient performSelector:NSSelectorFromString(method) withObject:textField.text];
#pragma clang diagnostic pop
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVTableTextCell *cell = (OVTableTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVTableTextCell"];
    if(cell == nil)
        cell = [[OVTableTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVTableTextCell"];
    
    NSString *field = self.arrayTable[indexPath.row][@"field"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [cell.textName setText:[self.patient performSelector:NSSelectorFromString(field)]];
#pragma clang diagnostic pop
    
    [cell.labelName setText:self.arrayTable[indexPath.row][@"label"]];
    [cell.textName setPlaceholder:self.arrayTable[indexPath.row][@"placeholder"]];
    [cell.textName setTag:indexPath.row];
    
    [cell.textName setDelegate:self];
    
    return cell;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _didEdit = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)buttonImageClick:(id)sender {
    
    if(self.actionSheet == nil)
    {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Seleziona immagine"
                                                       delegate:self
                                              cancelButtonTitle:@"Annulla"
                                         destructiveButtonTitle:@"Cancella"
                                              otherButtonTitles:@"Libreria",@"Fotocamera", nil];
    }
    
    
    [self.actionSheet showInView:self.view];

}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            self.path = nil;
            [self.buttonImage setImage:nil forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            [self openLibraryPicker];
            break;
        }
        case 2:
        {
            [self openImagePicker];
            break;
        }
        default:
            break;
    }
}

- (void)openLibraryPicker
{
	self.picker = [[UIImagePickerController alloc] init];
	self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	self.picker.allowsEditing = YES;
	self.picker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
	[self.picker setDelegate:self];
    
    [self presentViewController:self.picker animated:YES completion:^{}];
}

- (void)openImagePicker
{
	self.picker = [[UIImagePickerController alloc] init];
    [self.picker setDelegate:self];
	self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
	self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	self.picker.showsCameraControls = YES;
	self.picker.navigationBarHidden = YES;
    self.picker.allowsEditing = YES;
	self.picker.toolbarHidden = YES;
	self.picker.wantsFullScreenLayout = YES;
    
    [self presentViewController:self.picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        [self.buttonImage setImage:image forState:UIControlStateNormal];
        NSData* imageData = UIImageJPEGRepresentation(image, 0.7);
        self.path = [NSMutableString stringWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"imgPatient"]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
        [self.path appendFormat:@"%@.jpeg", [formatter stringFromDate:[NSDate date]]];
        
        [imageData writeToFile:self.path atomically:YES];
        _didEdit = YES;
    }
    
    [self.picker dismissViewControllerAnimated:YES completion:^{}];
	
}


@end
