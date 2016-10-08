//
//  LockView.m
//  滑动解锁
//
//  Created by BWP on 16/4/27.
//  Copyright © 2016年 BWP. All rights reserved.
//

#import "LockView.h"

#define kbuttonCount 9 // 按钮个数
#define kwidth 74 // 按钮宽度
#define kheight 74 // 按钮高度
#define kcolCount 3 // 列数

@interface LockView ()

/** 存储选中按钮 */
@property (nonatomic, strong) NSMutableArray *selectedButtons;

// 当前移动的点
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation LockView

- (NSMutableArray *)selectedButtons
{
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

#pragma mark - 初始化view
// 初始化lockView
- (void)awakeFromNib{
    
    // 添加按钮
    for (int i = 0; i < kbuttonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        // 绑定tag 后面方便获取用户滑动后的密码
        button.tag = i;
        
        [self addSubview:button];
    }
}

#pragma mark - 布局子控件
// 布局九宫格
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < kbuttonCount; i++) {
        // 取出UIbutton
        UIButton *button = self.subviews[i];
        
        // 设置位置
        CGFloat col = i % kcolCount;
        CGFloat row = i / kcolCount;
        
        // 设置间距
        CGFloat margin = (self.frame.size.width - kcolCount * kwidth) / (kcolCount + 1);
        
        CGFloat x = col * (margin + kwidth) + margin;
        CGFloat y = row * (margin + kheight);
        
        // 设置button frame
        button.frame = CGRectMake(x, y, kwidth, kheight);
    }
}
#pragma mark - 按钮的选中状态
// 点击可 选中按钮
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self buttonSelectedWithTouch:touches withEvent:event];
}

// 移动可 选中按钮
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self buttonSelectedWithTouch:touches withEvent:event];
    
    // 重绘
    [self setNeedsDisplay];
}

// 手指在手势解锁view抬起的时候调用
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 记录密码
    NSMutableString *strM = [NSMutableString string];
    // 让所有选中按钮恢复成正常状态
    for (UIButton *selBtn in self.selectedButtons) {
        selBtn.selected = NO;
        
        // 拼接密码字符串
        [strM appendFormat:@"%ld",selBtn.tag];
    }
    
    NSLog(@"%@",strM);
    
    // 清空选中按钮数组
    [self.selectedButtons removeAllObjects];
    
    [self setNeedsDisplay];
}


// 选中按钮
- (void)buttonSelectedWithTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    
    // 记录当前选中的点
    self.currentPoint = currentPoint;
    
    for (UIButton *button in self.subviews) {
        
        CGPoint btnPoint = [self convertPoint:currentPoint toView:button];
        if ([button pointInside:btnPoint withEvent:event] && button.selected == NO) {
            button.selected = YES;
            // 记录选中的按钮
            [self.selectedButtons addObject:button];
        }
    }
}

#pragma mark - 划线
- (void)drawRect:(CGRect)rect{
    
    if (self.selectedButtons.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    int i = 0;
    for (UIButton *button in self.selectedButtons) {
        if (i == 0) { // 第0个按钮的center为起点
            [path moveToPoint:button.center];
        }else {
            [path addLineToPoint:button.center];
        }
        i++;
    }
    [path addLineToPoint:self.currentPoint];
    
//    [[UIColor colorWithRed:57 green:146 blue:255 alpha:0.9] set];
    [[UIColor whiteColor] set];
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [path stroke];
}



@end
