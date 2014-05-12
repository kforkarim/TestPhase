//
//  AppDelegate.h
//  TestPhase
//
//  Created by Karim Abdul on 5/10/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/* This array consists of list of products populated from json into Product Model */
//@property (strong, nonatomic) NSMutableArray *products;

/* loadProductsFromJSON populates Products Mutable Array from JSON file */
// Setup to test in XCTest
- (void)loadProductsFromJSON:(void (^)(NSMutableArray *products, BOOL finished))completion;

@end
