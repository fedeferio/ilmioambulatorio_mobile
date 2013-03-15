//
//  OVGradientView.m
//  IlMioAmbulatorio
//
//  Created by Develop on 14/03/13.
//  Copyright (c) 2013 Openview. All rights reserved.
//

#import "OVGradientView.h"

@implementation OVGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //radial gradient centre point.
    CGPoint startCenter, endCenter;
    startCenter = endCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    //radial gradient radius;
    CGFloat startRadius = 0.0;
    CGFloat endRadius = CGRectGetMidX(rect) > CGRectGetMidY(rect) ? CGRectGetMidX(rect): CGRectGetMidY(rect);
    //gradient locations.
    CGFloat locations[2] = {0.0, 1.0};
    //gradient color components.
    //black color
    CGFloat components[8] = {1.0,1.0,1.0,1,
        0.6, 0.6, 0.6, 0.9};
    //Drawing code.
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Get RGB color space
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //create gradient.
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 2);
    CGColorSpaceRelease(space);
    //draw gradient.
    CGContextDrawRadialGradient(context, gradient, startCenter, startRadius,endCenter,endRadius*2, 1);
    CGGradientRelease(gradient);
}

@end
