//
//  ViewController.m
//  文字绘制动画
//
//  Created by huohuo on 2017/4/29.
//  Copyright © 2017年 huohuo. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    // 创建path
    CGMutablePathRef letters = CGPathCreateMutable();

    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 50.0f, nil);

    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,kCTFontAttributeName, nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"All Good Things" attributes:attrs];
    
    // 创建line
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex index = 0; index < CFArrayGetCount(runArray); index ++) {
        // 获得run的字体
        CTRunRef run = CFArrayGetValueAtIndex(runArray, index);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        // 获得run的每一个象形文字
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex ++) {
            // 获得象形文字
            CFRange runGlyphRange = CFRangeMake(runGlyphIndex, 1);
            // 获得象形文字信息
            CGGlyph glyph = 0;
            CGPoint position;
            CTRunGetGlyphs(run, runGlyphRange, &glyph);
            CTRunGetPositions(run, runGlyphRange, &position);
            
            // 获取象形文字外线的path
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            // 记得释放
            CGPathRelease(letter);
        }
    }
    // 记得释放
    CFRelease(line);

    // 根据path创建bezier
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    // 记得释放
    CGPathRelease(letters);
    CFRelease(font);
    
    // 根据bezier创建shaperlayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.view.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor blackColor].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 3.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    [self.view.layer addSublayer:pathLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 20.0f;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:animation forKey:@"strokeEnd"];
    
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    animation1.duration = 10.0f;
//    animation1.beginTime = 21.0f;
//    animation1.repeatCount = MAXFLOAT;
//    animation1.fromValue = [NSNumber numberWithFloat:0.0f];
//    animation1.toValue = [NSNumber numberWithFloat:1.0f];
//    [pathLayer addAnimation:animation1 forKey:@"strokeStart"];


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
