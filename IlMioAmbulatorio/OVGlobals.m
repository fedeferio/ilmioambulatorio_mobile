//
//  OVGlobals.m
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVGlobals.h"
#import "OVAccountDataHelper.h"
#import "OVPatientDataHelper.h"
#import "OVClinicDataHelper.h"
#import "OVEventDataHelper.h"
#import "OVPerformanceDataHelper.h"
#import "OVTeamDataHelper.h"
#import "OVReportDataHelper.h"

@implementation OVGlobals

+(NSDate*)dateFromString:(NSString*) string{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [formatter dateFromString:string];
    
    return date;
}

+(void)updateAll:(UIManagedDocument*) document{
    
    // Load Account data
    [[OVAccountDataHelper sharedHelper] loadData:nil inDocument:document];
    
    // Load Patients data
    [[OVPatientDataHelper sharedHelper] loadData:nil inDocument:document];
    
    // Load Events data
    [[OVEventDataHelper sharedHelper] loadData:nil inDocument:document];

    // Load Performance data
    [[OVPerformanceDataHelper sharedHelper] loadData:nil inDocument:document];
    
    // Load Clinic data
    [[OVClinicDataHelper sharedHelper] loadData:nil inDocument:document];
    
    // Load Team data
    [[OVTeamDataHelper sharedHelper] loadData:nil inDocument:document];
    
    // Load Report data
    [[OVReportDataHelper sharedHelper] loadData:nil inDocument:document];

}

@end
