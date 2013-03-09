//
//  OVReportDetailViewController.m
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVReportDetailViewController.h"
#import "OVReportTextCell.h"
#import "ReportField.h"
#import "Report.h"
#import "OVAppDelegate.h"

@interface OVReportDetailViewController ()

@end

@implementation OVReportDetailViewController


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportField *reportField = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    switch ([reportField.type intValue]) {
        case 0:
        {
            // Text Cell
            OVReportTextCell *cell = (OVReportTextCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVReportTextCell"];
            if(cell == nil)
                cell = [[OVReportTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVReportTextCell"];
            
            [cell.labelTitle setText:reportField.name];
            [cell.textDescription setText:reportField.value];
            
            CGRect rect = cell.textDescription.frame;
            rect.size.height = cell.textDescription.contentSize.height;
            cell.textDescription.frame = rect;
            [cell.textDescription setFont:[UIFont systemFontOfSize:14.0]];
            return cell;
            break;
        }
        case 1:
        {
            // Numeric Cell
            UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVReportNumericCell"];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVReportNumericCell"];
            
            [cell.textLabel setText:reportField.name];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", [reportField.value intValue]]];
            
            return cell;
            break;
        }
        default:
            break;
    }
    
    
    return nil;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportField *reportField = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    switch ([reportField.type intValue]) {
        case 0:
        {
            NSString* value = reportField.value;
            CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:14.0]
                            constrainedToSize:CGSizeMake(320, 9999)];
            return size.height + 30 + 10; // textView's origin + padding
            break;
        }
        case 1:
        {
            return 44.0f;
            break;
        }
    }
    return 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpFetchedResultController];
}

-(void)setUpFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReportField"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY belongsToReport.db_id == %@", self.report.db_id];
    
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
