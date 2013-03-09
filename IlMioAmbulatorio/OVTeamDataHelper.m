//
//  OVTeamDataHelper.m
//  IlMioAmbulatorio
//
//  Created by Develop on 05/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVTeamDataHelper.h"
#import "AFHTTPClient.h"
#import "Team.h"
#import "TeamMember.h"
#import "OVGlobals.h"

@implementation OVTeamDataHelper

static OVTeamDataHelper *sharedHelper;

+(OVTeamDataHelper *)sharedHelper
{
    if (!sharedHelper) {
        sharedHelper = [[OVTeamDataHelper alloc] init];
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
    
	[httpClient getPath:@"mobile/teams"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    NSError* error;
                    
                    self.teams = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    for (NSDictionary *dictionary in [OVTeamDataHelper sharedHelper].teams)
                    {
                        Team *team = nil;
                        
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
                        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", dictionary[@"name"]];
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        
                        request.sortDescriptors = @[sortDescriptor];
                        
                        NSError *error = nil;
                        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if(match && match.count == 0)
                        {
                            team = [NSEntityDescription insertNewObjectForEntityForName:@"Team"
                                                                        inManagedObjectContext:document.managedObjectContext];
                            team.name = dictionary[@"name"];
                            team.db_id = @([dictionary[@"id"] intValue]);
                            
                            // Get Team Members
                            NSArray *membersToAdd = [self addTeamMembers:dictionary[@"members"] inDocument:document];
                            team.hasMember = [NSSet setWithArray:membersToAdd];
                            
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

-(NSArray *)addTeamMembers:(NSArray *)membersArray inDocument:(UIManagedDocument *)document
{
    NSMutableArray *addedMembers = [[NSMutableArray alloc] init];
    
    for (NSString *string in membersArray) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TeamMember"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", string];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        
        request.sortDescriptors = @[sortDescriptor];
        
        NSError *error = nil;
        NSArray *match = [document.managedObjectContext executeFetchRequest:request error:&error];
        
        TeamMember *teamMember = nil;
        
        if(match && match.count == 0)
        {
            teamMember = [NSEntityDescription insertNewObjectForEntityForName:@"TeamMember"
                                                 inManagedObjectContext:document.managedObjectContext];
            teamMember.name = string;
            [addedMembers addObject:teamMember];
        }
    }
    
    return addedMembers;
}


@end
