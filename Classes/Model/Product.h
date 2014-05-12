//
//  Product.h
//  TestPhase
//
//  Created by Karim Abdul on 5/10/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic) NSString *pId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *regularPrice;
@property (nonatomic) NSString *salePrice;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSArray *colors;
@property (nonatomic) NSDictionary *stores;

@end
