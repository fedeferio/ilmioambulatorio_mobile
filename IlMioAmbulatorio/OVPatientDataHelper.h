//
//  OVPatientDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVPatientDataHelper : NSObject

@property(strong, nonatomic) NSArray *patients;

+(OVPatientDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;

@end
