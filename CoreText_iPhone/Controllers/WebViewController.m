//
//  WebViewController.m
//  CoreText_iPhone
//
//  Created by mac on 11/19/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *linkTitle;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.linkTitle.text = self.title;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
}
- (IBAction)dismissWebView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




@end
