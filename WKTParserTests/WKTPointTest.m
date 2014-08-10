//
//  WKTPointTest.m
//
//  WKTParser Point Test Case
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
#import "WKTPointM.h"

@interface WKTPointTest : XCTestCase

@end

@implementation WKTPointTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_Point_Single
{
    // Split Single Parent and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:@"(30 10)"];
    split = [WKTString splitSpacesNSString:split[0]];
    
    // Create Point from Array's Values
    WKTPoint *result = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue]];
    
    XCTAssertEqualObjects(result.type, @"Point",
             @"Result type should be \"Point\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be 2");
    XCTAssertEqual(result.dimensionX, 30,
             @"Result dimension X should be 30");
    XCTAssertEqual(result.dimensionY, 10,
             @"Result dimension Y should be 10");
    XCTAssertEqual(result.dimensionZ, 0,
             @"Result dimension Z should be 0");
}

- (void)test_Point_Equal
{
    // Split Single Parent and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:@"(30 10)"];
    split = [WKTString splitSpacesNSString:split[0]];
    
    // Create Point from Array's Values
    WKTPoint *result = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue]];
    
    // Create Point from Array's Values
    WKTPoint *result2 = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue]];
    
    // Create Point from Double Values
    WKTPoint *result3 = [[WKTPoint alloc] initWithDimensionX:30
             andDimensionY:40];
    
    // Create Point from Array's Values and Dimension Z
    WKTPoint *result4 = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue] andDimensionZ:50];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTPoint is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTPoint is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTPoint is Equal to WKTPoint with same coordinates");
    XCTAssertFalse([result isEqual:result3],
             @"WKTPoint is not Equal to WKTPoint with other coordinates");
    XCTAssertFalse([result isEqual:result4],
             @"WKTPoint is not Equal to WKTPoint with other dimensions");
}

- (void)test_Point_Copy
{
    // Split Single Parent and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:@"(30 10)"];
    split = [WKTString splitSpacesNSString:split[0]];
    
    // Create Point from Array's Values
    WKTPoint *result = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue]];
    
    // Create Point Empty
    WKTPoint *result2 = [[WKTPoint alloc] init];
    
    // Copy WKTPoint to Other WKTPoint
    [result copyTo:result2];
    
    XCTAssertEqualObjects(result2.type, @"Point",
             @"Result type should be \"Point\"");
    XCTAssertEqual(result2.dimensions, 2,
             @"Result dimensions should be 2");
    XCTAssertEqual(result2.dimensionX, 30,
             @"Result dimension X should be 30");
    XCTAssertEqual(result2.dimensionY, 10,
             @"Result dimension Y should be 10");
    XCTAssertEqual(result2.dimensionZ, 0,
             @"Result dimension Z should be 0");
}

- (void)test_Point_CopyNilException
{
    // Split Single Parent and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:@"(30 10)"];
    split = [WKTString splitSpacesNSString:split[0]];
    
    // Create Point from Array's Values
    WKTPoint *result = [[WKTPoint alloc] initWithDimensionX:[split[0] doubleValue]
             andDimensionY:[split[1] doubleValue]];
    
    XCTAssertThrows([result copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Point_MultiSimple
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        XCTAssertEqualObjects(p.type, @"Point",
             @"Result type should be \"Point\"");
        [listP addObject:p];
    }
    
    // Create Multi Point Geometry
    WKTPointM *points = [[WKTPointM alloc] initWithPoints:listP];
    XCTAssertEqualObjects(points.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(points.dimensions, 2,
             @"Result dimensions should be 2");
    XCTAssertEqual([points getListPoints].count, 4,
             @"Result points should be 4");
}

- (void)test_Point_MultiEqual
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        [listP addObject:p];
    }
    
    // Create Multi Point Geometry
    WKTPointM *result = [[WKTPointM alloc] initWithPoints:listP];
    
    // Create Multi Point Geometry
    WKTPointM *result2 = [[WKTPointM alloc] initWithPoints:listP];
    
    // Create Line Geometry with another Point
    NSMutableArray *listP2 = [[NSMutableArray alloc] initWithArray:listP];
    [listP2 addObject:[[WKTPoint alloc] initWithDimensionX:30 andDimensionY:40]];
    WKTPointM *result3 = [[WKTPointM alloc] initWithPoints:listP2];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTPointM is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTPointM is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTPointM is Equal to WKTPointM with same coordinates");
    XCTAssertFalse([result isEqual:result3],
             @"WKTPointM is not Equal to WKTPointM with other coordinates");
}

- (void)test_Point_MultiDouble
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40), (40 30), (20 20), (30 10)"];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
                       initWithDimensionX:[split[i][0] doubleValue]
                       andDimensionY:[split[i][1] doubleValue]];
        XCTAssertEqualObjects(p.type, @"Point",
             @"Result type should be \"Point\"");
        [listP addObject:p];
    }
    
    // Create Multi Point Geometry
    WKTPointM *points = [[WKTPointM alloc] initWithPoints:listP];
    XCTAssertEqualObjects(points.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(points.dimensions, 2,
             @"Result dimensions should be 2");
    XCTAssertEqual([points getListPoints].count, 4,
             @"Result points should be 4");
}

- (void)test_Point_MultiCopy
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        [listP addObject:p];
    }
    
    // Create Multi Point Geometry
    WKTPointM *points = [[WKTPointM alloc] initWithPoints:listP];
    
    // Create Multi Point Geometry Empty
    WKTPointM *points2 = [[WKTPointM alloc] init];

    // Copy WKTPointM to Other WKTPointM
    [points copyTo:points2];
    
    XCTAssertEqualObjects(points2.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(points2.dimensions, 2,
             @"Result dimensions should be 2");
    XCTAssertEqual([points2 getListPoints].count, 4,
             @"Result points should be 4");
}

- (void)test_Point_MultiCopyNilException
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        [listP addObject:p];
    }
    
    // Create Multi Point Geometry
    WKTPointM *points = [[WKTPointM alloc] initWithPoints:listP];
    
    XCTAssertThrows([points copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Point_MultiWKTPointException
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        [listP addObject:p];
    }
    [listP addObject:@"WKTPoint"];
    
    // Create Multi Point Geometry
    WKTPointM *points;
    
    XCTAssertThrows(points = [[WKTPointM alloc] initWithPoints:listP],
             @"Should throws WKTPoint Exception");
}

- (void)test_Point_MultiDimensionsException
{
    // Split Single Parent, Commas and Spaces to Format
    NSArray *split = [WKTString splitParentCommasNSString:
             @"(10 40, 40 30, 20 20, 30 10)"];
    split = [WKTString splitCommasNSString:split[0]];
    NSMutableArray *splitSpace = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        [splitSpace addObject:[WKTString splitSpacesNSString:split[i]]];
    }
    split = nil;
    
    // Create Point and Points from Array's Values
    NSMutableArray *listP = [[NSMutableArray alloc] init];
    for(int i = 0; i < splitSpace.count; i++)
    {
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[split[i][0] doubleValue]
             andDimensionY:[split[i][1] doubleValue]];
        [listP addObject:p];
    }
    [listP addObject:[[WKTPoint alloc] initWithDimensionX:
        [split[0][0] doubleValue] andDimensionY:[split[0][1] doubleValue]
        andDimensionZ:30]];
    
    // Create Multi Point Geometry
    WKTPointM *points;
    
    XCTAssertThrows(points = [[WKTPointM alloc] initWithPoints:listP],
             @"Should throws Dimensions Exception");
}

@end
