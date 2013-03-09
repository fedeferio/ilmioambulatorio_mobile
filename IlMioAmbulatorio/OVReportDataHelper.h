//
//  OVReportDataHelper.h
//  IlMioAmbulatorio
//
//  Created by Develop on 08/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVReportDataHelper : NSObject

@property(strong, nonatomic) NSArray *reports;

+(OVReportDataHelper *)sharedHelper;

-(void)loadData:(void(^)())successBlock inDocument:(UIManagedDocument *)document;


@end
