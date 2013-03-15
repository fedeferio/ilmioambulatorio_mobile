//
//  Clinic.h
//  IlMioAmbulatorio
//
//  Created by Develop on 12/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Clinic : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * contacts;
@property (nonatomic, retain) NSString * openingTime;
@property (nonatomic, retain) NSString * closingTime;

@end
