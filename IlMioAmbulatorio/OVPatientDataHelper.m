//
//  OVPatientDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPatientDataHelper.h"
#import "AFHTTPClient.h"
#import "Patient.h"
#import "OVGlobals.h"

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

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document
{
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
	
    [httpClient setDefaultHeader:@"x-wsse" value:loginToken];
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"mobile/patients"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.patients = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    
                    for (NSDictionary *dictionary in [OVPatientDataHelper sharedHelper].patients)
                    {
                        Patient *patient = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
                        request.predicate = [NSPredicate predicateWithFormat:@"cf = %@", dictionary[@"cf"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"surname" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
                                                                    inManagedObjectContext:document.managedObjectContext];
                            patient.name = dictionary[@"name"];
                            patient.surname = dictionary[@"surname"];
                            patient.cf = dictionary[@"cf"];
                            patient.dateofBirth = [NSDate date];
                            patient.phone = dictionary[@"phone"];
                        }
                    }
                    
                    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
                    if (successBlock) {
                    successBlock();                        
                    }

                    // Notification Center --> Set up to reload patient table data
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPatientFetchNotification object:self userInfo:nil];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];    
}


@end
