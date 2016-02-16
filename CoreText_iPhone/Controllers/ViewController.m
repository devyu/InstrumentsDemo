//
//  ViewController.m
//  CoreText_iPhone
//
//  Created by mac on 11/7/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextImageData.h"
#import "ImageViewController.h"
#import "WebViewController.h"
#import "CoreTextLinkData.h"

NSString *const CTDisplayViewImagePressedNotification = @"CTDisplayViewImagePressedNotification";
NSString *const CTDisplayViewLinkPressedNotification = @"CTDisplayViewLinkPressedNotification";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUserInterface];
    [self setupNotifications];
}

- (void)setupUserInterface {
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = self.ctView.width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content"
                                                     ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path
                                                   config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imagePressed:)
                                                 name:CTDisplayViewImagePressedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(linkPressed:)
                                                 name:CTDisplayViewLinkPressedNotification
                                               object:nil];
}

#pragma mark - 点击图片
- (void)imagePressed:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    CoreTextImageData *imageData = userInfo[@"imageData"];
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    vc.image = [UIImage imageNamed:imageData.name];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 点击链接
- (void)linkPressed:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    CoreTextLinkData *linkData = userInfo[@"linkData"];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = linkData.url;
    webVC.urlTitle = linkData.title;
    [self presentViewController:webVC animated:YES completion:nil];

}

@end
