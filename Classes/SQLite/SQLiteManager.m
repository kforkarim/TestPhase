//
//  SQLiteManager.m
//  TestPhase
//
//  Created by Abdul, Karim (Contractor) on 5/12/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "SQLiteManager.h"
#import <sqlite3.h>

@implementation SQLiteManager

+ (BOOL)doesDbExist:(NSString*)databaseName {
    
    NSString *databasePath = [self databasePath:databaseName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        // file doesn't exist, so do whatever copying from bundle or
        // programmatic creation/configuration of the database here.
        const char *dbpath = [databasePath UTF8String];
        sqlite3 *productDB;
        
        if (sqlite3_open(dbpath, &productDB) == SQLITE_OK) {
            return YES;
        }
        
        else {
            
            return NO;
        }
    }
    
    else {
        
        return NO;
    }
}

+ (BOOL)doesTableExist:(NSString*)databaseName {
    
    NSString *databasePath = [self databasePath:databaseName];
    const char *dbpath = [databasePath UTF8String];
    sqlite3 *productDB;
    
    if (sqlite3_open(dbpath, &productDB) == SQLITE_OK) {
        
        //NSString *query = @"SELECT * FROM product;";
        char* errInfo;
        const char *query = "SELECT pId FROM PRODUCT;";
        int result = sqlite3_exec(productDB, query, nil, nil, &errInfo);
        
        NSLog(@"%i",result);
        
        if (SQLITE_OK == result) {
            NSLog(@"Row Queried");
            return YES;
        }
        
        else {
            NSString* err = [[NSString alloc]initWithUTF8String:errInfo];
            NSLog(@"error in quirying %@",err);
            return NO;
        }
    }
    
    // If the DB didn't open
    else {
        
        return NO;
    }
}

+ (BOOL)didProductTableCreatedSuccessfully:(NSString*)databaseName {
    
    NSString *databasePath = [self databasePath:databaseName];
    const char *dbpath = [databasePath UTF8String];
    sqlite3 *productDB;
    
    if (sqlite3_open(dbpath, &productDB) == SQLITE_OK) {
        
        //NSString *query = @"SELECT * FROM product;";
        char* errInfo;
        const char *query = "CREATE TABLE PRODUCT (pId TEXT PRIMARY KEY  NOT NULL , name TEXT, description TEXT, regularPrice TEXT, salePrice TEXT, image BLOB, colors BLOB, stores BLOB);";
        int result = sqlite3_exec(productDB, query, nil, nil, &errInfo);
        
        NSLog(@"%i",result);
        
        if (SQLITE_OK == result) {
            NSLog(@"Table Created");
            return YES;
        }
        
        else {
            NSString* err = [[NSString alloc]initWithUTF8String:errInfo];
            NSLog(@"error in creating %@",err);
            return NO;
        }
    }

    return NO;
}

+ (void)insertData:(Product*)product {
    
    
    NSString *databasePath = [self databasePath:@"products.sqlite"];
    const char *dbpath = [databasePath UTF8String];
    sqlite3 *productDB;
    sqlite3_stmt *statement;
    
    const char *insertQuery = "INSERT INTO `PRODUCT` (`pId`, `name`, `description`, `regularPrice`, `salePrice`, `image`, `colors`, `stores`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    // Prepare the data to bind.
    NSData *imageData = UIImagePNGRepresentation(product.image);
    NSData *colorsData = [NSKeyedArchiver archivedDataWithRootObject:product.colors];
    NSData *storesData = [NSKeyedArchiver archivedDataWithRootObject:product.stores];


    if (sqlite3_open(dbpath, &productDB) == SQLITE_OK) {
    
        // Prepare the statement.
        if (sqlite3_prepare_v2(productDB, insertQuery, -1, &statement, NULL) == SQLITE_OK) {
            // Bind the parameters (note that these use a 1-based index, not 0).
            sqlite3_bind_text(statement, 1, [product.pId UTF8String], -1, 0);
            sqlite3_bind_text(statement, 2, [product.name UTF8String], -1, 0);
            sqlite3_bind_text(statement, 3, [product.description UTF8String], -1, 0);
            sqlite3_bind_text(statement, 4, [product.regularPrice UTF8String], -1, 0);
            sqlite3_bind_text(statement, 5, [product.salePrice UTF8String], -1, 0);
            sqlite3_bind_blob(statement, 6, [imageData bytes], [imageData length], SQLITE_STATIC);
            sqlite3_bind_blob(statement, 7, [colorsData bytes], [colorsData length], SQLITE_STATIC);
            sqlite3_bind_blob(statement, 8, [storesData bytes], [storesData length], SQLITE_STATIC);
            // SQLITE_STATIC tells SQLite that it doesn't have to worry about freeing the binary data.
        }
        
        else {
            NSLog(@"Error while creating update statement. '%s'", sqlite3_errmsg(productDB));
        }
    
        // Execute the statement.
        if (sqlite3_step(statement) != SQLITE_DONE) {
            // error handling...
            NSLog(@"Error while creating update statement. '%s'", sqlite3_errmsg(productDB));
        }
        
    // Clean up and delete the resources used by the prepared statement.
    sqlite3_finalize(statement);
    sqlite3_close(productDB);
    
    }

}

+ (Product*)queryProductTable:(NSString*)productName {
    
    // Now let's try to query! Just select the data column.
    NSString *databasePath = [self databasePath:@"products.sqlite"];
    const char *dbpath = [databasePath UTF8String];
    sqlite3 *productDB;
    const char *selectSql = "SELECT * FROM `PRODUCT` WHERE `name` = ?";
    sqlite3_stmt *selectStatement;
    
    if (sqlite3_open(dbpath, &productDB) == SQLITE_OK) {
    
        if (sqlite3_prepare_v2(productDB, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
            // Bind the name parameter.
            sqlite3_bind_text(selectStatement, 1, [productName UTF8String], -1, 0);
        }
    
        // Execute the statement and iterate over all the resulting rows.
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            // We got a row back. Let's extract that BLOB.
            // Notice the columns have 0-based indices here.
            
            Product *selectedProduct = [[Product alloc] init];
            
            selectedProduct.pId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
            selectedProduct.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
            selectedProduct.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)];
            selectedProduct.regularPrice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3)];
            selectedProduct.salePrice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4)];
            
            const void *blobBytesOne = sqlite3_column_blob(selectStatement, 5);
            int blobBytesLengthOne = sqlite3_column_bytes(selectStatement, 5); // Count the number of bytes in the BLOB.
            NSData *imageData = [NSData dataWithBytes:blobBytesOne length:blobBytesLengthOne];
            UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
            selectedProduct.image = image;
            
            const void *blobBytesTwo = sqlite3_column_blob(selectStatement, 6);
            int blobBytesLengthTwo = sqlite3_column_bytes(selectStatement, 6); // Count the number of bytes in the BLOB.
            NSData *colorsData = [NSData dataWithBytes:blobBytesTwo length:blobBytesLengthTwo];
            NSArray *colors = [NSKeyedUnarchiver unarchiveObjectWithData:colorsData];
            selectedProduct.colors = colors;
            
            const void *blobBytesThree = sqlite3_column_blob(selectStatement, 6);
            int blobBytesLengthThree = sqlite3_column_bytes(selectStatement, 6); // Count the number of bytes in the BLOB.
            NSData *storesData = [NSData dataWithBytes:blobBytesThree length:blobBytesLengthThree];
            NSDictionary *stores = [NSKeyedUnarchiver unarchiveObjectWithData:storesData];
            selectedProduct.stores = stores;
            
            return selectedProduct;
        }
    
        // Clean up the select statement
        sqlite3_finalize(selectStatement);
    
        // Close the connection to the database.
        sqlite3_close(productDB);
    }
    
    else {
        
        return nil;
    }
    
    return nil;
}

+ (NSString*)databasePath:(NSString*)dbName {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:dbName]];
    
    return databasePath;
}

@end
