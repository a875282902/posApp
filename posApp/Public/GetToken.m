//
//  GetToken.m
//  baoli
//
//  Created by 李 on 2017/5/8.
//  Copyright © 2017年 李帅营. All rights reserved.
//

#import "GetToken.h"
#import <CommonCrypto/CommonDigest.h>

#define appid @"bolibao2c0964d938eb33ae7fc35582750c73f4"
#define appsecret @"bb400b2f9d21a382f6d0064ba8b9a6e9"
@implementation GetToken

+ (void)getToken{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    NSString *sign = [GetToken md5HexDigest:[NSString stringWithFormat:@"%@%@%@",appid,appsecret,timeString]];
    
    NSDictionary *dic = @{@"service":@"Base.Auth",@"appid":appid,@"timestamp":timeString,@"sign":sign};

    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"ret"] integerValue]==200) {
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"token"] forKey:@"token"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
        [[NSUserDefaults standardUserDefaults] setValue:@"123" forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setValue:@"123" forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    
}
//md5加密
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
