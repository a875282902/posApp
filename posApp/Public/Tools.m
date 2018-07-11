//
//  Tools.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "Tools.h"

@implementation Tools

#pragma mark --  Label
+(UILabel *)creatLabel:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment title:(NSString *)title{

    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setText:title];
    [label setFont:font];
    [label setTextColor:color];
    [label setNumberOfLines:0];
    [label setTextAlignment:alignment];
    [label setClipsToBounds:YES];
    [label setUserInteractionEnabled:YES];
    return label;
}
+(UILabel *)creatAttributedLabel:(CGRect)rect font:(UIFont *)font color:(UIColor*)color  title:(NSString *)title image:(NSString *)imageName alignment:(NSTextAlignment)alignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setAttributedText:[[self class] stringTiAttributedWith:title image:imageName font:font color:color]];
    [label setNumberOfLines:0];
    [label setClipsToBounds:YES];
    [label setTextAlignment:alignment];
    [label setUserInteractionEnabled:YES];
    return label;
    
}

#pragma mark --- 分割线
+ (UIView *)setLineView:(CGRect)rect{
    
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    
    return line;
}

#pragma mark -- button
+ (UIButton *)creatButton:(CGRect)rect font:(UIFont *)font color:(UIColor *)color title:(NSString *)title image:(NSString *)imageName{
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setFrame:rect];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    if (imageName.length != 0) {
        [btn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    }
    [btn setClipsToBounds:YES];
    return btn;
}
#pragma mark -- UIImageView
+ (UIImageView *)creatImage:(CGRect)rect image:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    if (imageName.length != 0) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    [imageView setUserInteractionEnabled:YES];
    [imageView setClipsToBounds:YES];
    return imageView;
}

+ (UIImageView *)creatImage:(CGRect)rect url:(NSString *)imageUrl image:(NSString *)imageName{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:imageName]];
    [imageView setUserInteractionEnabled:YES];
    [imageView setClipsToBounds:YES];
    return imageView;
}


#pragma mark -- 其他
+ (NSAttributedString *)stringTiAttributedWith:(NSString *)str image:(NSString *)imageName font:(UIFont *)font color:(UIColor*)color {
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(MDXFrom6(5), - MDXFrom6(3), MDXFrom6(18), MDXFrom6(18));
    NSAttributedString *attributed = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attributed];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",str]]];
    
    
    [att setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:NSMakeRange(att.length- str.length, str.length)];
    
    return att;
}


@end
