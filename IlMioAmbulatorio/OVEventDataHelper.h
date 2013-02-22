//
//  OVEventDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 21/02/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVEventDataHelper : NSObject

@property(strong, nonatomic) NSArray *events;

+(OVEventDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock;


@end
