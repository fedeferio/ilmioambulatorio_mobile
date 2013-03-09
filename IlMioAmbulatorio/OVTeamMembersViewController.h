//
//  OVTeamMembersViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Team.h"

@interface OVTeamMembersViewController : CoreDataTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) Team *team;

@end
