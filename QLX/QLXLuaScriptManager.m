//
//  QLXLuaScriptManager.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

//#import "QLXLuaScriptManager.h"
//#import "wax.h"
//#import "SSZipArchive.h"
//#import "QLXExt.h"
//#import "QLXHttpRequestManager.h"
//#import "QLXApplication.h"
//
//@interface QLXLuaScriptManager()<UIAlertViewDelegate>
//
//@property (nonatomic, copy) NSString * password;
//
//
//@end
//@implementation QLXLuaScriptManager
//
//
//
//+(void)load{
//    [[QLXLuaScriptManager getInstance] runLuaFilesFromCachedIfNeed];
//}
//
//singleInstanceImple
//
//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        [self initConfigs];
//    }
//    return self;
//}
//
//-(void) initConfigs{
//    
//    self.password = @"123456";
//    [self clearCacheIfNeed];
//    wax_start(nil, nil);
//}
//
//-(void) clearCacheIfNeed{
//    
//    if ([QLXApplication getInstance].newVersion) {
//        NSString * path = [NSFileManager getDocumentPathWithFileName:@"luaScript.zip"];
//        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//    }
//}
//
//-(int) runLuaFileWithFilePath:(NSString *)filePath{
//    return wax_runLuaFile([filePath toCString]);
//}
//
//-(int) rundLuaString:(NSString *)string{
//    return wax_runLuaString([string toCString]);
//}
//
//-(void) runLuaFilesWithZipPath:(NSString *)path  withPassword:(NSString *)password{
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSString * toPath = [[NSFileManager defaultManager] getDocumentPathWithFileName:@"script"];
//        [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:true attributes:nil error:nil];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
//            
//            if ([SSZipArchive unzipFileAtPath:path toDestination:toPath overwrite:true password:@"-" error:nil]){
//                return;
//            }
//            NSError * error;
//            BOOL result =
//            [SSZipArchive unzipFileAtPath:path toDestination:toPath overwrite:true password:password error:&error];
//            if (result) {
//                NSMutableArray * filePathArray = [NSFileManager getFilePathsWithSuffix:@".lua" atDirectionPath:toPath];
//                for (NSString * luaFilePath in filePathArray) {
//                    [self runLuaFileWithFilePath:luaFilePath];
//                }
//            }else {
//                NSLog(@"%@",error.domain);
//            }
//        }
//    }
//    
//}
//
//-(BOOL) runLuaFilesWithZipPath:(NSString *)path{
//    NSString * toPath = [[NSFileManager defaultManager] getDocumentPathWithFileName:@"script"];
//    [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:true attributes:nil error:nil];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
//        return [SSZipArchive unzipFileAtPath:path toDestination:toPath];
//    }
//    return false;
//}
//
//-(void) downLoadLuaScriptsZipFileWithUrl:(NSString *)url{
//    [self downLoadLuaScriptsZipFileWithUrl:url resultCallback:nil];
//}
//
//-(void) downLoadLuaScriptsZipFileWithUrl:(NSString *)url resultCallback:(void (^)(bool success , NSString * filePath))resultClorce{
//    NSString * path = [NSFileManager getDocumentPathWithFileName:@"luaScript.zip"];
//    [[QLXHttpRequestManager getInstance] downloadFileWithOption:nil withInferface:url savedPath:path downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (responseObject) {
//            resultClorce(true , path);
//        }else {
//            resultClorce(false , nil);
//        }
//    } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        resultClorce(false , nil);
//    } progress:nil];
//}
//
//-(void) runLuaFilesFromCachedIfNeed{
//    NSString * path = [NSFileManager getDocumentPathWithFileName:@"luaScript.zip"];
//    [self runLuaFilesWithZipPath:path withPassword:self.password];
//}
//


//@end
