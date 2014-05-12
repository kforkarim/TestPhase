//
//  TestPhaseTests.m
//  TestPhaseTests
//
//  Created by Karim Abdul on 5/10/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "Product.h"

@interface TestPhaseTests : XCTestCase

@end

@implementation TestPhaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadProductsFromJson
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate loadProductsFromJSON:^(NSMutableArray *products, BOOL finished) {
        
        if (finished) {
            XCTAssertNotNil(products);
            Product *productOne = (Product*)[products objectAtIndex:0];
            XCTAssertEqual(productOne.name, @"Table");
        }
        
    }];
}

@end
