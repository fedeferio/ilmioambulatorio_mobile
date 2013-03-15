//
//  OVAccountDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVAccountDataHelper.h"
#import "Account.h"
#import "AFHTTPClient.h"
#import "OVGlobals.h"

@implementation OVAccountDataHelper

static OVAccountDataHelper *sharedHelper;

+(OVAccountDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVAccountDataHelper alloc] init];
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
    
	[httpClient getPath:@"mobile/person"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.accounts = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    
                    if(error == nil)
                    {
                        Account *account = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
                        request.predicate = [NSPredicate predicateWithFormat:@"username = %@", self.accounts[@"username"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            account = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                                    inManagedObjectContext:document.managedObjectContext];
                            account.name = self.accounts[@"name"];
                            account.surname = self.accounts[@"surname"];
                            account.username = self.accounts[@"username"];
                            account.email = self.accounts[@"email"];
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
