//
//  OVPatientViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientViewController.h"
#import "OVPatientCell.h"
#import "OVPatientDataHelper.h"
#import "OVPatientDetailViewController.h"

@interface OVPatientViewController ()

@end

@implementation OVPatientViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSearching)
        return [self.filteredArray count];
    
    return [[OVPatientDataHelper sharedHelper].patients count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVPatientCell *cell = (OVPatientCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVPatientCell"];
    if(cell == nil)
        cell = [[OVPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVPatientCell"];

    NSDictionary *dictionary;
    
    if(self.isSearching)
        dictionary = self.filteredArray[indexPath.row];
    else
        dictionary = [OVPatientDataHelper sharedHelper].patients[indexPath.row];
    
    [cell.labelName setText:dictionary[@"name"]];
    [cell.labelData setText:dictionary[@"birthDate"]];
    [cell.labelCF setText:dictionary[@"cf"]];
  
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];

    NSDictionary *dictionary;
    
    if(self.isSearching)
        dictionary = self.filteredArray[path.row];
    else
        dictionary = [OVPatientDataHelper sharedHelper].patients[path.row];
    
    [((OVPatientDetailViewController *)segue.destinationViewController) setPatientId:[dictionary[@"id"] intValue]];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.isSearching = NO;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(controller.searchBar.text.length > 0)
    {
        self.isSearching = YES;
        [self.filteredArray removeAllObjects];
        
        for (NSDictionary *dictionary in [OVPatientDataHelper sharedHelper].patients) {
            if([[dictionary[@"name"] lowercaseString] rangeOfString:searchString].location != NSNotFound) {
                [self.filteredArray addObject:dictionary];
            }
        }
        
    }
    else
        self.isSearching = NO;
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[OVPatientDataHelper sharedHelper] loadData];
    self.filteredArray = [NSMutableArray array];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
