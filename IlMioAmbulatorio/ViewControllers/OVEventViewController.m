//
//  OVEventViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVEventViewController.h"
#import "OVAppDelegate.h"
#import "OVEventDataHelper.h"
#import "Event.h"
#import "OVEventCell.h"
#import "OVGlobals.h"

@interface OVEventViewController ()

@end

@implementation OVEventViewController


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVEventCell *cell = (OVEventCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVEventCell"];
    if(cell == nil)
        cell = [[OVEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVEventCell"];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [cell.labelTitle setText:event.body];
    [cell.labelEnd setText:[dateFormatter stringFromDate:event.start]];
    [cell.labelStart setText:[dateFormatter stringFromDate:event.end]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.ekEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(self.ekEvent.event_identifier)
    {
        // Define EKEvent object using event_identifier
        EKEvent* event = [[OVEventDataHelper sharedHelper].eventStore eventWithIdentifier:self.ekEvent.event_identifier];
        // Define EKEventViewController object
        if (self.eventController == nil) {
            self.eventController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
        }
        [self.eventController setDelegate:self];
        // Link EKEventViewController to EKEvent
        self.eventController.event = event;
        // Allow event editing.
        self.eventController.allowsEditing = YES;
        // Move to the just defined controller
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.eventController];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
    self.ekEvent.title = controller.event.title;
    self.ekEvent.start = controller.event.startDate;
    self.ekEvent.end = controller.event.endDate;
    self.ekEvent.body = controller.event.notes;
    
    
    UIManagedDocument* document = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Unable to save document");
        }
    }];

    [self.tableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Eventi"];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start"
                                                              ascending:YES]];
    
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:doc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
