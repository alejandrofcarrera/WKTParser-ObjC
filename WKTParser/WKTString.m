//
//  WKTString.m
//
//  WKTParser Utils String Library
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Alejandro Fdez Carrera
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#include "WKTString.h"

@implementation WKTString

+ (NSArray *)splitString:(NSString *)input andRegExp:(NSString *)regExp
{
    NSString *inputConverted = [input stringByReplacingOccurrencesOfString:regExp
              withString:@"[SPLIT]" options:NSRegularExpressionSearch
              range:NSMakeRange(0, input.length)];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *inputSplit = [inputConverted componentsSeparatedByString:@"[SPLIT]"];
    for (NSString *i in inputSplit)
    {
        if (i.length > 0)
        {
            [result addObject:i];
        }
    }
    inputSplit = nil;
    inputConverted = nil;
    return result;
}

+ (NSArray *)splitSpacesNSString:(NSString *)input
{
    return [self splitString:input andRegExp:@"\\s+"];
}

+ (NSArray *)splitCommasNSString:(NSString *)input
{
    return [self splitString:input andRegExp:@"\\s*,\\s*"];
}

+ (NSArray *)splitParentCommasNSString:(NSString *)input
{
    if ([input characterAtIndex:0] != '(')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because first character is not ("
            userInfo:nil];
    }
    else if ([input characterAtIndex:input.length-1] != ')')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because last character is not )"
            userInfo:nil];
    }
    else return [self splitString:input andRegExp:@"\\)\\s*,\\s*\\("];
}

+ (NSArray *)splitDoubleParentCommasNSString:(NSString *)input
{
    if ([input characterAtIndex:0] != '(')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because first character is not ("
            userInfo:nil];
    }
    else if ([input characterAtIndex:1] != '(')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because second character is not ("
            userInfo:nil];
    }
    else if ([input characterAtIndex:input.length-2] != ')')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because penultimate character is not )"
            userInfo:nil];
    }
    else if ([input characterAtIndex:input.length-1] != ')')
    {
        @throw [NSException exceptionWithName:@"WKTParser Utils String Library"
            reason:@"Can't perform split String because last character is not )"
            userInfo:nil];
    }
    else return [self splitString:input andRegExp:@"\\)\\)\\s*,\\s*\\(\\("];
}

+ (NSString *)escapeTagsXMLNSString:(NSString *)input {
    NSString *inputConverted = [input stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    inputConverted = [inputConverted stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return inputConverted;
}

@end
