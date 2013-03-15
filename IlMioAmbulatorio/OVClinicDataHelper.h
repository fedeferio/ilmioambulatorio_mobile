//
//  OVClinicDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVClinicDataHelper : NSObject

@property(strong, nonatomic) NSArray *clinics;

+(OVClinicDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;


@end
