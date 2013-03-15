//
//  OVPerformanceViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPerformanceViewController.h"
#import "OVAppDelegate.h"
#import "Performance.h"

@interface OVPerformanceViewController ()

@end

@implementation OVPerformanceViewController

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVPerformanceCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OVPerformanceCell"];
    
    Performance *performance = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:performance.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Durata: %@ minuti", performance.duration]];
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Performance"];
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
