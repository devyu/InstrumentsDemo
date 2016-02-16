//
//  CTDisplayView.h
//  CoreText_iPhone
//
//  Created by mac on 11/7/15.
//  Copyright © 2015 JY. All rights reserved.
//

// 持有 CoreTextData 类的实例，负责将 CTFrameRef 绘制到界面上。

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@interface CTDisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;

@end
