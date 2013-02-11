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
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Salva"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(saveFields)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.labelName setText:self.patient.name];
    //[self.imageView setImage:[UIImage imageNamed:patient[@"image"]]];
    
    self.arrayTable = @[
                        @{@"label": @"Name", @"placeholder": @"Name", @"tag": @(1), @"type":@(kTypeNormal), @"field":@"name"},
                        @{@"label": @"Surname", @"placeholder": @"Surname", @"tag": @(2), @"type":@(kTypeNormal), @"field":@"surname"},
                        @{@"label": @"Phone", @"placeholder": @"Phone", @"tag": @(3), @"type":@(kTypeTelephone), @"field":@"phone"}
                        ];
    
}

- (void)saveFields
{
    UIManagedDocument* document = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
//    NSLog(@"%@", document.fileURL);
    
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
