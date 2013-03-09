//
//  OVTeamMembersViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVTeamMembersViewController.h"
#import "OVAppDelegate.h"
#import "TeamMember.h"


@interface OVTeamMembersViewController ()

@end

@implementation OVTeamMembersViewController

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVTeamMemberCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVTeamMemberCell"];
    
    TeamMember *teamMember = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:teamMember.name];
    return cell;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TeamMember"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY belongsToTeam.name == %@", self.team.name];
    
    request.predicate = predicate;
    
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
