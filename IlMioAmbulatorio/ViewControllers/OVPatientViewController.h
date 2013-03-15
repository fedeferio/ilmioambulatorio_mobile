//
//  OVPatientViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface OVPatientViewController : CoreDataTableViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property BOOL isSearching;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarPatient;

@end
