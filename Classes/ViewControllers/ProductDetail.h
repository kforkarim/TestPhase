//
//  ProductDetail.h
//  TestPhase
//
//  Created by Abdul, Karim (Contractor) on 5/13/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductDetail : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

/* Custom Initialization of the ViewController with product Entry (Dependency Injection Design Pattern Used here) */
- (id)initWithProduct:(Product*)productName;

@end
