//
//  AppDelegate.m
//  TestPhase
//
//  Created by Karim Abdul on 5/10/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "AppDelegate.h"
#import "Product.h"

@implementation AppDelegate

//@synthesize products;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    [self loadProductsFromJSON:^(NSMutableArray *products, BOOL finished) {
//        if (finished) {
//            Product *productOne = (Product*)[products objectAtIndex:0];
//            NSLog(@"%@",productOne.name);
//        }
//    }];
//    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadProductsFromJSON:(void (^)(NSMutableArray *products, BOOL finished))completion {
    
    // Retrieve local JSON file called example.json
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    
    // Load the file into an NSData object called JSONData
    
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    // Create an Objective-C object from JSON Data
    
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    // Initialize the array with the capacity driven from JSON
    
    NSMutableArray *productsFronJSON = [[NSMutableArray alloc] initWithCapacity:[JSONObject count]];
    
    // Extract the element and populate with Product Model and then Add to the MutableArray
    
    for (id productList in JSONObject) {
        
        Product *_product = [[Product alloc] init];
        _product.pId = [productList valueForKey:@"pId"];
        _product.name = [productList valueForKey:@"name"];
        _product.description = [productList valueForKey:@"description"];
        _product.regularPrice = [productList valueForKey:@"regularPrice"];
        _product.salePrice = [productList valueForKey:@"salePrice"];
        _product.image = [UIImage imageNamed:[productList valueForKey:@"image"]];
        _product.colors = [productList valueForKey:@"colors"];
        _product.stores = [productList valueForKey:@"stores"];
        
        //Add the product to the MutableArray
        [productsFronJSON addObject:_product];
    }

    BOOL finished = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
            
        if (completion != nil)
            completion(productsFronJSON,finished);
    });

}

@end
