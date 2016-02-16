//
//  CTDisplayView.m
//  CoreText_iPhone
//
//  Created by mac on 11/7/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"
#import "CoreTextUtils.h"


@interface CTDisplayView ()

@property (nonatomic, copy) NSString *textStr;

@end

@implementation CTDisplayView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // add event
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapTheImage:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapTheImage:(UIGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self]; // 获取手势触摸响应到的位置
    
    for (CoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系，因为 imageData 中使用的是 CoreText 坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        
        // 检测点击位置 Point 是否是在 rect 之内
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"tap image");
            
            // 由于 UIView 的树形结构层次比较多，很难通过 delegate 将点击事件一层一层向下传递，可以通过 NSNotification 的方式来进行事件传递
            NSDictionary *userInfo = @{
                                       @"imageData" : imageData
                                       };
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressedNotification
                                                                object:self
                                                              userInfo:userInfo];
            return;
        }
        
        CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self
                                                        atPoint:point
                                                           data:self.data];
        if (linkData) {
            NSLog(@"tap link");
            
            NSDictionary *userInfo = @{
                                       @"linkData" : linkData
                                       };
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressedNotification
                                                                object:self
                                                              userInfo:userInfo];
            return;
        }
    }
}

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    
    [self drawWithPureText2];
    
}

- (void)drawWithPureText2 {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    for (CoreTextImageData *imgData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imgData.name];
        if (image) {
            CGContextDrawImage(context, imgData.imagePosition, image.CGImage); // 绘制图片
        }
    }
    
}

// ----------------------------------
- (void)drawPrueText {
    
    // 1：获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 2：转换坐标系
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.bounds.size.height);
    CGContextScaleCTM(contextRef, 1, -1);
    
    // 3：创建绘制的区域
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    // 4：绘制的内容
    NSAttributedString *attributedStr = [[NSAttributedString alloc]
                                         initWithString:@"琥珀色黄昏像糖在很美的远方，你的脸没有化妆我却疯狂爱上，思念跟影子在傍晚一起被拉长，我手中那张入场券陪我数羊，薄荷色草地芬芳像风没有形状我却能够牢记你的气质跟脸庞，冷空气跟琉璃在清晨很有透明感，像我的喜欢被你看穿，摊位上一朵艳阳，我悄悄出现你身旁，你慌乱的模样我微笑安静欣赏，我顶着大太阳，只想为你撑伞，你靠在我肩膀深呼吸怕遗忘，因为捞鱼的蠢游戏我们开始交谈，多希望话题不断园游会永不打烊，汽球在我手上，我牵着你瞎晃，有话想对你讲你眼睛却装忙，鸡蛋糕跟你嘴角果酱我都想要尝，园游会影片在播放这个世界约好一起逛，琥珀色黄昏像糖在很美的远方，你的脸没有化妆我却疯狂爱上，思念跟影子在傍晚一起被拉长，我手中那张入场券陪我数羊，薄荷色草地芬芳像风没有形状，我却能够牢记你的气质跟脸庞，冷空气跟琉璃在清晨很有透明感，像我的喜欢被你看穿，摊位上一朵艳阳，我悄悄出现你身旁，你慌乱的模样我微笑安静欣赏，我顶着大太阳，只想为你撑伞，你靠在我肩膀深呼吸怕遗忘，因为捞鱼的蠢游戏我们开始交谈，多希望话题不断园游会永不打烊，汽球在我手上，我牵着你瞎晃，有话想对你讲你眼睛却装忙，鸡蛋糕跟你嘴角果酱我都想要尝，园游会影片在播放这个世界约好一起逛"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedStr length]), path, NULL);
    
    // 5：绘制
    CTFrameDraw(frame, contextRef);
    
    // 6：释放内存
    CFRelease(frame);
    CFRelease(path);
    // CoreText_iPhone[260] <Error>: CGContextResetState: invalid context 0x1276089d0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//    CFRelease(contextRef);
    CFRelease(framesetter);
    
}

// ----------------------------------
- (void)test{
    self.textStr = @"这是一个测试文这是一个测试文本这是一个测试文本这是一个测试文本这是一个测试文本这是一个测试文本本";
    
    // 1.返回当前的 graphics context，用于当后续将内容绘制到 画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"转换坐标前的context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    // 2. 将坐标系进行范翻转（对于底层绘制引擎来说，屏幕左角是（0， 0） 坐标），转化为 UIKit 中的坐标
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    /*
     // 2.1 这两种转换坐标的方式都是一样的
     CGContextTranslateCTM(context, 0, self.bounds.size.height);
     CGContextScaleCTM(context, 1.0, -1.0);  // 将 y 轴做一次翻转
     */
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    
    NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    // 3.创建绘制区域，CoreText 支持各种文字排版的区域，这里可以将 path 进行个性化裁剪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    //    CGPathAddEllipseInRect(path, NULL, self.bounds); // ellipse：椭圆
    
    
    // 4.创建需要绘制的文本
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]
                                            initWithString:self.textStr];
    // 设置部分颜色文字
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:30.0]
                      range:NSMakeRange(0, 12)];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor redColor]
                      range:NSMakeRange(19, 8)];
    
    // 设置行间距
    CGFloat maxLineSpacing = 30.0;
    const CFIndex kNumberOfSettings = 4;
    const CGFloat kspecifierIndent = 20; // 每行开头缩进
    const CGFloat kFirstLineIndent = 50; // 首行缩进
    const CGFloat kTailIndent = -10.0; // 行尾缩进
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &maxLineSpacing}, // 行间距
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &kspecifierIndent},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &kFirstLineIndent},
        {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &kTailIndent},
    };
    CTParagraphStyleRef theParagrapRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:(__bridge id)theParagrapRef
                      range:NSMakeRange(0, attString.length)];
    
    
    
    
    
    // 5.根据 attribuedString 来生成 CTFramsetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    // 6.进行绘制除图片以外的部分
    CTFrameDraw(frame, context);
    
    
    
    // 7.内存管理
    CFRelease(theParagrapRef);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);

}

@end
