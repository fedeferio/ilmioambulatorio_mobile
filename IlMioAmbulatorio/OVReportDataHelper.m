//
//  OVReportDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "Report.h"
#import "ReportField.h"
#import "AFHTTPClient.h"
#import "OVGlobals.h"
#import "OVReportDataHelper.h"

@implementation OVReportDataHelper

static OVReportDataHelper *sharedHelper;

+(OVReportDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVReportDataHelper alloc] init];
    }
    
    return sharedHelper;
}

+(id)alloc
{
    NSAssert(sharedHelper == nil, @"Generic error message");
    return [super alloc];
}

-(void)loadData:(void (^)())successBlock inDocument:(UIManagedDocument *)document
{
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
	
    [httpClient setDefaultHeader:@"x-wsse" value:loginToken];
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"mobile/reports"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.reports = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    for (NSDictionary *dictionary in [OVReportDataHelper sharedHelper].reports)
                    {
                        Report *report = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Report"];
                        request.predicate = [NSPredicate predicateWithFormat:@"db_id = %@", dictionary[@"id"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            report = [NSEntityDescription insertNewObjectForEntityForName:@"Report"
                                                                 inManagedObjectContext:document.managedObjectContext];
                            report.name = dictionary[@"type"];
                            report.patient = dictionary[@"patientInfo"];
                            report.db_id = dictionary[@"id"];
                            
                            // Get Report Fields
                            NSArray *fieldsToAdd = [self addReportFields:dictionary[@"fields"] inDocument:document];
                            report.hasField = [NSSet setWithArray:fieldsToAdd];
                            
                        }
                    }
                    
                    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
                    if (successBlock) {
                        successBlock();
                    }
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPerformanceFetchNotification object:self userInfo:nil];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];
}

-(NSArray *)addReportFields:(NSArray *)fieldsArray inDocument:(UIManagedDocument *)document
{
    NSMutableArray *addedFields = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in fieldsArray) {
        
        ReportField *reportField = nil;
        
        reportField = [NSEntityDescription insertNewObjectForEntityForName:@"ReportField"
                                                       inManagedObjectContext:document.managedObjectContext];
        reportField.name = dictionary[@"flabel"];
        reportField.type = @([dictionary[@"ftype"] intValue]);
        if ([dictionary[@"fvalue"] isKindOfClass:[NSNumber class]]) {
            reportField.value = [NSString stringWithFormat:@"%d", [dictionary[@"fvalue"] intValue]];
        } else {
            reportField.value = dictionary[@"fvalue"];
        }

        [addedFields addObject:reportField];
    }
    
    return addedFields;
}

@end
