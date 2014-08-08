//
//  WKTStringTest.m
//
//  WKTParser String Test Case
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

#import <XCTest/XCTest.h>

#import "WKTString.h"

@interface WKTStringTest : XCTestCase

@end

@implementation WKTStringTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

// Test for splitSpacesNSString

- (void)test_Space_OneSpace
{
    NSArray *result = [WKTString splitSpacesNSString:
             @"Creating Unit Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Space_MultiSpace
{
    NSArray *result = [WKTString splitSpacesNSString:
             @"Creating    Unit    Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Space_Empty
{
    NSArray *result = [WKTString splitSpacesNSString:
             @""];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_Space_Single
{
    NSArray *result = [WKTString splitSpacesNSString:
             @" "];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_Space_CharacterUnescaped
{
    NSArray *result = [WKTString splitSpacesNSString:
             @"Creating Unit  \t  Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Space_CharacterEscaped
{
    NSArray *result = [WKTString splitSpacesNSString:
             @"Creating Unit  \\t  Tests"];
    XCTAssertEqual(result.count, 4,
             @"Result's length should be four");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"\\t",
             @"Result [2] should be \"Tab\"");
    XCTAssertEqualObjects(result[3], @"Tests",
             @"Result [3] should be \"Tests\"");
}

- (void)test_Space_NilException
{
    NSArray *result;
    XCTAssertThrows(result =[WKTString splitSpacesNSString:
             nil], @"Should throws Nil Exception");
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

@end
