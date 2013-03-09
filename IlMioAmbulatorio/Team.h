//
//  Team.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * db_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *hasMember;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addHasMemberObject:(NSManagedObject *)value;
- (void)removeHasMemberObject:(NSManagedObject *)value;
- (void)addHasMember:(NSSet *)values;
- (void)removeHasMember:(NSSet *)values;

@end
