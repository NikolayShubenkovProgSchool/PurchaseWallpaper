//
//  ShowAndPurchaseImageViewController.m
//  PurchaseWallpaper
//
//  Created by Nikolay Shubenkov on 24/10/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

@import StoreKit;
@import AssetsLibrary;

#import "ShowAndPurchaseImageViewController.h"

@interface ShowAndPurchaseImageViewController () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ShowAndPurchaseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.infoToPresent.image;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buyPressed:(id)sender {
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments]){
        
        NSSet *set = [NSSet setWithObject:self.infoToPresent.purchaseID];
        SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    NSLog(@"found products: %@",products);
    
    SKProduct *product = [products firstObject];
    if (product == nil){
        //Что-то пошло не так, нужно об этом собщить пользователю
        return;
    }
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tr in transactions){
        switch (tr.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                [self savePictureInGallery];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                //Сообщить о том, что что-то пошло не так
                NSLog(@"Печаль. Пользователь отказался от выгодного предложения");
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)savePictureInGallery {
    CGImageRef imageRef = self.infoToPresent.image.CGImage;
    NSDictionary *metadata = [NSDictionary new]; // you can add
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:imageRef metadata:metadata completionBlock:^(NSURL *assetURL,NSError *error){
        if(error) {
            NSLog(@"Image save eror");
        }
    }];
}

@end
