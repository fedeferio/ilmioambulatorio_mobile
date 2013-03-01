//
//  OVEventDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVEventDataHelper.h"
#import "AFHTTPClient.h"
#import "OVGlobals.h"
#import "Event.h"

@implementation OVEventDataHelper

static OVEventDataHelper *sharedHelper;

+(OVEventDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVEventDataHelper alloc] init];
    }
    
    return sharedHelper;
}

- (EKEventStore*)eventStore
{
    if (_eventStore == nil) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
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
    
	[httpClient getPath:@"mobile/calendar"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.events = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    
                    
                    for (NSDictionary *dictionary in [OVEventDataHelper sharedHelper].events) {
                        
                        Event *event = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
                        
                        request.predicate = [NSPredicate predicateWithFormat:@"db_id = %d", [dictionary[@"id"] intValue]];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                  inManagedObjectContext:document.managedObjectContext];
                            event.title = dictionary[@"title"];
                            event.body = dictionary[@"body"];
                            
                            event.db_id = dictionary[@"id"];
                            
                            event.start = [OVGlobals dateFromString:dictionary[@"start"]];
                            event.end = [OVGlobals dateFromString:dictionary[@"end"]];
                            BOOL granted = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsGranted] boolValue];
                            if (granted){
                                EKEvent *ekEvent = [EKEvent eventWithEventStore:self.eventStore];
                                ekEvent.title = event.title;
                                ekEvent.notes = event.body;
                                ekEvent.startDate = event.start;
                                ekEvent.endDate = event.end;
                                [ekEvent setCalendar:[self.eventStore defaultCalendarForNewEvents]];
                                [self.eventStore saveEvent:ekEvent span:EKSpanThisEvent commit:YES error:nil];
                                
                                event.event_identifier = ekEvent.eventIdentifier;
                            } else {
                                event.event_identifier = nil;
                            }
                        }
                    }
                    if (successBlock) {
                        successBlock();
                    }

                    [[NSNotificationCenter defaultCenter] postNotificationName:kPatientFetchNotification object:self userInfo:nil];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];
}

@end
