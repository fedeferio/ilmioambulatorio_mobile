//
//  OVEventViewController.h
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class Event;

@interface OVEventViewController : CoreDataTableViewController<EKEventViewDelegate>

@property (strong, nonatomic) EKEventStore* eventStore;
@property (strong, nonatomic) EKEventViewController *eventController;
@property (strong, nonatomic) Event* ekEvent;


@end
