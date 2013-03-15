//
//  OVClinicViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVClinicViewController.h"
#import "OVClinicDetailViewController.h"
#import "OVAppDelegate.h"
#import "Clinic.h"

@interface OVClinicViewController ()

@end

@implementation OVClinicViewController

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVClinicCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVClinicCell"];
    
    Clinic *clinic = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:clinic.name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    Clinic *clinic = [self.fetchedResultsController objectAtIndexPath:path];
    [((OVClinicDetailViewController *)segue.destinationViewController) setClinic:clinic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Clinic"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:doc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
