//
//  Patient.h
//  IlMioAmbulatorio
//
//  Created by Develop on 11/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSDate * dateofBirth;
@property (nonatomic, retain) NSString * cf;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * phone;

@end
