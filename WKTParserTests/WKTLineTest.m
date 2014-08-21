//
//  WKTLineTest.m
//
//  WKTParser Line Test Case
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
#import "WKTLineM.h"

@interface WKTLineTest : XCTestCase

@end

@implementation WKTLineTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_Line_Single
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(30 10, 10 30, 40 40)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
                initWithDimensionX:[point[0] doubleValue]
                andDimensionY:[point[1] doubleValue]];
        [listP addObject:p];
        point = nil;
    }
    
    // Create Line Geometry
    WKTLine *result = [[WKTLine alloc] initWithPoints:listP];
    XCTAssertEqualObjects(result.type, @"Line",
             @"Result type should be \"Line\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListPoints].count, 3,
             @"Result Points should be three");
}

- (void)test_Line_Equal
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(30 10, 10 30, 40 40)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
                       initWithDimensionX:[point[0] doubleValue]
                       andDimensionY:[point[1] doubleValue]];
        [listP addObject:p];
        point = nil;
    }
    
    // Create Line Geometry
    WKTLine *result = [[WKTLine alloc] initWithPoints:listP];
    
    // Create Line Geometry
    WKTLine *result2 = [[WKTLine alloc] initWithPoints:listP];
    
    // Create Line Geometry with another Point
    NSMutableArray *listP2 = [[NSMutableArray alloc] initWithArray:listP];
    [listP2 addObject:[[WKTPoint alloc] initWithDimensionX:30 andDimensionY:40]];
    WKTLine *result3 = [[WKTLine alloc] initWithPoints:listP2];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTLine is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTLine is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTLine is Equal to WKTLine with same coordinates");
    XCTAssertFalse([result isEqual:result3],
             @"WKTLine is not Equal to WKTLine with other coordinates");
}

- (void)test_Line_Copy
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(30 10, 10 30, 40 40)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [listP addObject:p];
        point = nil;
    }
    
    // Create Line Geometry
    WKTLine *result = [[WKTLine alloc] initWithPoints:listP];
    
    // Create Line Empty
    WKTLine *result2 = [[WKTLine alloc] init];
    
    // Copy WKTLine to Other WKTLine
    [result copyTo:result2];
    
    XCTAssertEqualObjects(result2.type, @"Line",
             @"Result type should be \"Line\"");
    XCTAssertEqual(result2.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result2 getListPoints].count, 3,
             @"Result Points should be three");
}

- (void)test_Line_CopyNilException
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(30 10, 10 30, 40 40)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [listP addObject:p];
        point = nil;
    }
    
    // Create Line Geometry
    WKTLine *result = [[WKTLine alloc] initWithPoints:listP];
    
    XCTAssertThrows([result copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Line_MultiSimple
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }
    
    // Create Multi Line Geometry
    WKTLineM *result = [[WKTLineM alloc] initWithLines:listLines];
    
    XCTAssertEqualObjects(result.type, @"MultiLine",
             @"Result type should be \"MultiLine\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListLines].count, 2,
             @"Result Lines should be two");
}

- (void)test_Line_MultiEqual
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }
    
    // Create Multi Line Geometry
    WKTLineM *result = [[WKTLineM alloc] initWithLines:listLines];
    
    // Create Multi Line Geometry
    WKTLineM *result2 = [[WKTLineM alloc] initWithLines:listLines];
    
    // Create Multi Line Geometry with another Line
    NSMutableArray *listLines2 = [[NSMutableArray alloc] initWithArray:listLines];
    [listLines2 addObject:[listLines2 lastObject]];
    WKTLineM *result3 = [[WKTLineM alloc] initWithLines:listLines2];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTLineM is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTLineM is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTLineM is Equal to WKTLineM with same lines");
    XCTAssertFalse([result isEqual:result3],
             @"WKTLineM is not Equal to WKTLineM with other lines");
}

- (void)test_Line_MultiCopy
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }
    
    // Create Multi Line Geometry
    WKTLineM *result = [[WKTLineM alloc] initWithLines:listLines];
    
    // Create Multi Line Geometry Empty
    WKTLineM *result2 = [[WKTLineM alloc] init];
    
    // Copy WKTLineM to Other WKTLineM
    [result copyTo:result2];
    
    XCTAssertEqualObjects(result2.type, @"MultiLine",
             @"Result type should be \"MultiLine\"");
    XCTAssertEqual(result2.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result2 getListLines].count, 2,
             @"Result Lines should be two");
}

- (void)test_Line_MultiCopyNilException
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }
    
    // Create Multi Line Geometry
    WKTLineM *result = [[WKTLineM alloc] initWithLines:listLines];
    
    XCTAssertThrows([result copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Line_MultiWKTLineException
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }
    [listLines addObject:@"WKTLine"];

    // Create Multi Line Geometry
    WKTLineM *result;
    
    XCTAssertThrows(result = [[WKTLineM alloc] initWithLines:listLines],
             @"Should throws WKTLine Exception");
}

- (void)test_Line_MultiDimensionsException
{
    // Split Single Parent and Commas to Format
    NSString *input = @"(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10),\
                        (10 10 10, 20 20 20, 10 40 30)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    NSArray *split = [WKTString splitParentCommasNSString:input];
    
    // Create Lines from Array's Values
    NSMutableArray *listLines = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *line = [[NSMutableArray alloc] init];
        NSArray *pLine = [WKTString splitCommasNSString:split[i]];
        for(int j = 0; j < pLine.count; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:pLine[i]];
            WKTPoint *p = (point.count == 2) ? [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]] :
                [[WKTPoint alloc] initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]
                 andDimensionZ:[point[2] doubleValue]];
            [line addObject:p];
            point = nil;
        }
        [listLines addObject:[[WKTLine alloc] initWithPoints:line]];
    }

    // Create Multi Line Geometry
    WKTLineM *result;
    
    XCTAssertThrows(result = [[WKTLineM alloc] initWithLines:listLines],
             @"Should throws Dimensions Exception");
}

@end
