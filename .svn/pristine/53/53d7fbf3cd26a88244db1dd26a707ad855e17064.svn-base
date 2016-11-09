//
//  ELCAssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
@interface ELCAssetTablePicker ()

@property (nonatomic, assign) int columns;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation ELCAssetTablePicker

//Using auto synthesizers

- (id)init
{
    self = [super init];
    if (self) {
        //Sets a reasonable default bigger then 0 for columns
        //So that we don't have a divide by 0 scenario
        self.columns = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setAllowsSelection:NO];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
	
    if (self.immediateReturn) {
        
    } else {
        UIButton* r_button = [UIButton buttonWithType:UIButtonTypeCustom];
        r_button.frame =CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        [r_button setTitle:@"完成" forState:UIControlStateNormal];
        [r_button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [r_button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [r_button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lfbv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5f, 44.0f)];
        lfbv.backgroundColor =  [UIColor colorWithRed:55/255.0f green:144/255.0f blue:203/255.0f alpha:1.0f];
        [r_button addSubview:lfbv];
        UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithCustomView:r_button];
        self.navigationItem.rightBarButtonItem =  right;
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0.0f, 6.0f, 23.0f, 23.0f);
    UIImage* img_normal = [UIImage imageNamed:@"leftBack.png"];
    [button setBackgroundImage:img_normal forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =  left;
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

-(void) onBack:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [self.tableView reloadData];
}

- (void)preparePhotos
{
    @autoreleasepool {

        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }

            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAsset setParent:self];
            
            BOOL isAssetFiltered = NO;
            if (self.assetPickerFilterDelegate &&
               [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
            {
                isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
            }

            if (!isAssetFiltered) {
                [self.elcAssets addObject:elcAsset];
            }

         }];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // scroll to bottom
            long section = [self numberOfSectionsInTableView:self.tableView] - 1;
            long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                     inSection:section];
                        [self.tableView scrollToRowAtIndexPath:ip
                                              atScrollPosition:UITableViewScrollPositionBottom
                                                      animated:NO];
            }
            
//            [self.navigationItem setTitle:self.singleSelection ? @"Pick Photo" : @"Pick Photos"];
        });
    }
}

- (void)doneAction:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do time-consuming task in background thread
        // Return back to main thread to update UI
        NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
        for (ELCAsset *elcAsset in self.elcAssets) {
            if ([elcAsset selected]) {
                [selectedAssetsImages addObject:[elcAsset asset]];
            }
        }
        [self.parent selectedAssets:selectedAssetsImages];
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Update UI
        });
    });
}

-(void) loadData
{
    
    [self performSelectorOnMainThread:@selector(hideAlert) withObject:nil waitUntilDone:NO];
}

-(void) hideAlert
{
    [_alert removeFromSuperview];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset
{
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)assetSelected:(ELCAsset *)asset
{
    if (self.singleSelection) {

        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset.asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
    return numRows;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {		        
        cell = [[ELCAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 79;
}

- (int)totalSelectedAssets
{
    int count = 0;
    
    for (ELCAsset *asset in self.elcAssets) {
		if (asset.selected) {
            count++;	
		}
	}
    
    return count;
}


@end
