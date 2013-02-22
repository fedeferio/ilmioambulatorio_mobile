//
//  Event.h
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * db_id;
@property (nonatomic, retain) NSString * event_identifier;

@end
