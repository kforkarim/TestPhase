//
//  SQLiteManager.h
//  TestPhase
//
//  Created by Abdul, Karim (Contractor) on 5/12/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface SQLiteManager : NSObject

+ (BOOL)doesDbExist:(NSString*)databaseName;
+ (BOOL)doesTableExist:(NSString*)databaseName;
+ (BOOL)didProductTableCreatedSuccessfully:(NSString*)databaseName;
+ (void)insertData:(Product*)product;
+ (Product*)queryProductTable:(NSString*)productName;

@end
