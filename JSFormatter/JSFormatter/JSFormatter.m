//
//  JSFormatter.m
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//

#import "JSFormatter.h"
#import "XCFXcodePrivate.h"
#import "JSFormatter+helper.h"

typedef NS_ENUM(NSInteger, JSFormatterFileType) {
    JSFormatterFileTypeJS,
    JSFormatterFileTypeHTML,
    JSFormatterFileTypeCSS
};

@interface JSFormatter ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@end

@implementation JSFormatter

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
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

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)noti {
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

        NSMenuItem *formatCurrentJSFileItem = [[NSMenuItem alloc]initWithTitle:@"Format Active File" action:@selector(formatCurrentJSFileItemPressed) keyEquivalent:@""];
        formatCurrentJSFileItem.target = self;

        [jsFormatterMenu addItem:formatCurrentJSFileItem];
    }
}

- (void)formatCurrentJSFileItemPressed {
    IDESourceCodeDocument *document = [[self class] currentSourceCodeDocument];

    [[self class] formatDocument:document];
}

+ (BOOL)formatDocument:(IDESourceCodeDocument *)document {
    DVTSourceTextStorage *textStorage = [document textStorage];
    NSString *originalString = [NSString stringWithString:textStorage.string];

    if (textStorage.string.length > 0) {
        
        NSArray *types = @[@"js",@"html",@"css"];
        if ([types indexOfObject:document.fileURL.pathExtension] == NSNotFound) {
            //not support other file types
            return NO;
        }
        
        NSString *formattedCode = [self formattedCodeOfString:textStorage.string pathExtension:document.fileURL.pathExtension];

        if (formattedCode) {
            [textStorage beginEditing];

            if (![formattedCode isEqualToString:textStorage.string]) {
                [textStorage replaceCharactersInRange:NSMakeRange(0, textStorage.string.length) withString:formattedCode withUndoManager:[document undoManager]];
            }

            [textStorage endEditing];
        }
    }

    BOOL codeHasChanged = (originalString && ![originalString isEqualToString:textStorage.string]);
    return codeHasChanged;
}

+ (NSString *)formattedCodeOfString:(NSString *)string pathExtension:(NSString *)pathExtension {
    NSString *path = @"/tmp/out.tmp.$$";
    [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    //1
    NSTask *task = [[NSTask alloc] init];

    //2
    task.launchPath = @"/usr/local/bin/node";

    //init output pipe
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];

    //3
    NSString *command = [NSString stringWithFormat:@"/usr/local/bin/%@-beautify",pathExtension];
    task.arguments = @[command, path];

    //4
    [task launch];

    //5
    [task waitUntilExit];

    NSFileHandle *read = [outputPipe fileHandleForReading];
    NSData *dataRead = [read readDataToEndOfFile];
    NSString *stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
    NSLog(@"output: %@", stringRead);


    return stringRead;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
