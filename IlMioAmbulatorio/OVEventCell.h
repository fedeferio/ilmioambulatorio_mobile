//
//  OVEventCell.h
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OVEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelStart;
@property (weak, nonatomic) IBOutlet UILabel *labelEnd;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
