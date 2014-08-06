//
//  MTImageHandler.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTImageHandler.h"

@implementation MTImageHandler

+ (UIImage *)getDefaultAvatarForFrame:(CGRect)frame
{
    UIImage *squareImage = [UIImage imageNamed:@"defaultAvatar"];
    UIImage *roundImage = [self getAvatarFromImage:squareImage forFrame:frame];
    
    return roundImage;
}

+ (UIImage *)getAvatarFromImage:(UIImage *)image forFrame:(CGRect)frame
{
    UIImage *roundImage;
    
    CGSize origImageSize = image.size;
    float ratio = MAX(frame.size.width / origImageSize.width, frame.size.height / origImageSize.height);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:frame];
    [path addClip];
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (frame.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (frame.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    [[UIColor colorWithRed:0.123548 green:0.128806 blue:0.147417 alpha:1.0] setStroke];
    [path setLineWidth:frame.size.width/10];
    [path stroke];
    
    roundImage = UIGraphicsGetImageFromCurrentImageContext();

    
    return roundImage;
    
}

@end
