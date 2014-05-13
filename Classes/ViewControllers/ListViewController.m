//
//  ListViewController.m
//  TestPhase
//
//  Created by Abdul, Karim (Contractor) on 5/12/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "ListViewController.h"
#import "SQLiteManager.h"
#import "ProductDetail.h"

@interface ListViewController ()

/* UITableView to Show the list of the products */
@property (strong,nonatomic) UITableView *productListTableView;

/* Array for Product List in ListViewController */
@property (nonatomic) NSArray *producsList;

@end

@implementation ListViewController

@synthesize productListTableView;
@synthesize producsList;

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
    
    // Set the Dismiss button
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = dismissButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Product List";
    
    // Init UITableView
    if (!self.productListTableView) {
        self.productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        self.productListTableView.delegate = self;
        self.productListTableView.dataSource = self;
        [self.productListTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.view addSubview:self.productListTableView];
    }
    
    
    // Query all the products from the PRODUCT Table, and populate the UITableView
    [SQLiteManager queryAllProductsFromProductTable:^(NSMutableArray *products, BOOL finished) {
        
        if (finished) {
            NSLog(@"finished %i products: %@",finished,products);
            self.producsList = [products copy];
            NSLog(@"%@",self.producsList);
            products = nil;
            [productListTableView reloadData];
        }
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Returns the count from the product array and loads to the datasource
    NSLog(@"%lu",(unsigned long)[producsList count]);
    return [producsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get each Product from the index and load the info to the UITableViewCell
    Product *product = [self.producsList objectAtIndex:indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text =  product.name;
    cell.imageView.image = product.image;
    
    // This is to resize the image in UIImageView
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Allows the user to select the product to view its details
    Product *product = [self.producsList objectAtIndex:indexPath.row];
    ProductDetail *productDetail = [[ProductDetail alloc] initWithProduct:product];
    productDetail.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:productDetail animated:YES];

}

#pragma mark - Dismiss View Controller

- (void)dismissViewController {
                                         
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
