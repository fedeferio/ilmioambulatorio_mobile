//
//  OVPerformanceDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 01/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVPerformanceDataHelper.h"
#import "AFHTTPClient.h"
#import "Performance.h"
#import "OVGlobals.h"

@implementation OVPerformanceDataHelper

static OVPerformanceDataHelper *sharedHelper;

+(OVPerformanceDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVPerformanceDataHelper alloc] init];
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
    
	[httpClient getPath:@"mobile/performances"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.performances = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    for (NSDictionary *dictionary in [OVPerformanceDataHelper sharedHelper].performances)
                    {
                        Performance *performance = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Performance"];
                        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", dictionary[@"name"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            performance = [NSEntityDescription insertNewObjectForEntityForName:@"Performance"
                                                                    inManagedObjectContext:document.managedObjectContext];
                            performance.name = dictionary[@"name"];
                            performance.duration = @([dictionary[@"duration"] intValue]);
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

-(void)loadSlotsFor:(int)duration onSuccess:(void (^)(NSArray*))successBlock onFailure:(void (^)())failureBlock
{
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginToken"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURLBase]];
	
    [httpClient setDefaultHeader:@"x-wsse" value:loginToken];
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[httpClient getPath:@"mobile/findSlot"
             parameters:@{@"duration" : @(duration)}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    
                    if (error == nil) {
                        successBlock(array);
                    } else {
                        failureBlock();
                    }                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    failureBlock();
                }];
}


@end
