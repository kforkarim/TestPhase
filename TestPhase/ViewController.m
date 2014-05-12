//
//  ViewController.m
//  TestPhase
//
//  Created by Karim Abdul on 5/10/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Product.h"
#import "SQLiteManager.h"

@interface ViewController ()

@property (nonatomic) NSArray *productList;

@end

@implementation ViewController

@synthesize productList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Get the instance of the application delegate
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Load the Products from JSON to self array
    [appDelegate loadProductsFromJSON:^(NSMutableArray *products, BOOL finished) {
        
        if (finished) {
            
            if (!self.productList) {
                self.productList = [products copy];
                products = nil;
            }
            
            Product *productOne = (Product*)[self.productList objectAtIndex:2];
            [SQLiteManager insertData:productOne];
            Product *product = [SQLiteManager queryProductTable:@"Shirt"];
            NSLog(@"%@",product.colors);
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
