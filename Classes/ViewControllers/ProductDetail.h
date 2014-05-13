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

- (id)initWithProduct:(Product*)productName;

@end
