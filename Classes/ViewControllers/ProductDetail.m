//
//  ProductDetail.m
//  TestPhase
//
//  Created by Abdul, Karim (Contractor) on 5/13/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "ProductDetail.h"
#import "SQLiteManager.h"

@interface ProductDetail ()

@property (nonatomic) Product *product;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign) BOOL isFullScreen;
@property (assign) CGRect previousFrame;
@property (strong, nonatomic) UITextField *textFieldProductName;
@property (strong, nonatomic) UITextField *textFieldProductDescription;
@property (strong, nonatomic) UITextField *textFieldProductRegularPrice;
@property (strong, nonatomic) UITextField *textFieldProductSalePrice;
@property (strong, nonatomic) UIView *proxyView;
@property (nonatomic) UITapGestureRecognizer *tapGestureForImageView;

@end

@implementation ProductDetail

@synthesize product;
@synthesize imageView;
@synthesize isFullScreen;
@synthesize previousFrame;
@synthesize textFieldProductName;
@synthesize textFieldProductDescription;
@synthesize textFieldProductRegularPrice;
@synthesize textFieldProductSalePrice;
@synthesize proxyView;
@synthesize tapGestureForImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Setting the FullScreen Flag by default to FALSE
    isFullScreen = FALSE;
    
    // Setup Custom SubView's
    [self setupImageView];
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, self.imageView.bounds.size.height+40, 200.0, 100.0)];
    [productName setText:[NSString stringWithFormat:@"Product Name: "]];
    [self.view addSubview:productName];
    
    self.textFieldProductName = [[UITextField alloc] initWithFrame:CGRectMake(productName.frame.size.width-50, productName.frame.origin.y+27, 150.0, 50.0)];
    self.textFieldProductName.delegate = self;
    [self.textFieldProductName setText:self.product.name];
    [self.view addSubview:self.textFieldProductName];
    
    UILabel *productDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productName.frame.origin.y+40, 200.0, 100.0)];
    [productDescription setText:[NSString stringWithFormat:@"Product Description: "]];
    [self.view addSubview:productDescription];
    
    self.textFieldProductDescription = [[UITextField alloc] initWithFrame:CGRectMake(productDescription.frame.size.width-20, productDescription.frame.origin.y+27, 150.0, 50.0)];
    self.textFieldProductDescription.delegate = self;
    [self.textFieldProductDescription setText:self.product.description];
    [self.view addSubview:self.textFieldProductDescription];
    
    UILabel *productRegularPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productDescription.frame.origin.y+40, 200.0, 100.0)];
    [productRegularPrice setText:[NSString stringWithFormat:@"Product Reg Price: $ "]];
    [self.view addSubview:productRegularPrice];
    
    self.textFieldProductRegularPrice = [[UITextField alloc] initWithFrame:CGRectMake(productRegularPrice.frame.size.width-20, productRegularPrice.frame.origin.y+27, 150.0, 50.0)];
    self.textFieldProductRegularPrice.delegate = self;
    [self.textFieldProductRegularPrice setText:self.product.regularPrice];
    [self.view addSubview:self.textFieldProductRegularPrice];
    
    UILabel *productSalePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productRegularPrice.frame.origin.y+40, 200.0, 100.0)];
    [productSalePrice setText:[NSString stringWithFormat:@"Product Sale Price: $ "]];
    [self.view addSubview:productSalePrice];
    
    self.textFieldProductSalePrice = [[UITextField alloc] initWithFrame:CGRectMake(productSalePrice.frame.size.width-20, productSalePrice.frame.origin.y+27, 150.0, 50.0)];
    self.textFieldProductSalePrice.delegate = self;
    [self.textFieldProductSalePrice setText:self.product.salePrice];
    [self.view addSubview:self.textFieldProductSalePrice];
    
    UIButton *deleteRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteRecord addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
    [deleteRecord setTitle:@"Delete Record" forState:UIControlStateNormal];
    deleteRecord.frame = CGRectMake(self.view.bounds.origin.x+20, productSalePrice.frame.origin.y+140, 150.0, 50.0);
    [self.view addSubview:deleteRecord];
    
    UIButton *updateRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateRecord addTarget:self action:@selector(updateRecord) forControlEvents:UIControlEventTouchUpInside];
    [updateRecord setTitle:@"Update Record" forState:UIControlStateNormal];
    updateRecord.frame = CGRectMake(self.view.bounds.origin.x+140, productSalePrice.frame.origin.y+140, 150.0, 50.0);
    [self.view addSubview:updateRecord];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithProduct:(Product*)productName {
    
    self = [super init];
    
    if (self) {
        self.product = productName;
        NSLog(@"%@",self.product);
    }
    
    return self;
}

#pragma mark - Image to Full Screen

- (void)imgToFullScreen:(UITapGestureRecognizer*)sender {
    
    if (!isFullScreen) {
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            
            if (!self.proxyView) {
                self.proxyView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
            }
            
            previousFrame = self.imageView.frame;
            [self.proxyView addSubview:self.imageView];
            [self.proxyView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:self.proxyView];
            self.imageView.frame = self.view.bounds;
            
        }
                         completion:^(BOOL finished) {
            
                             isFullScreen = TRUE;
        }];
        
        return;
    }
    
    else {
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            
            [self.imageView setFrame:previousFrame];

        }
                         completion:^(BOOL finished) {
                             [self.proxyView removeFromSuperview];
                             self.proxyView = nil;
                             isFullScreen = FALSE;
                             [self setupImageView];
                         }];
        return;
    }

}

#pragma mark - Delete Record

- (void)deleteRecord {
    
    [SQLiteManager deleteRecordFromProductTable:self.product.name Completion:^(BOOL deleted) {
       
        if (deleted) {
            NSLog(@"yes");
            self.product = nil;
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.imageView = nil;
            [self viewDidLoad];
        }
    }];
}

#pragma mark - Update Record

- (void)updateRecord {
    
    if (self.product) {
        [SQLiteManager updateRecord:self.product];
    }
    
}

#pragma mark - UITextField Delegate to set Text to Model

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textFieldProductName]) {
        self.product.name = self.textFieldProductName.text;
    }
    
    if ([textField isEqual:self.textFieldProductDescription]) {
        self.product.description = self.textFieldProductDescription.text;
    }
    
    if ([textField isEqual:self.textFieldProductRegularPrice]) {
        self.product.regularPrice = self.textFieldProductRegularPrice.text;
    }

    if ([textField isEqual:self.textFieldProductSalePrice]) {
        self.product.salePrice = self.textFieldProductSalePrice.text;
    }
    
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Setup ImageView

- (void)setupImageView {
    
    if (!self.imageView) {
         self.imageView = [[UIImageView alloc] initWithImage:self.product.image];
    }
    [self.imageView setFrame:CGRectMake(self.view.bounds.origin.x+20, self.view.bounds.origin.y+80, 100.0, 100.0)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClipsToBounds:YES];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    if (!self.tapGestureForImageView) {
        self.tapGestureForImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
    }
    
    self.tapGestureForImageView.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:self.tapGestureForImageView];
}

@end
