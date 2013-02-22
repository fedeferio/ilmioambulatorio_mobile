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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fetchEventDataInDocument:(UIManagedDocument *)document
{
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        [[OVEventDataHelper sharedHelper] loadData:^{
            
            for (NSDictionary *dictionary in [OVEventDataHelper sharedHelper].events) {
                
                Event *event = nil;
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
                
                request.predicate = [NSPredicate predicateWithFormat:@"db_id = %d", [dictionary[@"id"] intValue]];
                
                NSError *error = nil;
                NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                
                if(match && match.count == 0)
                {
                    event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                          inManagedObjectContext:document.managedObjectContext];
                    event.title = dictionary[@"title"];
                    event.body = dictionary[@"body"];
                    
                    event.db_id = dictionary[@"id"];
                    
                    event.start = [OVGlobals dateFromString:dictionary[@"start"]];
                    event.end = [OVGlobals dateFromString:dictionary[@"end"]];
                    
                    if (granted){
                        EKEvent *ekEvent = [EKEvent eventWithEventStore:self.eventStore];
                        ekEvent.title = event.title;
                        ekEvent.notes = event.body;
                        ekEvent.startDate = event.start;
                        ekEvent.endDate = event.end;
                        [ekEvent setCalendar:[self.eventStore defaultCalendarForNewEvents]];
                        [self.eventStore saveEvent:ekEvent span:EKSpanThisEvent commit:YES error:nil];
                        
                        event.event_identifier = ekEvent.eventIdentifier;
                    } else {
                        event.event_identifier = nil;
                    }
                }
            }
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
        }];
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVEventCell *cell = (OVEventCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVEventCell"];
    if(cell == nil)
        cell = [[OVEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVEventCell"];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [cell.labelTitle setText:event.title];
    [cell.labelStart setText:[dateFormatter stringFromDate:event.start]];
    [cell.labelEnd setText:[dateFormatter stringFromDate:event.end]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.ekEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(self.ekEvent.event_identifier)
    {
        EKEvent* event = [self.eventStore eventWithIdentifier:self.ekEvent.event_identifier];
        
        if (self.eventController == nil) {
            self.eventController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
        }
        [self.eventController setDelegate:self];
        self.eventController.event = event;
        
        // Allow event editing.
        self.eventController.allowsEditing = YES;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.eventController];
        
        [self presentViewController:nav animated:YES completion:nil];
//        [self.navigationController pushViewController:self.eventController animated:YES];
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
        if (success) {
            NSLog(@"ok");
        } else {
            NSLog(@"nope!");
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
    
    [self fetchEventDataInDocument:doc];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
