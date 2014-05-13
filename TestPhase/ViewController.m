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
#import "ListViewController.h"

@interface ViewController ()

/* Populates the products in productList Array once the PRODUCTS have been created */
@property (nonatomic) NSArray *productList;

/* Creates the Product in PRODUCT Table */
- (void)createProduct;

/* Shows Product List in ListViewController */
- (void)showProductList;

@end

@implementation ViewController

@synthesize productList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Add Create Product Button which inserts data from JSON to SQLite
    UIButton *createProductButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createProductButton addTarget:self action:@selector(createProduct) forControlEvents:UIControlEventTouchUpInside];
    [createProductButton setTitle:@"Create Product" forState:UIControlStateNormal];
    createProductButton.frame = CGRectMake(self.view.bounds.origin.x+15,self.view.bounds.origin.y+250,150.0,50.0);
    [self.view addSubview:createProductButton];
    
    
    // Show Product Button display's all the products within the "PRODUCT" Table
    UIButton *showProductButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showProductButton addTarget:self action:@selector(showProductList) forControlEvents:UIControlEventTouchUpInside];
    [showProductButton setTitle:@"Show Product" forState:UIControlStateNormal];
    showProductButton.frame = CGRectMake(self.view.bounds.origin.x+150,self.view.bounds.origin.y+250,150.0,50.0);
    [self.view addSubview:showProductButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create Product

- (void)createProduct {
    
    // Get the instance of the application delegate
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Load the Products from JSON to self array
    [appDelegate loadProductsFromJSON:^(NSMutableArray *products, BOOL finished) {
        
        if (finished) {
            
            if (!self.productList) {
                self.productList = [products copy];
                NSLog(@"%@",self.productList);
                products = nil;
                
                for (Product *product in self.productList) {
                    
                    [SQLiteManager insertData:product];
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product Alert" message:@"Product List got created" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        
    }];
    
}

#pragma mark - Show Product List

- (void)showProductList {
    
    ListViewController *listViewController = [[ListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
