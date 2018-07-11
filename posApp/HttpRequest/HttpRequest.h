//
//  HttpRequest.h
//
//  Created by Micheal on 15/7/13.
//  Copyright (c) 2015年 Micheal. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger , mimeFileType) {
    
    MCZipFileType = 0,
    MCJPEGImageFileType,
    MCPNGImageFileType,
    MCJSONFileType,
    MCTXTFileType,
};

@interface HttpRequest : NSObject

/**
 *  @author Micheal
 *
 *  @brief  网络状态监测
 *
 *  @param netStatus 网络状态回调
 */
+ (void) checkReachabilityStatus:(void(^)(NSString *status))netStatus;

/**
 *  @author Micheal
 *
 *  @brief  Get方式请求
 *
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id  responseObject))success
    failure:(void (^)(NSError *  error))failure;

/**
 *  @author Micheal
 *
 *  @brief  POST方式请求
 *
 *  @param URLString  请求地址
 *  @param Progress  进度
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POST:(NSString *_Nullable)URLString
  parameters:(id _Nullable )parameters
     success:(void (^_Nullable)(id _Nullable responseObject))success
     failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/**
 *  @author Micheal
 *
 *  @brief  下载文件
 *
 *  @param URLString  请求地址
 *  @param paramDic   附加post参数
 *  @param savedPath  保存在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
+ (void) downloadFileWithInferface:(NSString*_Nullable)URLString
                         savedPath:(NSString*_Nullable)savedPath
                 completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError *error))completionHandler
                          progress:(void (^_Nullable)(float progress))progress;

/**
 *  @author Micheal
 *
 *  @brief  上传文件
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param fileData   上传文件
 *  @param serverName 服务器给的字段名
 *  @param saveName   服务器上存储的名字
 *  @param mimeType   上传文件的类型（枚举常用）
 *  @param progress   上传进度回调
 *  @param success    上传成功回调
 *  @param failure    上传失败回调
 */
+ (void) uploadFileWithInferface:(NSString *_Nullable)URLString
                      parameters:(id _Nullable )parameters
                        fileData:(NSData *_Nullable)fileData
                      serverName:(NSString *_Nullable)serverName
                        saveName:(NSString *_Nullable)saveName
                        mimeType:(mimeFileType )mimeType
                        progress:(void (^_Nullable)(float progress))progress
                         success:(void(^_Nullable)(id _Nullable responseObject))success
                         failure:(void (^_Nullable)(NSError * _Nullable error))failure;


@end
