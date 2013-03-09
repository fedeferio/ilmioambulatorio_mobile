//
//  Report.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ReportField;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * patient;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSSet *hasField;
@end

@interface Report (CoreDataGeneratedAccessors)

- (void)addHasFieldObject:(ReportField *)value;
- (void)removeHasFieldObject:(ReportField *)value;
- (void)addHasField:(NSSet *)values;
- (void)removeHasField:(NSSet *)values;

@end
