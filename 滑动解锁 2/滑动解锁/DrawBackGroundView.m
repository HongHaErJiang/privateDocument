//
//  DrawBackGroundView.m
//  滑动解锁
//
//  Created by BWP on 16/4/27.
//  Copyright © 2016年 BWP. All rights reserved.
//

#import "DrawBackGroundView.h"

@implementation DrawBackGroundView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"Home_refresh_bg"];
    
    [image drawInRect:self.bounds];
}


@end
