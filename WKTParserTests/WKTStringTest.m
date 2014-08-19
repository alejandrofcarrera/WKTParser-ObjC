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

// Test for splitSpacesNSString (7)

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

// Test for splitCommasNSString (9)

- (void)test_Comma_OneComma
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating,Unit,Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Comma_OneCommaOneSpace
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating , Unit , Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Comma_MultiCommaOneSpace
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating ,, Unit , Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Comma_MultiCommaMultiSpace
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating ,,  ,    Unit   , Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Comma_Empty
{
    NSArray *result = [WKTString splitCommasNSString:
             @""];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_Comma_Single
{
    NSArray *result = [WKTString splitCommasNSString:
             @","];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_Comma_CharacterUnescaped
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating,Unit,  \t  ,Tests"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"Creating",
             @"Result [0] should be \"Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests",
             @"Result [2] should be \"Tests\"");
}

- (void)test_Comma_CharacterEscaped
{
    NSArray *result = [WKTString splitCommasNSString:
             @"Creating   ,  Unit,  \\t,  Tests"];
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

- (void)test_Comma_NilException
{
    NSArray *result;
    XCTAssertThrows(result =[WKTString splitCommasNSString:
             nil], @"Should throws Nil Exception");
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

// Test for splitParentCommasNSString (13)

- (void)test_PaComma_OneParent
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(Creating Unit Tests)"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"(Creating Unit Tests)",
             @"Result [0] should be \"(Creating Unit Tests)\"");
}

- (void)test_PaComma_OneParentOneComma
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(Creating, Unit, Tests)"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"(Creating, Unit, Tests)",
             @"Result [0] should be \"(Creating, Unit, Tests)\"");
}

- (void)test_PaComma_MultiParent
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(Creating) (Unit) (Tests)"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"(Creating) (Unit) (Tests)",
             @"Result [0] should be \"(Creating) (Unit) (Tests)\"");
}

- (void)test_PaComma_MultiParentOneComma
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(Creating),(Unit),(Tests)"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"(Creating",
             @"Result [0] should be \"(Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests)",
             @"Result [2] should be \"Tests)\"");
}

- (void)test_PaComma_MultiParentMultiComma
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(Creating), ,(Unit), ,(Tests)"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"(Creating",
             @"Result [0] should be \"(Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests)",
             @"Result [2] should be \"Tests)\"");
}

- (void)test_PaComma_Empty
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @""];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_PaComma_SingleParent
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"()"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"()",
             @"Result [0] should be \"()\"");
}

- (void)test_PaComma_SingleParentAndComma
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"(,)"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"(,)",
             @"Result [0] should be \"(,)\"");
}

- (void)test_PaComma_CharacterUnescaped
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"\t(Creating) \t, \t(Unit)\t,  (Tests)"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"\t(Creating",
             @"Result [0] should be \"Tab (Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests)",
             @"Result [2] should be \"Tests)\"");
}

- (void)test_PaComma_CharacterEscaped
{
    NSArray *result = [WKTString splitParentCommasNSString:
             @"\\t(Creating), (\\tUnit),  (Tests\\t)"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be four");
    XCTAssertEqualObjects(result[0], @"\\t(Creating",
             @"Result [0] should be \"Tab (Creating\"");
    XCTAssertEqualObjects(result[1], @"\\tUnit",
             @"Result [1] should be \"Tab Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests\\t)",
             @"Result [2] should be \"Tests Tab)\"");
}

- (void)test_PaComma_NilException
{
    NSArray *result;
    XCTAssertThrows(result =[WKTString splitParentCommasNSString:
             nil], @"Should throws Nil Exception");
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

// Test for splitDoubleParentCommasNSString

- (void)test_DoPComma_DoubleParent
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((Creating Unit Tests))"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"((Creating Unit Tests))",
             @"Result [0] should be \"((Creating Unit Tests))\"");
}

- (void)test_DoPaComma_DoubleParentOneComma
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((Creating, Unit, Tests))"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"((Creating, Unit, Tests))",
             @"Result [0] should be \"((Creating, Unit, Tests))\"");
}

- (void)test_DoPaComma_MultiParent
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((Creating)) ((Unit)) ((Tests))"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"((Creating)) ((Unit)) ((Tests))",
             @"Result [0] should be \"((Creating)) ((Unit)) ((Tests))\"");
}

- (void)test_DoPaComma_MultiParentOneComma
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((Creating)),((Unit)),((Tests))"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"((Creating",
             @"Result [0] should be \"((Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests))",
             @"Result [2] should be \"Tests))\"");
}

- (void)test_DoPaComma_MultiParentMultiComma
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((Creating)), ,((Unit)), ,((Tests))"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"((Creating",
             @"Result [0] should be \"((Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests))",
             @"Result [2] should be \"Tests))\"");
}

- (void)test_DoPaComma_Empty
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @""];
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

- (void)test_DoPaComma_DoubleParent
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"(())"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be one");
    XCTAssertEqualObjects(result[0], @"(())",
             @"Result [0] should be \"(())\"");
}

- (void)test_DoPaComma_DoubleParentAndComma
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"((,))"];
    XCTAssertEqual(result.count, 1,
             @"Result's length should be zero");
    XCTAssertEqualObjects(result[0], @"((,))",
             @"Result [0] should be \"((,))\"");
}

- (void)test_DoPaComma_CharacterUnescaped
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"\t((Creating)) \t, \t((Unit))\t,  ((Tests))"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be three");
    XCTAssertEqualObjects(result[0], @"\t((Creating",
             @"Result [0] should be \"Tab ((Creating\"");
    XCTAssertEqualObjects(result[1], @"Unit",
             @"Result [1] should be \"Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests))",
             @"Result [2] should be \"Tests))\"");
}

- (void)test_DoPaComma_CharacterEscaped
{
    NSArray *result = [WKTString splitDoubleParentCommasNSString:
             @"\\t((Creating)), ((\\tUnit)),  ((Tests\\t))"];
    XCTAssertEqual(result.count, 3,
             @"Result's length should be four");
    XCTAssertEqualObjects(result[0], @"\\t((Creating",
             @"Result [0] should be \"Tab ((Creating\"");
    XCTAssertEqualObjects(result[1], @"\\tUnit",
             @"Result [1] should be \"Tab Unit\"");
    XCTAssertEqualObjects(result[2], @"Tests\\t))",
             @"Result [2] should be \"Tests Tab))\"");
}

- (void)test_DoPaComma_NilException
{
    NSArray *result;
    XCTAssertThrows(result =[WKTString splitDoubleParentCommasNSString:
             nil], @"Should throws Nil Exception");
    XCTAssertEqual(result.count, 0,
             @"Result's length should be zero");
}

@end
