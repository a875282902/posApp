//
//  ShareView.m
//  DGTLive
//
//  Created by 李 on 2018/2/7.
//  Copyright © 2018年 DGT. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property (nonatomic,strong)UIView *backView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setHidden:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)]];
        [self addSubview:self.backView];
        
    }
    return self;
    
}


- (UIView *)backView{
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 200)];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-30, 120)];
        [back setBackgroundColor:[UIColor whiteColor]];
        [back.layer setCornerRadius:5];
        [_backView addSubview:back];
        
    
        
        for (NSInteger i = 0 ; i < 2; i++) {
            UIButton *watchar = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [watchar setImage:[UIImage imageNamed:@[@"share_wx",@"share_friend"][i]] forState:(UIControlStateNormal)];
            [watchar setFrame:CGRectMake((KScreenWidth-30)/2*i, 0,(KScreenWidth-30)/2, 120)];
            [watchar addTarget:self action:@selector(shareTo:) forControlEvents:(UIControlEventTouchUpInside)];
            [watchar setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [watchar setTitle:@[@"微信",@"朋友圈"][i] forState:(UIControlStateNormal)];
            [watchar.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [watchar setTag:i];
            [_backView addSubview:watchar];
            
            CGFloat offset = MDXFrom6(20);
            watchar.titleEdgeInsets = UIEdgeInsetsMake(0, -watchar.imageView.frame.size.width, -watchar.imageView.frame.size.height-offset/2, 0);
            watchar.imageEdgeInsets = UIEdgeInsetsMake(-watchar.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -watchar.titleLabel.intrinsicContentSize.width);

        }
        
        UIButton *btn = [Tools creatButton:CGRectMake(15, 140, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:@"取消" image:@""];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn addTarget:self action:@selector(remove) forControlEvents:(UIControlEventTouchUpInside)];
        [_backView addSubview:btn];
        
        
        
    }
    return _backView;
}


- (void)remove{
    
    [UIView animateWithDuration:.2 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth,MDXFrom6(130))];
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self setHidden:YES];
        }
    }];
    
}

- (void)shareTo:(UIButton *)sender{
    
    [self.delegate share:sender.tag];
    
}

- (void)show{
    
    
    [UIView animateWithDuration:.2 animations:^{
        [self setHidden:NO];
        [self setBackgroundColor:MDRGBA(0, 0, 0, .3)];
        [self.backView setFrame:CGRectMake(0, KScreenHeight- 200, KScreenWidth, 200)];
    }];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


