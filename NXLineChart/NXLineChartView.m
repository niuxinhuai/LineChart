//
//  NXLineChartView.m
//  NXLineChart
//
//  Created by 牛新怀 on 2017/10/14.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NXLineChartView.h"

@interface NXLineChartView()
@property (nonatomic, strong) UIView * gredientView;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, strong) NSMutableArray * topPointArray;
@end

static const CGFloat marginScale  = 15.0f;
static const CGFloat fontSize = 12;
static const CGFloat leftXMarginScale = 10.0f;
static const CGFloat rightXMarginScale = 10.0f;
static const CGFloat lineChartXlabelHeight = 16.0f;
static const CGFloat bottomMarginScale = 16.0f;
static const int GAP = 120;
@implementation NXLineChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 画虚线， 需要改进
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat yAxisOffset =  10.f;
    CGPoint point;
    CGFloat yStepHeight = rect.size.height / self.LineChartDataArray.count;

    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    
    for (NSUInteger i = 0; i < _LineChartDataArray.count; i++) {
        point = CGPointMake(10 + yAxisOffset, (rect.size.height - i * yStepHeight + 10 / 2));
        CGContextMoveToPoint(ctx, point.x, point.y);
        // add dotted style grid
        CGFloat dash[] = {6, 5};
        // dot diameter is 20 points
        CGContextSetLineWidth(ctx, 0.5);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineDash(ctx, 0.0, dash, 2);
        // 这里是改变虚线的宽度
        CGRect frame = CGRectMake(rect.origin.x, rect.origin.y, self.totalWidth, rect.size.height);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(frame) - 5 + 5, point.y);
        CGContextStrokePath(ctx);
    }

}
// 底部X视图
- (void)setLineChartXLabelArray:(NSArray *)lineChartXLabelArray{
    _lineChartXLabelArray = lineChartXLabelArray;
    if (!_lineChartXLabelArray) return;
    
    _pointXArray = [[NSMutableArray alloc]init];
   // CGFloat labelWidthScale = (self.frame.size.width-leftXMarginScale-rightXMarginScale)/_lineChartXLabelArray.count;
    self.totalWidth =0;
    for (int idx = 0; idx < _lineChartXLabelArray.count; idx ++) {
        CGFloat labelWidthScale = [self getLabelWidthWithText:_lineChartXLabelArray[idx]];
        CGFloat x = self.totalWidth+marginScale;
        CGFloat y = self.frame.size.height- lineChartXlabelHeight;
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(x, y, labelWidthScale, lineChartXlabelHeight);
        label.text = _lineChartXLabelArray[idx];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:fontSize];
        [_pointXArray addObject:[NSString stringWithFormat:@"%.f",label.center.x]];
        [self.mainScroll addSubview:label];
        self.totalWidth = label.frame.origin.x+label.frame.size.width;
        [self.mainScroll setContentSize:CGSizeMake(CGRectGetMaxX(label.frame), 0)];
    }
    
}
// 根据文字动态获取字体宽度
- (CGFloat)getLabelWidthWithText:(NSString *)text{
    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}].width;
    return width;
}
//可滚动视图
- (UIScrollView *)mainScroll{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainScroll];
    }
    return _mainScroll;
}
// 设置折线图
- (void)setLineChartDataArray:(NSArray *)LineChartDataArray{
    _LineChartDataArray = LineChartDataArray;
    if (!_LineChartDataArray) return;
   // [self drawGragient];

    UIBezierPath * bezierPath = [self getPath];
    
    CAShapeLayer * layers = [CAShapeLayer layer];
    
    layers.path = bezierPath.CGPath;
    layers.lineWidth = 2.0;
    layers.strokeColor = [UIColor redColor].CGColor;
    layers.fillColor = [UIColor clearColor].CGColor;
    [self doAnimationWithLayer:layers];
    [self.mainScroll.layer addSublayer:layers];
   // self.gredientView.layer.mask = layers;
    [self addTopPointButton]; // 小圆点
    [self drawGredientLayer]; // 渐变
   
}

- (UIBezierPath *)getPath{
    self.topPointArray = [[NSMutableArray alloc]init];
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    for (int idx =0; idx<_LineChartDataArray.count; idx++) {
        if (idx == 0) {
            CGPoint startPoint = CGPointMake([_pointXArray[0] floatValue], self.frame.size.height-[_LineChartDataArray[0] floatValue]-bottomMarginScale);
            [bezierPath moveToPoint:startPoint];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:startPoint]];
            
        }else{
            CGPoint point = CGPointMake([_pointXArray[idx] floatValue], self.frame.size.height-[_LineChartDataArray[idx] floatValue]-bottomMarginScale);
            [bezierPath addLineToPoint:point];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:point]];
        }
    }
    return bezierPath;
    
}
// 添加小圆点
- (void)addTopPointButton{
    if (self.topPointArray.count ==0) return;
    for (int idx =0; idx<self.topPointArray.count; idx++) {
        CGPoint point = [self.topPointArray[idx] CGPointValue];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.center = point;
        button.bounds = CGRectMake(0, 0, 10, 10);
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor cyanColor];
        button.tag = GAP+idx;
        [button setTitle:[self.LineChartDataArray[idx] stringValue] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:5];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button addTarget:self action:@selector(didSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScroll addSubview:button];
    }

    
    
}
- (void)didSelectButtonClick:(UIButton *)sender{
    for (id emptyObj in self.mainScroll.subviews) {
        if ([emptyObj isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)emptyObj;
          //  btn.bounds = CGRectMake(0, 0, 5, 5);
          //  [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn.layer removeAllAnimations];
        }
    }
    [self doScaleAnimationWithView:sender];
    NSLog(@"%@",[self.LineChartDataArray[sender.tag-GAP] stringValue]);
    [sender setTitle:[self.LineChartDataArray[sender.tag-GAP] stringValue] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:5];
    
}

- (void)doScaleAnimationWithView:(UIView *)view{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.values = @[@2,@1.5,@0.8,@1,@2];
    animation.repeatCount = 2;
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:@"scaleAnimations"];
}

/*

 @parameter 背景颜色填充
 */

- (void)drawGredientLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.totalWidth, self.frame.size.height-bottomMarginScale);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:250/255.0 green:170/255.0 blue:10/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.4].CGColor];
    
    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(1,0);
   
    
    UIBezierPath *gradientPath = [UIBezierPath bezierPath];
    [gradientPath moveToPoint:CGPointMake([_pointXArray[0] floatValue], self.frame.size.height-bottomMarginScale)];
    for (int i=0; i<_LineChartDataArray.count; i++) {
        [gradientPath addLineToPoint:CGPointMake([_pointXArray[i] floatValue], self.frame.size.height-[_LineChartDataArray[i] floatValue]-bottomMarginScale)];
    }
    [gradientPath addLineToPoint:CGPointMake([_pointXArray[_pointXArray.count-1] floatValue], self.frame.size.height-bottomMarginScale)];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.mainScroll.layer addSublayer:gradientLayer];

}

// 没用
- (void)drawGragient{
    
    self.gredientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.totalWidth, self.frame.size.height-bottomMarginScale)];
    
    [self.mainScroll addSubview:self.gredientView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.gredientView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:250/255.0 green:170/255.0 blue:10/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    
   // gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(1.0,0);
    
    UIBezierPath *gradientPath = [self getPath];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.gredientView.layer addSublayer:gradientLayer];
    
}

- (void)doAnimationWithLayer:(CAShapeLayer *)layer{
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = 2;
    baseAnimation.fromValue = @0.0;
    baseAnimation.toValue = @1.0;
    baseAnimation.repeatCount = 1;
    [layer addAnimation:baseAnimation forKey:@"strokeAnimation"];
    
    
}
@end
