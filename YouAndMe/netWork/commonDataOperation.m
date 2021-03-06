//
//  commonDataOperation.m
//  economicInfo
//
//  Created by daiyu zhang on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonDataOperation.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "NSString+CustomCategory.h"
#import "iLoadAnimationView.h"
#import "JSON.h"
#import "sqliteDataManage.h"
#import "Common.h"



@implementation commonDataOperation
@synthesize urlStr = mpUrlStr;
@synthesize argumentDic = mpArgumentDic;
@synthesize isPOST;
@synthesize isImage;
@synthesize newimage;
@synthesize showAnimation;
@synthesize useCache;

-(id)init
{
    if ((self = [super init])) {
        mpArgumentDic = [[NSMutableDictionary alloc] init];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleVersion"];

        [mpArgumentDic setObject:currentVersion forKey:@"APPVERSION"];
        [mpArgumentDic setObject:@"IOS" forKey:@"PLATFORM"];
        CGSize size = [[UIScreen mainScreen] bounds].size;
        [mpArgumentDic setObject:[NSString stringWithFormat:@"%.2f", size.width] forKey:@"SCREENSIZE_W"];
        [mpArgumentDic setObject:[NSString stringWithFormat:@"%.2f", size.height] forKey:@"SCREENSIZE_H"];
        
        UIDevice *device = [UIDevice currentDevice];
//        deviceName = [device model];
//        OSName = [device systemName];
        NSString *OSVersion = [device systemVersion];
        [mpArgumentDic setObject:OSVersion forKey:@"OSVERSION"];
      
//        （版本号、平台版本、平台、分辨率）
        isPOST = NO;
        isImage = NO;
        showAnimation = NO;
    }
    return self;
}

-(void)cacheDataToDataBase:(NSString *)info
{
    if (!useCache) {
        return;
    }
    NSMutableString * argumetStr = [[NSMutableString alloc] init];
    for (NSString * key in [mpArgumentDic allKeys]) {
        [argumetStr appendString:key];
        NSString * arg = mpArgumentDic[key];
        [argumetStr appendString:arg];
    }

    NSString * identifer = [NSString stringWithFormat:@"%@%@", mpUrlStr, argumetStr];
    NSString * identiferMD5 = [identifer stringFromMD5];
    
    sqliteDataManage * sqliteInstance = [sqliteDataManage sharedSqliteDataManage];
//    char *errorMsg = NULL;
    char *insert = "INSERT OR REPLACE into cacheData (identifer, info) values(?,?);";
    sqlite3 * database = sqliteInstance->database;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, insert, -1, &stmt, nil)==SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [identiferMD5 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [info UTF8String], -1, NULL);
    }
    
    if (sqlite3_step(stmt)!=SQLITE_DONE) {
        NSLog(@"Error updating table");
    }
    sqlite3_finalize(stmt);
}

-(void)backToMainThread:(NSString *)dataString
{    
    
    if ([downInfoDelegate respondsToSelector:@selector(downLoadWithInfo:with:)]) {
        [self cacheDataToDataBase:dataString];
        [downInfoDelegate downLoadWithInfo:dataString with:miTag];
    }
}

-(void)requestFailBackToMainThread:(NSString *)dataString
{
    if ([downInfoDelegate respondsToSelector:@selector(requestFailed:withTag:)]) {
        [downInfoDelegate requestFailed:@"数据请求失败" withTag:miTag];
    }
}


-(void)startTask
{
    NSString * lpMethod = @"GET";
    if (isPOST) {
        lpMethod = @"POST";
    }

    if (mpUrlStr == nil) {
        mpUrlStr = serverIp;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"ifLogin"] == YES) {
        [mpArgumentDic setValue:[userDefaults objectForKey:@"TOKEN_ID"] forKey:@"TOKEN_ID"];
    }
    
    mpFormDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:mpUrlStr]];
    [mpFormDataRequest setRequestMethod:lpMethod];
    for (NSString * key in mpArgumentDic) {
        [mpFormDataRequest setPostValue:[mpArgumentDic objectForKey:key] forKey:key];
    }
    
    [mpFormDataRequest setTimeOutSeconds:15];
    [mpFormDataRequest startSynchronous];
    NSInteger liCode = [mpFormDataRequest responseStatusCode];
    
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@?", serverIp];
    NSArray * ary = [mpArgumentDic allKeys];
    for (int i = 0; i < [ary count]; i++) {
        NSString * key = ary[i];
        NSString * value = mpArgumentDic[key];
        if (i == 0) {
            [str appendFormat:@"%@=%@", key, value];
        } else {
            [str appendFormat:@"&%@=%@", key, value];
        }
    }
//    NSLog(@"%@", str);
    
    if (liCode == 200) {
        NSString * lpInfo = [mpFormDataRequest responseString];
        [self performSelectorOnMainThread:@selector(backToMainThread:) withObject:lpInfo waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(requestFailBackToMainThread:) withObject:nil waitUntilDone:NO];
    }
}

-(void)getDataFromCache
{
    if (useCache == NO) {
        return;
    }
    NSMutableString * argumetStr = [[NSMutableString alloc] init];
    for (NSString * key in [mpArgumentDic allKeys]) {
        [argumetStr appendString:key];
        NSString * arg = mpArgumentDic[key];
        [argumetStr appendString:arg];
    }
    NSString * identifer = [NSString stringWithFormat:@"%@%@", mpUrlStr, argumetStr];
    NSString * identiferMD5 = [identifer stringFromMD5];
    
    sqliteDataManage * sqliteInstance = [sqliteDataManage sharedSqliteDataManage];
    NSString * selectSql = [NSString stringWithFormat:@"select info from cacheData where identifer = '%@'", identiferMD5];
    sqlite3_stmt * statement = [sqliteInstance selectData:selectSql];
    NSString * dateStr = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        dateStr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
    }
    sqlite3_finalize(statement);
    [sqliteInstance closeSqlite];
    
    if (dateStr) {
        [self performSelectorOnMainThread:@selector(backToMainThread:) withObject:dateStr waitUntilDone:NO];
    }
}

- (void) main
{
    if (showAnimation) {
//        [iLoadAnimationView startLoadAnimation];
    }
    @autoreleasepool {
        [self startTask];

    }
   //    [iLoadAnimationView stopLoadAnimation];
}

-(void)dealloc
{
    
}




@end
