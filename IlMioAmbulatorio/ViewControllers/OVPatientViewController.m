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

@interface OVPatientViewController ()

@end

@implementation OVPatientViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[OVPatientDataHelper sharedHelper].patients count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OVPatientCell *cell = (OVPatientCell *)[self.tableView dequeueReusableCellWithIdentifier:@"OVPatientCell"];
    if(cell == nil)
        cell = [[OVPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OVPatientCell"];

    NSDictionary *dictionary = [OVPatientDataHelper sharedHelper].patients[indexPath.row];
    
    [cell.labelName setText:dictionary[@"name"]];
    [cell.labelData setText:dictionary[@"birthDate"]];
    [cell.labelCF setText:dictionary[@"cf"]];
    
//    [cell.labelName setText:@"Federico Ferrioli"];
//    [cell.labelData setText:@"30/03/1986"];
//    [cell.labelCF setText:@"FRRFRC1234578787"];
//    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSString *title = [NSString stringWithFormat:@"Riga: %d", path.row];
    
    [segue.destinationViewController setTitle:title];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[OVPatientDataHelper sharedHelper] loadData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
