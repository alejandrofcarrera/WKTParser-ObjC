//
//  WKTString.h
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

#import <UIKit/UIKit.h>

/// This class represent Class String Utilities.
@interface WKTString : NSObject

/**
 Return NSString list with regular expression splitted
 
 @param input String for split spaces
 @exception WKTString Parameter is nil.
 @return NSArray with NSString
 */
+ (NSArray *)splitSpacesNSString:(NSString *)input;

/**
 Return NSString list with regular expression splitted
 
 @param input String for split commas
 @exception WKTString Parameter is nil.
 @return NSArray with NSString
 */
+ (NSArray *)splitCommasNSString:(NSString *)input;

/**
 Return NSString list with regular expression splitted
 
 @param input String for split parent plus commas
 @exception WKTString Parameter is nil.
 @return NSArray with NSString
 */
+ (NSArray *)splitParentCommasNSString:(NSString *)input;

/**
 Return NSString list with regular expression splitted
 
 @param input String for split double parent plus commas
 @exception WKTString Parameter is nil.
 @return NSArray with NSString
 */
+ (NSArray *)splitDoubleParentCommasNSString:(NSString *)input;

/**
 Return NSString with replace of XML brackets
 
 @param input String for replace characters
 @exception WKTString Parameter is nil.
 @return NSString with tags replaced
 */
+ (NSString *)escapeTagsXMLNSString:(NSString *)input;

@end

