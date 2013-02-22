//
//  OVGlobals.m
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVGlobals.h"

@implementation OVGlobals

+(NSDate*)dateFromString:(NSString*) string{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [formatter dateFromString:string];
    
    return date;
}

@end
