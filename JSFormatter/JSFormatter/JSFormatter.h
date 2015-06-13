//
//  JSFormatter.h
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//

#import <AppKit/AppKit.h>

@class JSFormatter;

static JSFormatter *sharedPlugin;

@interface JSFormatter : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end