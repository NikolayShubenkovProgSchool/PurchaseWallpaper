//
//  WallpapersTableViewController.m
//  PurchaseWallpaper
//
//  Created by Nikolay Shubenkov on 24/10/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "WallpapersTableViewController.h"
#import "ShowAndPurchaseImageViewController.h"
#import "PurchaseInfo.h"

@interface WallpapersTableViewController ()

@property (nonatomic, strong) NSArray *wallpapers;

@end

@implementation WallpapersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PurchaseInfo *info1 = [PurchaseInfo new];
    info1.purchaseID = @"com.ias.inAppPurchaseExample.Wallpaper1";
    info1.image = [UIImage imageNamed:@"wallpaper1"];
    
    NSArray *wallPapers = @[info1];
    
    self.wallpapers = wallPapers;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wallpapers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *wallPaperCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PurchaseInfo *info = [self itemAtIndex:indexPath];
    
    wallPaperCell.imageView.image = info.image;
    
    return wallPaperCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseInfo *info = [self itemAtIndex:indexPath];
    [self performSegueWithIdentifier:@"Show In full Screen" sender:info];
}

- (PurchaseInfo *)itemAtIndex:(NSIndexPath *)indexPath {
    PurchaseInfo *info = self.wallpapers[indexPath.row];
    return info;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ShowAndPurchaseImageViewController class]]){
        ShowAndPurchaseImageViewController *vc = segue.destinationViewController;
        vc.infoToPresent = sender;
    }
}



@end
