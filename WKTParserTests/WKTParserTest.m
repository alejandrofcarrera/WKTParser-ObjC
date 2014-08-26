//
//  WKTParserTest.m
//
//  WKTParser Test Case
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
#import "WKTParser.h"

@interface WKTParserTest : XCTestCase

@end

@implementation WKTParserTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_parsePoint_Single2D
{
    NSString *input = @"(30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPoint *result = [WKTParser parsePoint:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"Point",
             @"Result type should be \"Point\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual(result.dimensionX, 30,
             @"Result dimension X should be 30");
    XCTAssertEqual(result.dimensionY, 10,
             @"Result dimension Y should be 10");
    XCTAssertEqual(result.dimensionZ, 0,
             @"Result dimension Z should be 0");
}

- (void)test_parsePoint_Single3D
{
    NSString *input = @"(30 10 50)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPoint *result = [WKTParser parsePoint:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"Point",
             @"Result type should be \"Point\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual(result.dimensionX, 30,
             @"Result dimension X should be 30");
    XCTAssertEqual(result.dimensionY, 10,
             @"Result dimension Y should be 10");
    XCTAssertEqual(result.dimensionZ, 50,
             @"Result dimension Z should be 50");
}

- (void)test_parsePoint_SingleDimException
{
    NSString *input = @"(30 10 50)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPoint *result;
    
    XCTAssertThrows(result = [WKTParser parsePoint:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parsePoint_Multi2D
{
    NSString *input = @"(10 40, 40 30, 20 20, 30 10)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPointM *result = [WKTParser parseMultiPoint:input withDimensions:2];
    NSLog(@"%@ - %@", input, [result getListPoints]);
    XCTAssertEqualObjects(result.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListPoints].count, 4,
             @"Result points should be four");
}

- (void)test_parsePoint_Multi2D_double
{
    NSString *input = @"((10 40), (40 30), (20 20), (30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPointM *result = [WKTParser parseMultiPoint:input withDimensions:2];
    NSLog(@"%@ - %@", input, [result getListPoints]);

    XCTAssertEqualObjects(result.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListPoints].count, 4,
             @"Result points should be four");
}

- (void)test_parsePoint_Multi3D
{
    NSString *input = @"(10 40 50, 40 30 60, 20 20 70, 30 10 80)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPointM *result = [WKTParser parseMultiPoint:input withDimensions:3];
    NSLog(@"%@ - %@", input, [result getListPoints]);

    XCTAssertEqualObjects(result.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getListPoints].count, 4,
             @"Result points should be four");
}

- (void)test_parsePoint_Multi3D_double
{
    NSString *input = @"((10 40 50), (40 30 60), (20 20 70), (30 10 80))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPointM *result = [WKTParser parseMultiPoint:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getListPoints].count, 4,
             @"Result points should be four");
}

- (void)test_parsePoint_MultiDimException
{
    NSString *input = @"(10 40 50, 40 30 60, 20 20 70, 30 10 80)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTPointM *result;
    
    XCTAssertThrows(result = [WKTParser parseMultiPoint:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parseLine_Single2D
{
    NSString *input = @"(30 10, 10 30, 40 40)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTLine *result = [WKTParser parseLine:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"Line",
             @"Result type should be \"Line\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListPoints].count, 3,
             @"Result Points should be three");
}

- (void)test_parseLine_Single3D
{
    NSString *input = @"(30 10 50, 10 30 60, 40 40 70)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTLine *result = [WKTParser parseLine:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"Line",
             @"Result type should be \"Line\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getListPoints].count, 3,
             @"Result Points should be three");
}

- (void)test_parseLine_SingleDimException
{
    NSString *input = @"(30 10 50, 10 30 60, 40 40 70)";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 1) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-1, 1) withString:@""];
    WKTLine *result;
    
    XCTAssertThrows(result = [WKTParser parseLine:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parseLine_Multi2D
{
    NSString *input = @"((10 10, 20 20, 10 40),\
                         (40 40, 30 30, 40 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTLineM *result = [WKTParser parseMultiLine:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"MultiLine",
             @"Result type should be \"MultiLine\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getListLines].count, 2,
             @"Result lines should be two");
    XCTAssertEqual([[result getListLines][0] getListPoints].count, 3,
             @"Result line 0 should have three points");
    XCTAssertEqual([[result getListLines][1] getListPoints].count, 4,
             @"Result line 1 should have four points");
}

- (void)test_parseLine_Multi3D
{
    NSString *input = @"((10 10 50, 20 20 60, 10 40 70),\
                         (40 40 80, 30 30 90, 40 20 100, 30 10 110))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTLineM *result = [WKTParser parseMultiLine:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"MultiLine",
             @"Result type should be \"MultiLine\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getListLines].count, 2,
             @"Result lines should be two");
    XCTAssertEqual([[result getListLines][0] getListPoints].count, 3,
             @"Result line 0 should have three points");
    XCTAssertEqual([[result getListLines][1] getListPoints].count, 4,
             @"Result line 1 should have four points");
}

- (void)test_parseLine_MultiDimException
{
    NSString *input = @"((10 10 50, 20 20 60, 10 40 70),\
                         (40 40 80, 30 30 90, 40 20 100, 30 10 110))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTLineM *result;
    
    XCTAssertThrows(result = [WKTParser parseMultiLine:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parsePolygon_Single2D
{
    NSString *input = @"((30 10, 40 40, 20 40, 10 20, 30 10))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 0,
             @"Result Interior Polygons should be zero");
    XCTAssertEqual([result getPolygon].count, 1,
             @"Result Polygons should be one");
}

- (void)test_parsePolygon_Single3D
{
    NSString *input = @"((30 10 50, 40 40 60, 20 40 70, 10 20 80, 30 10 90))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 0,
             @"Result Interior Polygons should be zero");
    XCTAssertEqual([result getPolygon].count, 1,
             @"Result Polygons should be one");
}

- (void)test_parsePolygon_SingleInterior2D
{
    NSString *input = @"((35 10, 45 45, 15 40, 10 20, 35 10),\
                         (20 30, 35 35, 30 20, 20 30))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 1,
             @"Result Interior Polygons should be one");
    XCTAssertEqual([result getPolygon].count, 2,
             @"Result Polygons should be two");
}

- (void)test_parsePolygon_SingleInterior3D
{
    NSString *input = @"((35 10 50, 45 45 60, 15 40 70, 10 20 80, 35 10 90),\
                         (20 30 100, 35 35 110, 30 20 120, 20 30 130))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 1,
             @"Result Interior Polygons should be one");
    XCTAssertEqual([result getPolygon].count, 2,
             @"Result Polygons should be two");
}

- (void)test_parsePolygon_SingleMultiInterior2D
{
    NSString *input = @"((35 10, 45 45, 15 40, 10 20, 35 10),\
                         (20 30, 35 35, 30 20, 20 30),\
                         (40 5, 20 20))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 2,
             @"Result Interior Polygons should be two");
    XCTAssertEqual([result getPolygon].count, 3,
             @"Result Polygons should be three");
}

- (void)test_parsePolygon_SingleMultiInterior3D
{
    NSString *input = @"((35 10 50, 45 45 60, 15 40 70, 10 20 80, 35 10 90),\
                         (20 30 100, 35 35 110, 30 20 120, 20 30 130),\
                         (40 5 140, 20 20 150))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result = [WKTParser parsePolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertTrue([[result getExteriorPolygon] isEqual:[result getPolygon][0]],
             @"Result Exterior Polygon should be equal Original Polygon");
    XCTAssertEqual([result getInteriorPolygons].count, 2,
             @"Result Interior Polygons should be two");
    XCTAssertEqual([result getPolygon].count, 3,
             @"Result Polygons should be three");
}

- (void)test_parsePolygon_SingleDimException
{
    NSString *input = @"((35 10 50, 45 45 60, 15 40 70, 10 20 80, 35 10 90),\
                         (20 30 100, 35 35 110, 30 20 120, 20 30 130),\
                         (40 5 140, 20 20 150))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 2) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-2, 2) withString:@""];
    WKTPolygon *result;
    
    XCTAssertThrows(result = [WKTParser parsePolygon:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parsePolygon_Multi2D
{
    NSString *input = @"(((30 20, 45 40, 10 40, 30 20)),\
                         ((15 5, 40 10, 10 20, 5 10, 15 5)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 1,
             @"Result Polygon 0 Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 1,
             @"Result Polygon 1 Polygons should be one");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 0,
             @"Result Polygon 1 Interior Polygons should be zero");
}

- (void)test_parsePolygon_Multi3D
{
    NSString *input = @"(((30 20 50, 45 40 60, 10 40 70, 30 20 80)),\
                         ((15 5 90, 40 10 100, 10 20 110, 5 10 120, 15 5 130)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 1,
             @"Result Polygon 0 Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 1,
             @"Result Polygon 1 Polygons should be one");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 0,
             @"Result Polygon 1 Interior Polygons should be zero");
}

- (void)test_parsePolygon_MultiInterior2D
{
    NSString *input = @"(((40 40, 20 45, 45 30, 40 40)),\
                         ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),\
                          (30 20, 20 15, 20 25, 30 20)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 1,
             @"Result Polygon 0 Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 2,
             @"Result Polygon 1 Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 1,
             @"Result Polygon 1 Interior Polygons should be one");
}

- (void)test_parsePolygon_MultiInterior3D
{
    NSString *input = @"(((40 40 50, 20 45 60, 45 30 70, 40 40 80)),\
                         ((20 35 90, 10 30 100, 10 10 110, 30 5 120, 45 20 130, 20 35 140),\
                          (30 20 150, 20 15 160, 20 25 170, 30 20 180)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be three");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 1,
             @"Result Polygon 0 Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 2,
             @"Result Polygon 1 Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Polygon 0 Interior Polygons should be zero");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 1,
             @"Result Polygon 1 Interior Polygons should be one");
}

- (void)test_parsePolygon_MultiMultiInterior2D
{
    NSString *input = @"(((40 40, 20 45, 45 30, 40 40),\
                          (60 70, 20 30)),\
                         ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),\
                          (30 20, 20 15, 20 25, 30 20),\
                          (80 90, 50 60, 78 30)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:2];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 2,
             @"Result Polygon 0 Polygons should be two");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 3,
             @"Result Polygon 1 Polygons should be three");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 1,
             @"Result Polygon 0 Interior Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 2,
             @"Result Polygon 1 Interior Polygons should be two");
}

- (void)test_parsePolygon_MultiMultiInterior3D
{
    NSString *input = @"(((40 40 50, 20 45 60, 45 30 70, 40 40 80),\
                          (60 70 90, 20 30 100)),\
                         ((20 35 110, 10 30 110, 10 10 120, 30 5 130),\
                          (30 20 140, 20 15 150, 20 25 160, 30 20 170),\
                          (80 90 180, 50 60 190, 78 30 200)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result = [WKTParser parseMultiPolygon:input withDimensions:3];
    
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 3,
             @"Result dimensions should be two");
    XCTAssertEqual([result getPolygons].count, 2,
             @"Result Polygons should be two");
    XCTAssertEqual([[result getPolygons][0] getPolygon].count, 2,
             @"Result Polygon 0 Polygons should be two");
    XCTAssertEqual([[result getPolygons][1] getPolygon].count, 3,
             @"Result Polygon 1 Polygons should be three");
    XCTAssertEqual([[result getPolygons][0] getInteriorPolygons].count, 1,
             @"Result Polygon 0 Interior Polygons should be one");
    XCTAssertEqual([[result getPolygons][1] getInteriorPolygons].count, 2,
             @"Result Polygon 1 Interior Polygons should be two");
}

- (void)test_parsePolygon_MultiDimException
{
    NSString *input = @"(((40 40 50, 20 45 60, 45 30 70, 40 40 80),\
                          (60 70 90, 20 30 100)),\
                         ((20 35 110, 10 30 110, 10 10 120, 30 5 130),\
                          (30 20 140, 20 15 150, 20 25 160, 30 20 170),\
                          (80 90 180, 50 60 190, 78 30 200)))";
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(0, 3) withString:@""];
    input = [input stringByReplacingCharactersInRange:
             NSMakeRange(input.length-3, 3) withString:@""];
    WKTPolygonM *result;
    
    XCTAssertThrows(result = [WKTParser parseMultiPolygon:input withDimensions:2],
             @"Should throws Dimension Exception");
}

- (void)test_parseGeometry_NilException
{
    XCTAssertThrows([WKTParser parseGeometry:nil],
             @"Should throws Nil Exception");
}

- (void)test_parseGeometry_GeometryException
{
    XCTAssertThrows([WKTParser parseGeometry:@"MEGAPOINT"],
             @"Should throws Geometry Exception");
}

- (void)test_parseGeometry_ParentsException
{
    XCTAssertThrows([WKTParser parseGeometry:@"POINT(20 10"],
             @"Should throws Bad Format Exception");
    XCTAssertThrows([WKTParser parseGeometry:@"MULTILINESTRING(20 10"],
             @"Should throws Bad Format Exception");
    XCTAssertThrows([WKTParser parseGeometry:@"POLYGON(20 10"],
             @"Should throws Bad Format Exception");
}

- (void)test_parseGeometry_SinglePoint
{
    WKTGeometry *result = [WKTParser parseGeometry:@"POINT (30 10)"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"POINTZ (30 10 50)"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTPoint class]],
             @"Result should be equal WKTPoint (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTPoint class]],
             @"Result should be equal WKTPoint");
    XCTAssertEqualObjects(result.type, @"Point",
             @"Result type should be \"Point\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTPoint *)result dimensionX], 30,
             @"Result dimension X should be 30");
    XCTAssertEqual([(WKTPoint *)result dimensionY], 10,
             @"Result dimension Y should be 10");
    XCTAssertEqual([(WKTPoint *)result2 dimensionZ], 50,
             @"Result2 dimension Z should be 50");
}

- (void)test_parseGeometry_MultiPoint
{
    WKTGeometry *result = [WKTParser parseGeometry:@"MULTIPOINT ((10 40), (40 30), (20 20))"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"MULTIPOINT Z ((10 40 50), (40 30 60))"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTPointM class]],
             @"Result should be equal WKTPointM (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTPointM class]],
             @"Result should be equal WKTPointM");
    XCTAssertEqualObjects(result.type, @"MultiPoint",
             @"Result type should be \"MultiPoint\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTPointM *) result getListPoints].count, 3,
             @"Result points should be three");
    XCTAssertEqual([(WKTPointM *) result2 getListPoints].count, 2,
             @"Result points should be two");
}

- (void)test_parseGeometry_SingleLine
{
    WKTGeometry *result = [WKTParser parseGeometry:@"LINESTRING (30 10, 10 30, 40 40)"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"LINESTRINGZ(30 10 50, 40 40 80)"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTLine class]],
             @"Result should be equal WKTLine (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTLine class]],
             @"Result should be equal WKTLine");
    XCTAssertEqualObjects(result.type, @"Line",
             @"Result type should be \"Line\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTLine *)result getListPoints].count, 3,
             @"Result points should be three");
    XCTAssertEqual([(WKTLine *)result2 getListPoints].count, 2,
             @"Result points should be two");
}

- (void)test_parseGeometry_MultiLine
{
    WKTGeometry *result = [WKTParser parseGeometry:@"MULTILINESTRING ((10 10, 20 20, 10 40),\
             (40 40, 30 30, 40 20, 30 10))"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"MULTILINESTRINGZ ((10 10 50, 20 20 60, 10 40 70),\
             (40 40 80, 30 30 90))"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTLineM class]],
             @"Result should be equal WKTLineM (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTLineM class]],
             @"Result should be equal WKTLineM");
    XCTAssertEqualObjects(result.type, @"MultiLine",
             @"Result type should be \"MultiLine\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTLineM *)result getListLines].count, 2,
             @"Result lines should be two");
    XCTAssertEqual([(WKTLineM *)result2 getListLines].count, 2,
             @"Result lines should be two");
    XCTAssertEqual([[(WKTLineM *)result getListLines][0] getListPoints].count, 3,
             @"Result Line 0 points should be three");
    XCTAssertEqual([[(WKTLineM *)result getListLines][1] getListPoints].count, 4,
             @"Result Line 1 points should be four");
    XCTAssertEqual([[(WKTLineM *)result2 getListLines][0] getListPoints].count, 3,
             @"Result 2 Line 0 points should be three");
    XCTAssertEqual([[(WKTLineM *)result2 getListLines][1] getListPoints].count, 2,
             @"Result 2 Line 1 points should be two");
}

- (void)test_parseGeometry_SinglePolygon
{
    WKTGeometry *result = [WKTParser parseGeometry:@"POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"POLYGON Z((30 10 50, 40 40 10, 20 40 5, 10 20 2))"];
    WKTGeometry *result3 = [WKTParser parseGeometry:@"POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),\
             (20 30, 35 35, 30 20, 20 30))"];
    WKTGeometry *result4 = [WKTParser parseGeometry:@"POLYGONZ ((35 10 50, 45 45 10, 15 40 5, 10 20 2),\
             (20 30 5, 35 35 2, 30 20 1, 20 30 0))"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTPolygon class]],
             @"Result should be equal WKTPolygon (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTPolygon class]],
             @"Result should be equal WKTPolygon");
    XCTAssertEqualObjects(result.type, @"Polygon",
             @"Result type should be \"Polygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTPolygon *)result getPolygon].count, 1,
             @"Result polygons should be one");
    XCTAssertEqual([(WKTPolygon *)result2 getPolygon].count, 1,
             @"Result 2 polygons should be one");
    XCTAssertEqual([(WKTPolygon *)result3 getPolygon].count, 2,
             @"Result 3 polygons should be two");
    XCTAssertEqual([(WKTPolygon *)result4 getPolygon].count, 2,
             @"Result 4 polygons should be two");
    XCTAssertEqual([(WKTPolygon *)result3 getInteriorPolygons].count, 1,
             @"Result 3 Interior polygons should be one");
    XCTAssertEqual([(WKTPolygon *)result4 getInteriorPolygons].count, 1,
             @"Result 4 Interior polygons should be two");
}

- (void)test_parseGeometry_MultiPolygon
{
    WKTGeometry *result = [WKTParser parseGeometry:@"MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),\
             ((15 5, 40 10, 10 20, 5 10, 15 5)))"];
    WKTGeometry *result2 = [WKTParser parseGeometry:@"MULTIPOLYGONZ (((30 20 60, 45 40 80, 10 40 1, 30 20 5)),\
             ((15 5 0, 40 10 10, 10 20 40, 5 10 50, 15 5 6)))"];
    WKTGeometry *result3 = [WKTParser parseGeometry:@"MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40),\
             (60 70, 20 30)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),\
             (30 20, 20 15, 20 25, 30 20),(80 90, 50 60, 78 30)))"];
    WKTGeometry *result4 = [WKTParser parseGeometry:@"MULTIPOLYGON Z (((40 40 50, 20 45 60, 45 30 70, 40 40 80),\
             (60 70 90, 20 30 100)),((20 35 110, 10 30 110, 10 10 120, 30 5 130),\
             (30 20 140, 20 15 150, 20 25 160, 30 20 170),(80 90 180, 50 60 190, 78 30 200)))"];
    XCTAssertTrue([result isKindOfClass:[WKTGeometry class]],
             @"Result should be equal WKTGeometry (Super class)");
    XCTAssertTrue([result isKindOfClass:[WKTPolygonM class]],
             @"Result should be equal WKTPolygonM (Main class)");
    XCTAssertTrue([result isMemberOfClass:[WKTPolygonM class]],
             @"Result should be equal WKTPolygonM");
    XCTAssertEqualObjects(result.type, @"MultiPolygon",
             @"Result type should be \"MultiPolygon\"");
    XCTAssertEqual(result.dimensions, 2,
             @"Result dimensions should be two");
    XCTAssertEqual([(WKTPolygonM *)result getPolygons].count, 2,
             @"Result polygons should be two");
    XCTAssertEqual([(WKTPolygonM *)result2 getPolygons].count, 2,
             @"Result 2 polygons should be two");
    XCTAssertEqual([(WKTPolygonM *)result3 getPolygons].count, 2,
             @"Result 3 polygons should be two");
    XCTAssertEqual([(WKTPolygonM *)result4 getPolygons].count, 2,
             @"Result 4 polygons should be two");
    XCTAssertEqual([[(WKTPolygonM *)result getPolygons][0] getInteriorPolygons].count, 0,
             @"Result Interior Polygon 0 should be zero");
    XCTAssertEqual([[(WKTPolygonM *)result3 getPolygons][0] getInteriorPolygons].count, 1,
             @"Result 3 Interior Polygon 0 should be one");
    XCTAssertEqual([[(WKTPolygonM *)result4 getPolygons][1] getInteriorPolygons].count, 2,
             @"Result 4 Interior Polygon 1 should be two");
}

@end