//
//  OVPerformanceDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 01/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVPerformanceDataHelper : NSObject

@property(strong, nonatomic) NSArray *performances;

+(OVPerformanceDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;
-(void)loadSlotsFor:(int)duration onSuccess:(void (^)(NSArray*))successBlock onFailure:(void (^)())failureBlock;

@end
