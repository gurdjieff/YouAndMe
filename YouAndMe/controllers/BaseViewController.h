//
//  BaseViewController.h
//  YouAndMe
//
//  Created by daiyuzhang on 14-10-30.
//  Copyright (c) 2014年 daiyuzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonDataOperation.h"

@interface BaseViewController : UIViewController
<downLoadDelegate>
{
    NSOperationQueue * mpOperationQueue;
}

@end
