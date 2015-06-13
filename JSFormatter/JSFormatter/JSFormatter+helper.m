//
//  JSFormatter+helper.m
//  JSFormatter
//
//  Created by zx on 6/13/15.
//  Copyright (c) 2015 zztx. All rights reserved.
//

#import "JSFormatter+helper.h"

@implementation JSFormatter (helper)

+ (IDEWorkspaceDocument *)currentWorkspaceDocument
{
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    id document = [currentWindowController document];
    
    if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument *)document;
    }
    return nil;
}

+ (NSTextView *)currentSourceCodeTextView
{
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *editor = [self currentEditor];
        return editor.textView;
    }
    
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        IDESourceCodeComparisonEditor *editor = [self currentEditor];
        return editor.keyTextView;
    }
    
    return nil;
}

+ (id)currentEditor
{
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController *workspaceController = (IDEWorkspaceWindowController *)currentWindowController;
        IDEEditorArea *editorArea = [workspaceController editorArea];
        IDEEditorContext *editorContext = [editorArea lastActiveEditorContext];
        return [editorContext editor];
    }
    return nil;
}

+ (IDESourceCodeDocument *)currentSourceCodeDocument
{
    if ([[[self class] currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *editor = [[self class] currentEditor];
        return editor.sourceCodeDocument;
    }
    
    if ([[[self class] currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        IDESourceCodeComparisonEditor *editor = [[self class] currentEditor];
        
        if ([[editor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
            IDESourceCodeDocument *document = (IDESourceCodeDocument *)editor.primaryDocument;
            return document;
        }
    }
    
    return nil;
}

+ (void)formatDocument:(IDESourceCodeDocument *)document withError:(NSError **)outError
{
    NSTextView *textView = [self currentSourceCodeTextView];
    
    DVTSourceTextStorage *textStorage = [document textStorage];
    
    // We try to restore the original cursor position after the uncrustification. We compute a percentage value
    // expressing the actual selected line compared to the total number of lines of the document. After the uncrustification,
    // we restore the position taking into account the modified number of lines of the document.
    
    NSRange originalCharacterRange = [textView selectedRange];
    NSRange originalLineRange = [textStorage lineRangeForCharacterRange:originalCharacterRange];
    NSRange originalDocumentLineRange = [textStorage lineRangeForCharacterRange:NSMakeRange(0, textStorage.string.length)];
    
    CGFloat verticalRelativePosition = (CGFloat)originalLineRange.location / (CGFloat)originalDocumentLineRange.length;
    
    IDEWorkspace *currentWorkspace = [self currentWorkspaceDocument].workspace;
    
    [self formatCodeOfDocument:document inWorkspace:currentWorkspace error:outError];
    
    NSRange newDocumentLineRange = [textStorage lineRangeForCharacterRange:NSMakeRange(0, textStorage.string.length)];
    NSUInteger restoredLine = roundf(verticalRelativePosition * (CGFloat)newDocumentLineRange.length);
    
    NSRange newCharacterRange = NSMakeRange(0, 0);
    
    newCharacterRange = [textStorage characterRangeForLineRange:NSMakeRange(restoredLine, 0)];
    
    // If the selected line didn't change, we try to restore the initial cursor position.
    
    if (originalLineRange.location == restoredLine && NSMaxRange(originalCharacterRange) < textStorage.string.length) {
        newCharacterRange = originalCharacterRange;
    }
    
    if (newCharacterRange.location < textStorage.string.length) {
        [[self currentSourceCodeTextView] setSelectedRanges:@[[NSValue valueWithRange:newCharacterRange]]];
        [textView scrollRangeToVisible:newCharacterRange];
    }
}

+ (BOOL)formatCodeOfDocument:(IDESourceCodeDocument *)document inWorkspace:(IDEWorkspace *)workspace error:(NSError **)outError
{
    return YES;
//    NSError *error = nil;
//    
//    DVTSourceTextStorage *textStorage = [document textStorage];
//    
//    NSString *originalString = [NSString stringWithString:textStorage.string];
//    
//    if (textStorage.string.length > 0) {
//        CFOFormatter *formatter = [[self class] formatterForString:textStorage.string presentedURL:document.fileURL error:&error];
//        NSString *formattedCode = [formatter stringByFormattingInputWithError:&error];
//        
//        if (formattedCode) {
//            [textStorage beginEditing];
//            
//            if (![formattedCode isEqualToString:textStorage.string]) {
//                [textStorage replaceCharactersInRange:NSMakeRange(0, textStorage.string.length) withString:formattedCode withUndoManager:[document undoManager]];
//            }
//            [self normalizeCodeAtRange:NSMakeRange(0, textStorage.string.length) document:document];
//            [textStorage endEditing];
//        }
//    }
//    
//    if (error && outError) {
//        *outError = error;
//    }
//    
//    BOOL codeHasChanged = (originalString && ![originalString isEqualToString:textStorage.string]);
//    return codeHasChanged;
}



@end
