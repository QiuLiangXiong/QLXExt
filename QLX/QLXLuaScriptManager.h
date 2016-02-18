//
//  QLXLuaScriptManager.h
//  lua脚本管理器  每次启动时候会自动从沙盒里面读取文件(如果沙盒有下载脚本包的话) 然后编译
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "QLXExt.h"
//
//@interface QLXLuaScriptManager : NSObject
//
//singleInstanceDefine
//
///**
// *  根据文件所在路径名字 来 执行lua脚本文件
// *
// *  @param filePath 全路径名
// *
// *  @return 结果值
// */
//-(int) runLuaFileWithFilePath:(NSString *)filePath;
//
///**
// *  根据lua字符串内容 来 执行lua 例如:@"print("hello lua")"
// *
// *  @return 结果值
// */
//
//-(int) rundLuaString:(NSString *)string;
//
//
///**
// *  执行压缩包里面的对应的所有lua文件
// *
// *  @param path     压缩包路径
// *  @param password 密码
//*/
//-(void) runLuaFilesWithZipPath:(NSString *)path  withPassword:(NSString *)password;
//
///**
// *  执行压缩包里面的对应的所有lua文件
// *
// *  @param path     压缩包路径
// */
//
//-(BOOL) runLuaFilesWithZipPath:(NSString *)path;
//
//
///**
// *  下载lua文件压缩包
// *
// *  @param url 
// */
//-(void) downLoadLuaScriptsZipFileWithUrl:(NSString *)url;
//
///**
// *   根据下载链接 去 下载lua的zip文件
// *
// *  @param url   下载链接
// *  @param resultClorce 结果闭包
// */
//
//-(void) downLoadLuaScriptsZipFileWithUrl:(NSString *)url resultCallback:(void (^)(bool success , NSString * filePath))resultClorce;
//
///**
// *  从沙盒缓存里里面试图去执行lua文件  如果默认路径有下载包  就会执行里面的文件
// */
//-(void) runLuaFilesFromCachedIfNeed;
//
///**
// *  清除默认路径下的缓存（如果发现有新版本更新的话 沙盒缓存就被清除）
// */
//-(void) clearCacheIfNeed;
//
//
//@end
