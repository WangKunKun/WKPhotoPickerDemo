//
//  WKSBManager.m
//  QTRunningBang
//
//  Created by MacBook on 16/5/6.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKSBManager.h"

@implementation WKSBManager

+ (WKSBManager *)shardSBManager
{
    static WKSBManager * SM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SM = [[WKSBManager alloc] init];
    });
    return SM;
}

+ (UIViewController *)getVCWithSBName:(NSString *)SBName vcID:(NSString *)vcID
{
    WKSBManager * sm =  [WKSBManager shardSBManager];
    return [sm getVCWithSBName:SBName vcID:vcID];
}

- (UIViewController *)getVCWithSBName:(NSString *)SBName vcID:(NSString *)vcID
{
    UIViewController *main = [[UIStoryboard storyboardWithName:SBName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:vcID];
    return main;
}

@end
