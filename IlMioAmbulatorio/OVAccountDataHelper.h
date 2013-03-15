//
//  OVAccountDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVAccountDataHelper : NSObject

@property (strong, nonatomic) NSDictionary *accounts;

+(OVAccountDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;


@end
