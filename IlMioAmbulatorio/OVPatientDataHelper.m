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
    // Get login token stored in application
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    // Define AFHTTPClient using web application url
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
    [httpClient setDefaultHeader:@"x-wsse" value:loginToken];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Get patients data
	[httpClient getPath:@"mobile/patients"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    // Get patients data in JSON format and put them into an array
                    self.patients = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    // Loop through array elements
                    for (NSDictionary *dictionary in [OVPatientDataHelper sharedHelper].patients)
                    {
                        Patient *patient = nil;
                        // Get all patients stored in application
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
                        request.predicate = [NSPredicate predicateWithFormat:@"cf = %@", dictionary[@"cf"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"surname" ascending:YES];
                        request.sortDescriptors = @[sortDescriptor];
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        // If there's a new patient, add it to Patient entity
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
