//
//  NSManagedObject+RXCopying.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (RXCopying) <NSCopying>

-(void)setRelationshipsToObjectsByIDs:(id)objects;

-(id)deepCopyWithZone:(NSZone *)zone;
-(NSDictionary *)ownedIDs;

@end