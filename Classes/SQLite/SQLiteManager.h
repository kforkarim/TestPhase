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

/* Checks if the Database Exists */
+ (BOOL)doesDbExist:(NSString*)databaseName;

/* Checks if TABLE exists within the database */
+ (BOOL)doesTableExist:(NSString*)databaseName;

/* Checks if the PRODUCT Table Got created successfully */
+ (BOOL)didProductTableCreatedSuccessfully:(NSString*)databaseName;

/* Insert The data in PRODUCT Table */
+ (void)insertData:(Product*)product;

/* Query particular Product from PRODUCT Table */
+ (Product*)queryProductTable:(NSString*)productName;

/* Query all products from PRODUCT Table */
+ (void)queryAllProductsFromProductTable:(void (^)(NSMutableArray *products, BOOL finished))completion;

/* Delete all records from PRODUCT Table */
+ (void)deleteAllRecordsFromProductTable:(void (^)(BOOL deleted))completion;

/* Delete a particular records from PRODUCT Table */
+ (void)deleteRecordFromProductTable:(NSString*)productName
                          Completion:(void (^)(BOOL deleted))completion;

/* Update a particular record in PRODUCT Table */
+ (void)updateRecord:(Product*)product;

@end
