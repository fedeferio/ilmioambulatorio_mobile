//
//  OVReportDetailViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVReportDetailViewController.h"
#import "OVReportTextCell.h"
#import "ReportField.h"
#import "Report.h"
#import "Team.h"
#import "OVAppDelegate.h"

@interface OVReportDetailViewController ()

@end

@implementation OVReportDetailViewController


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportField *reportField = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    switch ([reportField.type intValue]) {
        case 0:
        {
            // Text Cell
            OVReportTextCell *cell = (OVReportTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVReportTextCell"];
            if(cell == nil)
                cell = [[OVReportTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVReportTextCell"];
            
            [cell.labelTitle setText:reportField.name];
            [cell.textDescription setText:reportField.value];
            
            CGRect rect = cell.textDescription.frame;
            rect.size.height = cell.textDescription.contentSize.height;
            cell.textDescription.frame = rect;
            [cell.textDescription setFont:[UIFont systemFontOfSize:14.0]];
            return cell;
            break;
        }
        case 1:
        {
            // Numeric Cell
            UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVReportNumericCell"];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVReportNumericCell"];
            
            [cell.textLabel setText:reportField.name];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", [reportField.value intValue]]];
            
            return cell;
            break;
        }
        default:
            break;
    }
    
    
    return nil;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportField *reportField = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    switch ([reportField.type intValue]) {
        case 0:
        {
            NSString* value = reportField.value;
            CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:14.0]
                            constrainedToSize:CGSizeMake(320, 9999)];
            return size.height + 30 + 10; // textView's origin + padding
            break;
        }
        case 1:
        {
            return 44.0f;
            break;
        }
    }
    return 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReportField"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY belongsToReport.db_id == %@", self.report.db_id];
    
    request.predicate = predicate;
    
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:doc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


-(void)fetchTeams
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.teams = [doc.managedObjectContext executeFetchRequest:request error:nil];
    
    [self.pickerTeams reloadAllComponents];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(!self.teams)
    {
        return 0;
    }
    return [self.teams count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Team *team;
    team = self.teams[row];
    
    return team.name;
}


- (IBAction)confirmShare:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.viewPicker.frame;
        rect.origin.y = self.view.frame.size.height;
        self.viewPicker.frame = rect;
    }];
    
    [self applyShare];
}

- (void)applyShare
{
    // Get Team and Report data
    Team *team = (Team *)self.teams[self.teamIndex];
    
    // TODO
    // Send report_id and team_id to web application
    
    // At the moment, app will only display an alertView
    NSString *msgString = [NSString stringWithFormat:@"Il documento è stato condiviso con il team %@", team.name];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Condivisione documento"
                                                        message:msgString
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Condividi"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(shareReport)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    // Load teams for picker
    [self fetchTeams];
}

-(void)shareReport
{
    if (self.teams == nil || [self.teams count] == 0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.viewPicker.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        self.viewPicker.frame = rect;
    }];
}

@end
