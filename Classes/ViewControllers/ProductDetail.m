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

@end

@implementation ProductDetail

@synthesize product;
@synthesize imageView;
@synthesize isFullScreen;
@synthesize previousFrame;
@synthesize textFieldProductName;

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
    isFullScreen = FALSE;
    
    self.imageView = [[UIImageView alloc] initWithImage:self.product.image];
    [self.imageView setFrame:CGRectMake(self.view.bounds.origin.x+20, self.view.bounds.origin.y+80, 100.0, 100.0)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClipsToBounds:YES];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
    tapper.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapper];
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, self.imageView.bounds.size.height+40, 200.0, 100.0)];
    [productName setText:[NSString stringWithFormat:@"Product Name: "]];
    [self.view addSubview:productName];
    
    self.textFieldProductName = [[UITextField alloc] initWithFrame:CGRectMake(productName.frame.size.width-50, productName.frame.origin.y+27, 150.0, 50.0)];
    self.textFieldProductName.delegate = self;
    [self.textFieldProductName setText:self.product.name];
    [self.view addSubview:self.textFieldProductName];
    
    UILabel *productDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productName.frame.origin.y+40, 300.0, 100.0)];
    [productDescription setText:[NSString stringWithFormat:@"Product Description: %@",self.product.description]];
    [self.view addSubview:productDescription];
    
    UILabel *productRegularPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productDescription.frame.origin.y+40, 300.0, 100.0)];
    [productRegularPrice setText:[NSString stringWithFormat:@"Product Reg Price: $%@",self.product.regularPrice]];
    [self.view addSubview:productRegularPrice];
    
    UILabel *productSalePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, productRegularPrice.frame.origin.y+40, 300.0, 100.0)];
    [productSalePrice setText:[NSString stringWithFormat:@"Product Sale Price: $%@",self.product.salePrice]];
    [self.view addSubview:productSalePrice];
    
    UIButton *deleteRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteRecord addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
    [deleteRecord setTitle:@"Delete Record" forState:UIControlStateNormal];
    deleteRecord.frame = CGRectMake(self.view.bounds.origin.x+20, productSalePrice.frame.origin.y+40, 150.0, 150.0);
    [self.view addSubview:deleteRecord];

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

- (void)imgToFullScreen:(UITapGestureRecognizer*)sender {
    
    if (!isFullScreen) {
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            previousFrame = self.imageView.frame;
            [self.imageView setFrame:[[UIScreen mainScreen] bounds]];
        }
                         completion:^(BOOL finished){
            
                             isFullScreen = TRUE;
        }];
        
        return;
    }
    
    else {
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            
            [self.imageView setFrame:previousFrame];
        }
                         completion:^(BOOL finished){
            
                             isFullScreen = FALSE;
        
                         }];
        return;
    }
}

- (void)deleteRecord {
    
    [SQLiteManager deleteRecordFromProductTable:self.product.name Completion:^(BOOL deleted) {
       
        if (deleted) {
            NSLog(@"yes");
            self.product = nil;
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self viewDidLoad];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textFieldProductName]) {
        self.product.name = self.textFieldProductName.text;
        [self reloadInputViews];
    }
    
    [textField resignFirstResponder];
    return NO;
}

@end
