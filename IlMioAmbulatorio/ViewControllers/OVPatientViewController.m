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
#import "Patient.h"
#import "OVAppDelegate.h"
#import "OVGlobals.h"

@interface OVPatientViewController ()

@end

@implementation OVPatientViewController


//-(void)fetchPatientDataInDocument:(UIManagedDocument *)document
//{
//    [[OVPatientDataHelper sharedHelper] loadData:^{
//        for (NSDictionary *dictionary in [OVPatientDataHelper sharedHelper].patients)
//        {
//            Patient *patient = nil;
//            
//            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
//            request.predicate = [NSPredicate predicateWithFormat:@"cf = %@", dictionary[@"cf"]];
//            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"surname" ascending:YES];
//            
//            request.sortDescriptors = @[sortDescriptor];
//            
//            NSError *error = nil;
//            NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
//            
//            if(match && match.count == 0)
//            {
//                patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
//                                                        inManagedObjectContext:document.managedObjectContext];
//                patient.name = dictionary[@"name"];
//                patient.surname = dictionary[@"surname"];
//                patient.cf = dictionary[@"cf"];
//                patient.dateofBirth = [NSDate date];
//                patient.phone = dictionary[@"phone"];
//            }
//        }
//        
//        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
//        
//    }];
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVPatientCell *cell = (OVPatientCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVPatientCell"];
    if(cell == nil)
        cell = [[OVPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVPatientCell"];
    
    Patient *patient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [cell.labelName setText:patient.name];
    [cell.labelData setText:[dateFormatter stringFromDate:patient.dateofBirth]];
    [cell.labelCF setText:patient.cf];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    Patient *patient = [self.fetchedResultsController objectAtIndexPath:path];
    [((OVPatientDetailViewController *)segue.destinationViewController) setPatient:patient];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"surname"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    UIManagedDocument* doc = ((OVAppDelegate*)[UIApplication sharedApplication].delegate).dataDocument;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:doc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

    [self.tableView reloadData];
    
//    [self fetchPatientDataInDocument:doc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filteredArray = [NSMutableArray array];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
	[notifyCenter addObserverForName:kPatientFetchNotification
							  object:nil
							   queue:nil
						  usingBlock:^(NSNotification* notification){
                              [self.tableView reloadData];
						  }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
