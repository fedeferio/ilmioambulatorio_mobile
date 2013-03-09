//
//  OVHomeViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 01/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVHomeViewController.h"
#import "OVAppDelegate.h"
#import "OVGlobals.h"
#import "Performance.h"
#import "OVPerformanceDataHelper.h"

@interface OVHomeViewController ()

@end

@implementation OVHomeViewController


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableViewRisultati)
    {
        UITableViewCell* cell = [self.tableViewRisultati dequeueReusableCellWithIdentifier:@"CellResult"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellResult"];
        }
        
        NSDictionary* dict = self.availabilities[indexPath.row];
        
        cell.textLabel.text = dict[@"start"];
        cell.detailTextLabel.text = dict[@"end"];
        
        return cell;
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableViewRisultati)
    {
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableViewRisultati)
    {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableViewRisultati)
    {
        if (self.availabilities == nil) {
            return 0;
        }
        return [self.availabilities count];
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableViewRisultati)
    {
        return nil;
    }
    return    [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == self.tableViewRisultati)
    {
        return 0;
    }
    return    [super tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.tableViewRisultati)
    {
        return nil;
    }
    return    [super sectionIndexTitlesForTableView:tableView];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start"
                                                              ascending:YES]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:[NSDate date]];
    //create a date with these components
    NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:0];
    [components setDay:1];
    [components setYear:0];
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(start >= %@) AND (start <= %@)", startDate, endDate];
    
    [request setPredicate:predicate];
    
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:doc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)fetchPerformances
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Performance"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.performances = [doc.managedObjectContext executeFetchRequest:request error:nil];
    
    [self.pickerPrestazioni reloadAllComponents];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(!self.performances)
    {
        return 0;
    }
    return [self.performances count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Performance *performance;
    performance = self.performances[row];
    
    return performance.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchPerformances];
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
	[notifyCenter addObserverForName:kPerformanceFetchNotification
							  object:nil
							   queue:nil
						  usingBlock:^(NSNotification* notification){
                              // TODO
                              // Reload picker data
                              [self fetchPerformances];
						  }];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.performanceIndex = row;
}

- (IBAction)actionDisponibilita:(id)sender {
    
    if (self.performances == nil || [self.performances count] == 0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.viewPicker.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        self.viewPicker.frame = rect;
    }];
}
- (IBAction)actionConferma:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.viewPicker.frame;
        rect.origin.y = self.view.frame.size.height;
        self.viewPicker.frame = rect;
    }];
    
    [self searchForDisponibilita];
    // Send request to server
}

- (void)searchForDisponibilita
{
    int duration = [((Performance *)self.performances[self.performanceIndex]).duration intValue];
    
    [[OVPerformanceDataHelper sharedHelper] loadSlotsFor:duration onSuccess:^(NSArray *array) {
        self.availabilities = array;
        [self.tableViewRisultati reloadData];
    } onFailure:^{
        NSLog(@"unable to retrieve availabilities");
        // Error message
    }];
}


@end
