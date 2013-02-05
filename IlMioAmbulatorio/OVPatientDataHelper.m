//
//  OVPatientDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientDataHelper.h"

@implementation OVPatientDataHelper

static OVPatientDataHelper *sharedHelper;

+(OVPatientDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVPatientDataHelper alloc] init];
    }
    
    return sharedHelper;
}

+(id)alloc
{
    NSAssert(sharedHelper == nil, @"Generic error message");
    return [super alloc];
}

-(void)loadData
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"patients" ofType:@"json"]];
    self.patients = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
}

@end
