//
//  OVAccountViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVAccountViewController.h"
#import "OVTableTextCell.h"
#import "OVAppDelegate.h"
#import "OVLoginViewController.h"

#define kColorOrange [UIColor colorWithRed:238.0/255.0 green:148.0/255.0 blue:37.0/255.0 alpha:1]

@interface OVAccountViewController ()

@end

@implementation OVAccountViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVTableTextCell *cell = (OVTableTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVTableTextCellAccount"];
    if(cell == nil)
        cell = [[OVTableTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVTableTextCellAccount"];
    
    NSString *field = self.arrayTable[indexPath.row][@"field"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [cell.textName setText:[self.account performSelector:NSSelectorFromString(field)]];
#pragma clang diagnostic pop
    
    
    [cell.labelName setText:self.arrayTable[indexPath.row][@"label"]];
    [cell.textName setPlaceholder:self.arrayTable[indexPath.row][@"placeholder"]];
    [cell.textName setTag:indexPath.row];
    
    [cell.textName setDelegate:self];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}

- (IBAction)buttonLogoutAction:(id)sender {
    
    [((OVAppDelegate*)[UIApplication sharedApplication].delegate) userDidLogout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.buttonLogout setGradientTint:kColorOrange];
    [self.buttonLogout setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.buttonLogout.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // Get Account data
    [self getAccountData];
    
    self.arrayTable = @[
                        @{@"label": @"Username", @"placeholder": @"Username", @"tag": @(0), @"type":@(kTypeNormal), @"field":@"username"},
                        @{@"label": @"Email", @"placeholder": @"Email", @"tag": @(1), @"type":@(kTypeNormal), @"field":@"email"},
                        @{@"label": @"Name", @"placeholder": @"Name", @"tag": @(2), @"type":@(kTypeNormal), @"field":@"name"},
                        @{@"label": @"Surname", @"placeholder": @"Surname", @"tag": @(3), @"type":@(kTypeNormal), @"field":@"surname"}
                        ];
}


-(void)getAccountData
{
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    NSManagedObjectContext *context = doc.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];

    NSArray *results = [context executeFetchRequest:request error:nil];
    
    self.account = [results objectAtIndex:0];
}





@end
