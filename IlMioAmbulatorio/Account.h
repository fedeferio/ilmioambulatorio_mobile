//
//  Account.h
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;

@end
