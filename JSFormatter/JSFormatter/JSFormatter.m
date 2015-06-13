//
//  JSFormatter.m
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//

#import "JSFormatter.h"

@interface JSFormatter()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation JSFormatter

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *editMenu = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenu) {
        [[editMenu submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *jsFormatterItem = [NSMenuItem new];
        jsFormatterItem.title = @"JSFormatter";
        
        [[editMenu submenu] addItem:jsFormatterItem];
        
        NSMenu *jsFormatterMenu = [NSMenu new];
        jsFormatterItem.submenu = jsFormatterMenu;
        
        NSMenuItem *formatCurrentJSFileItem = [[NSMenuItem alloc]initWithTitle:@"Format Current JS File" action:@selector(formatCurrentJSFileItemPressed) keyEquivalent:@""];
        formatCurrentJSFileItem.target = self;
        
        [jsFormatterMenu addItem:formatCurrentJSFileItem];
        
    }
}

- (void)sayHelloWorld {
    //1
    NSTask *task = [[NSTask alloc] init];
    
    //2
    task.launchPath = @"/usr/bin/say";
    
    //3
    task.arguments  = @[@"hello world"];
    
    //4
    [task launch];
    
    //5
    [task waitUntilExit];
}

// Sample Action, for menu item:
- (void)formatCurrentJSFileItemPressed
{
    //1
    NSTask *task = [[NSTask alloc] init];
    
    //2
    task.launchPath = @"/usr/local/bin/node";
//    task.currentDirectoryPath = @"$HOME"
    
    //3
    task.arguments  = @[@"/usr/local/bin/js-beautify",@"-r",@"/Users/zx/new.js"];
    
    //4
    [task launch];
    
    //5
    [task waitUntilExit];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
