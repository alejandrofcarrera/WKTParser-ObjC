//
//  WKTParser.h
//
//  WKTParser Library
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

#include "WKTGeometryCollection.h"
#include "WKTString.h"

/** 
 This class represent Class Parser Utilities.
 
 It is recommend use generic method.
 */

@interface WKTParser : NSObject

/// @name Specific Methods

/**
 Specific parser for generate Point Geometry

 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTPoint instance
*/
+ (WKTPoint *)parsePoint:(NSString *)input withDimensions:(int)dims;

/**
 Specific parser for generate Multi Point Geometry
 
 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTPointM instance
 */
+ (WKTPointM *)parseMultiPoint:(NSString *)input withDimensions:(int)dims;

/**
 Specific parser for generate Line Geometry
 
 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTLine instance
 */
+ (WKTLine *)parseLine:(NSString *)input withDimensions:(int)dims;

/**
 Specific parser for generate Multi Line Geometry
 
 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTLineM instance
 */
+ (WKTLineM *)parseMultiLine:(NSString *)input withDimensions:(int)dims;

/**
 Specific parser for generate Polygon Geometry
 
 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTPolygon instance
 */
+ (WKTPolygon *)parsePolygon:(NSString *)input withDimensions:(int)dims;

/**
 Specific parser for generate Multi Polygon Geometry
 
 @param dims dimension value (int format)
 @param input string value for parse
 @return WKTPolygonM instance
 */
+ (WKTPolygonM *)parseMultiPolygon:(NSString *)input withDimensions:(int)dims;

/// @name Generic Method

/**
 Return Geometry from String parsed.
 
 @param input String for generate WKTGeometry
 @return WKTGeometry parsed
 */
+ (WKTGeometry *)parseGeometry:(NSString *)input;

@end

