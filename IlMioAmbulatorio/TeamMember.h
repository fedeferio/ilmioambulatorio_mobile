//
//  TeamMember.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface TeamMember : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *belongsToTeam;
@end

@interface TeamMember (CoreDataGeneratedAccessors)

- (void)addBelongsToTeamObject:(Team *)value;
- (void)removeBelongsToTeamObject:(Team *)value;
- (void)addBelongsToTeam:(NSSet *)values;
- (void)removeBelongsToTeam:(NSSet *)values;

@end
