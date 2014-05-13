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

@property (strong,nonatomic) UITableView *productListTableView;
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Product List";
    
    if (!self.productListTableView) {
        self.productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        self.productListTableView.delegate = self;
        self.productListTableView.dataSource = self;
        [self.productListTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.view addSubview:self.productListTableView];
    }
    
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

    NSLog(@"%lu",(unsigned long)[producsList count]);
    return [producsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Product *product = [self.producsList objectAtIndex:indexPath.row];
    cell.textLabel.text =  product.name;
    cell.imageView.image = product.image;
    NSLog(@"%@",product.image);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.producsList objectAtIndex:indexPath.row];
    ProductDetail *productDetail = [[ProductDetail alloc] initWithProduct:product];
    productDetail.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:productDetail animated:YES];

}

@end
