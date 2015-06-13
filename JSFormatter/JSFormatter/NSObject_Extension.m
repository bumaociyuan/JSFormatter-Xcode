//
//  NSObject_Extension.m
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//


#import "NSObject_Extension.h"
#import "JSFormatter.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[JSFormatter alloc] initWithBundle:plugin];
        });
    }
}
@end
