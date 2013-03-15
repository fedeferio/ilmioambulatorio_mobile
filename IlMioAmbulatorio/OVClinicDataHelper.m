//
//  OVClinicDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVClinicDataHelper.h"
#import "AFHTTPClient.h"
#import "OVGlobals.h"
#import "Clinic.h"

@implementation OVClinicDataHelper


static OVClinicDataHelper *sharedHelper;

+(OVClinicDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVClinicDataHelper alloc] init];
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
    
	[httpClient getPath:@"mobile/clinics"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.clinics = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    for (NSDictionary *dictionary in [OVClinicDataHelper sharedHelper].clinics)
                    {
                        Clinic *clinic = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Clinic"];
                        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", dictionary[@"name"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            clinic = [NSEntityDescription insertNewObjectForEntityForName:@"Clinic"
                                                                        inManagedObjectContext:document.managedObjectContext];
                            clinic.name = dictionary[@"name"];
                            clinic.address = dictionary[@"address"];
                            clinic.contacts = dictionary[@"contacts"];
                            clinic.openingTime = dictionary[@"openingTime"];
                            clinic.closingTime = dictionary[@"closingTime"];
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


@end
