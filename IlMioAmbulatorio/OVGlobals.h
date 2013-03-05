//
//  OVGlobals.h
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define kURLBase @"http://ilmioambulatorio.dev/app_dev.php/"
#define kURLBase @"http://webapp.ilmioambulatorio.it/app_dev.php/"

#define kPatientFetchNotification @"kPatientFetchNotification"
#define kPerformanceFetchNotification @"kPerformanceFetchNotification"

#define kDefaultsGranted    @"granted"

@interface OVGlobals : NSObject

+(NSDate*)dateFromString:(NSString*) string;

+(void)updateAll:(UIManagedDocument*) document;

@end
