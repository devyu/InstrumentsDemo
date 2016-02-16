//
//  ImageViewController.m
//  CoreText_iPhone
//
//  Created by mac on 11/19/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = self.image;
    [self adjustImageView];
}

- (void)adjustImageView {
    CGPoint center = self.imageView.center;
    CGFloat height = self.image.size.height * self.image.size.width / self.imageView.width;
    self.imageView.height = height;
    self.imageView.center = center;
}

- (IBAction)dismissVC:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}



@end
