//
//  Team.m
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "Team.h"


@implementation Team

@dynamic db_id;
@dynamic name;
@dynamic hasMember;

- (NSString*)description
{
    return [NSString stringWithFormat:@"Team with name: %@ and %d members", self.name, [self.hasMember count]];
}

@end
