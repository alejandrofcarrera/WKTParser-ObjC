//
//  WKTPolygonTest.m
//
//  WKTParser Polygon Test Case
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
#import "WKTPolygonM.h"

@interface WKTPolygonTest : XCTestCase

@end

@implementation WKTPolygonTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_Polygon_Single
{
    // Split Single Parent and Spaces to Format
    NSString *input = @"((30 10, 40 40, 20 40, 10 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [points addObject:p];
        point = nil;
    }
    NSArray *listMPoints = @[[[WKTPointM alloc] initWithPoints:points]];
    
    // Create Polygon Geometry
    WKTPolygon *result = [[WKTPolygon alloc] initWithMultiPoints:listMPoints];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:
             [[WKTPointM alloc] initWithPoints:points]],
             @"Result Exterior Polygon should be input");
    XCTAssertEqual([result getInteriorPolygons].count, 0,
             @"Result Interior Polygons should be zero");
    XCTAssertEqual([result getPolygon].count, 1,
             @"Result Polygons should be one");
}

- (void)test_Polygon_Equal
{
    // Split Single Parent and Spaces to Format
    NSString *input = @"((30 10, 40 40, 20 40, 10 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [points addObject:p];
        point = nil;
    }
    NSArray *listMPoints = @[[[WKTPointM alloc] initWithPoints:points]];
    
    // Create Polygon Geometry
    WKTPolygon *result = [[WKTPolygon alloc] initWithMultiPoints:listMPoints];
    
    // Create Polygon Geometry
    WKTPolygon *result2 = [[WKTPolygon alloc] initWithMultiPoints:listMPoints];
    
    // Create Polygon Geometry with another Point
    NSMutableArray *points2 = [[NSMutableArray alloc] initWithArray:points];
    [points2 addObject:[[WKTPoint alloc] initWithDimensionX:30 andDimensionY:40]];
    NSArray *listMPoints2 = @[[[WKTPointM alloc] initWithPoints:points2]];
    WKTPolygon *result3 = [[WKTPolygon alloc] initWithMultiPoints:listMPoints2];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTPolygon is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTPolygon is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTPolygon is Equal to WKTPolygon with same coordinates");
    XCTAssertFalse([result isEqual:result3],
             @"WKTPolygon is not Equal to WKTPolygon with other coordinates");
}

- (void)test_Polygon_Copy
{
    // Split Single Parent and Spaces to Format
    NSString *input = @"((30 10, 40 40, 20 40, 10 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [points addObject:p];
        point = nil;
    }
    NSArray *listMPoints = @[[[WKTPointM alloc] initWithPoints:points]];
    
    // Create Polygon Geometry
    WKTPolygon *result = [[WKTPolygon alloc] initWithMultiPoints:listMPoints];
    
    // Create Polygon Empty
    WKTPolygon *result2 = [[WKTPolygon alloc] init];
    
    // Copy WKTPolygon to Other WKTPolygon
    [result copyTo:result2];
    
    XCTAssertEqualObjects(result2.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result2.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertTrue([[result2 getExteriorPolygon] isEqual:
             [[WKTPointM alloc] initWithPoints:points]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result2 getInteriorPolygons].count, 0,
             @"Result Interior Polygons should be zero");
    XCTAssertEqual([result2 getPolygon].count, 1,
             @"Result Polygons should be one");
}

- (void)test_Polygon_CopyNilException
{
    // Split Single Parent and Spaces to Format
    NSString *input = @"((30 10, 40 40, 20 40, 10 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    NSArray *split = [WKTString splitCommasNSString:input];
    
    // Create Points from Array's Values
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSArray *point = [WKTString splitSpacesNSString:split[i]];
        WKTPoint *p = [[WKTPoint alloc]
             initWithDimensionX:[point[0] doubleValue]
             andDimensionY:[point[1] doubleValue]];
        [points addObject:p];
        point = nil;
    }
    NSArray *listMPoints = @[[[WKTPointM alloc] initWithPoints:points]];
    
    // Create Polygon Geometry
    WKTPolygon *result = [[WKTPolygon alloc] initWithMultiPoints:listMPoints];
    
    XCTAssertThrows([result copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Polygon_MultiSimple
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
                         ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result = [[WKTPolygonM alloc] initWithPolygons:polygonsList];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be equal two");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 0,
             @"Result Polygon 1 Interior Polygons should be zero");
}

- (void)test_Polygon_MultiEqual
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
                         ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result = [[WKTPolygonM alloc] initWithPolygons:polygonsList];
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result2 = [[WKTPolygonM alloc] initWithPolygons:polygonsList];
    
    // Create Multi Polygon Geometry with another Polygon
    NSMutableArray *listP2 = [[NSMutableArray alloc] initWithArray:polygonsList];
    [listP2 addObject:[polygonsList lastObject]];
    WKTPolygonM *result3 = [[WKTPolygonM alloc] initWithPolygons:listP2];
    
    XCTAssertFalse([result isEqual:nil],
             @"WKTPolygonM is not Equal to nil");
    XCTAssertTrue([result isEqual:result],
             @"WKTPolygonM is Equal to itself");
    XCTAssertTrue([result isEqual:result2],
             @"WKTPolygonM is Equal to WKTPolygonM with same polygons");
    XCTAssertFalse([result isEqual:result3],
             @"WKTPolygonM is not Equal to WKTPolygonM with other polygons");
}

- (void)test_Polygon_MultiCopy
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
                         ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result = [[WKTPolygonM alloc] initWithPolygons:polygonsList];
    
    // Create Multi Polygon Geometry Empty
    WKTPolygonM *result2 = [[WKTPolygonM alloc] init];
    
    // Copy WKTPolygonM to Other WKTPolygonM
    [result copyTo:result2];
    
    XCTAssertEqualObjects(result2.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result2.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result2 getPolygons].count, 2,
             @"Result Polygons should be equal two");
    XCTAssertEqual([[result2 getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result2 getPolygons][1] getInteriorPolygons].count, 0,
             @"Result Polygon 1 Interior Polygons should be zero");
}

- (void)test_Polygon_MultiCopyNilException
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
                         ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result = [[WKTPolygonM alloc] initWithPolygons:polygonsList];
    
    XCTAssertThrows([result copyTo:nil], @"Should throws Nil Exception");
}

- (void)test_Polygon_MultiWKTPolygonException
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
    ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = [[WKTPoint alloc]
                 initWithDimensionX:[point[0] doubleValue]
                 andDimensionY:[point[1] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    [polygonsList addObject:@"WKTPolygon"];
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result;

    XCTAssertThrows(result = [[WKTPolygonM alloc] initWithPolygons:polygonsList],
             @"Should throws WKTPolygon Exception");
}

- (void)test_Polygon_MultiDimensionsException
{
    // Split Double Parent and Commas to Format
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
    ((15 5, 40 10, 10 20, 5 10, 15 5)),((30 50 60, 78 80 90)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    NSArray *split = [WKTString splitDoubleParentCommasNSString:input];
    split = @[[WKTString splitCommasNSString:split[0]],
              [WKTString splitCommasNSString:split[1]],
              [WKTString splitCommasNSString:split[2]]];
    
    // Create Points from Array's Values
    NSMutableArray *polygonsList = [[NSMutableArray alloc] init];
    for(int i = 0; i < split.count; i++)
    {
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for(int j = 0; j < [split[i] count]; j++)
        {
            NSArray *point = [WKTString splitSpacesNSString:split[i][j]];
            WKTPoint *p = (point.count == 2) ?
                 [[WKTPoint alloc]
                    initWithDimensionX:[point[0] doubleValue]
                    andDimensionY:[point[1] doubleValue]] :
                 [[WKTPoint alloc]
                    initWithDimensionX:[point[0] doubleValue]
                    andDimensionY:[point[1] doubleValue]
                    andDimensionZ:[point[2] doubleValue]];
            [points addObject:p];
            point = nil;
        }
        [polygonsList addObject:[[WKTPolygon alloc] initWithMultiPoints:
                      @[[[WKTPointM alloc] initWithPoints:points]]]];
        points = nil;
    }
    
    // Create Multi Polygon Geometry
    WKTPolygonM *result;
    
    XCTAssertThrows(result = [[WKTPolygonM alloc] initWithPolygons:polygonsList],
             @"Should throws Dimensions Exception");
}

@end