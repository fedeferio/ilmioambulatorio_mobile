//
//  OVClinicDetailViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVClinicDetailViewController.h"
#import "OVTableTextCell.h"
#import "OVAppDelegate.h"

@interface OVClinicDetailViewController ()

@end

@implementation OVClinicDetailViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [self.arrayTable count]);
    return [self.arrayTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVTableTextCell *cell = (OVTableTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVTableTextCellClinic"];
    if(cell == nil)
        cell = [[OVTableTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVTableTextCellClinic"];
    
    NSString *field = self.arrayTable[indexPath.row][@"field"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [cell.textName setText:[self.clinic performSelector:NSSelectorFromString(field)]];
#pragma clang diagnostic pop
    
    [cell.labelName setText:self.arrayTable[indexPath.row][@"label"]];
    [cell.textName setPlaceholder:self.arrayTable[indexPath.row][@"placeholder"]];
    [cell.textName setTag:indexPath.row];


    [cell setBackgroundColor:[UIColor clearColor]];
    //[cell.textName setDelegate:self];
    
    return cell;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    self.arrayTable = @[
                        @{@"label": @"Name", @"placeholder": @"Name", @"tag": @(1), @"type":@(kTypeNormal), @"field":@"name"},
                        @{@"label": @"Address", @"placeholder": @"Address", @"tag": @(2), @"type":@(kTypeNormal), @"field":@"address"},
                        @{@"label": @"Contacts", @"placeholder": @"Contacts", @"tag": @(3), @"type":@(kTypeNormal), @"field":@"contacts"},
                        @{@"label": @"Opening Time", @"placeholder": @"Opening Time", @"tag": @(4), @"type":@(kTypeNormal), @"field":@"openingTime"},
                        @{@"label": @"Closing Time", @"placeholder": @"Closing Time", @"tag": @(5), @"type":@(kTypeNormal), @"field":@"closingTime"}
                        ];
}

@end
