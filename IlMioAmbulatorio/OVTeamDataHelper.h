//
//  OVTeamDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 05/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVTeamDataHelper : NSObject

@property(strong, nonatomic) NSArray *teams;

+(OVTeamDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;   

@end
