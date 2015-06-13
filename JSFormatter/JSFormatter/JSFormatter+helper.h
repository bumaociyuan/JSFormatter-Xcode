//
//  JSFormatter+helper.h
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//

#import "JSFormatter.h"
#import "XCFXcodePrivate.h"

@interface JSFormatter (helper)

+ (IDEWorkspaceDocument *)currentWorkspaceDocument;

+ (NSTextView *)currentSourceCodeTextView;

+ (id)currentEditor;

+ (IDESourceCodeDocument *)currentSourceCodeDocument;

@end
