//
//  commonDataOperation.h
//  economicInfo
//
//  Created by daiyu zhang on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "baseDataOperation.h"
#import "NSString+CustomCategory.h"


@interface commonDataOperation : baseDataOperation
{
    NSString * mpUrlStr;
    BOOL isPOST;
    BOOL showAnimation;
    BOOL useCache;
    NSMutableDictionary * mpArgumentDic;
}

@property (nonatomic, strong) NSString * urlStr;
@property (nonatomic, strong) NSMutableDictionary * argumentDic;
@property NSInteger tag;
@property BOOL isPOST;
@property BOOL isImage;
@property BOOL useCache;
@property BOOL showAnimation;
@property(nonatomic,strong)UIImage * newimage;

@end

