//
//  WKTGeometryCollection.h
//
//  WKTParser Geometry Collection
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

#include "WKTPolygonM.h"

/**
 This class represent [Geometry](WKTGeometry) Collection on WKT Format.
 
 WKT GeometryCollection really is WKTGeometry grouped at NSArray.
 
 Its String representation is for example: GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))
 
 GeometryCollection only have 2D representation.
 
 Example of use:
 
	WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
	WKTPoint *p3 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:15.0];
	WKTPoint *p4 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:15.0];
	WKTPointM *pointsP1 = [[WKTPointM alloc] initWithPoints:@[p1, p2, p3, p4]];
	WKTPolygon *polygon1 = [[WKTPolygon alloc] initWithMultiPoints:@[pointsP1]];
 
	WKTPoint *p5 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
 
	WKTGeometryCollection *gC = [[WKTGeometryCollection alloc] init];
 	[gC addGeometry:polygon1];
 	[gC addGeometry:p5];
 
 Example of WKT representation:
 
 	NSString *wktString = [gC toWKT];
 	NSLog(@"WKT: %@", wktString);
 
 	// WKT: GEOMETRYCOLLECTION(POLYGON ((5.000000 10.000000, 10.000000 10.000000, 10.000000
 	// 15.000000, 5.000000 15.000000)), POINT (10.000000 10.000000))
 
 */
@interface WKTGeometryCollection : WKTGeometry {
    
    NSMutableArray *listGeometry;
    
}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTGeometryCollection instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// @name Internal operations

/**
 Add WKTGeometry to Geometry List internal property.
 
 @exception WKTGeometryCollection Parameter is nil or these classes are not valid WKTGeometry.
 @param geometry WKTGeometry to add
 */
- (void)addGeometry:(WKTGeometry *)geometry;

/// Clear Geometry List internal property.
- (void)removeGeometries;

/**
 Return Geometry List internal property.
 
 Geometry List internal property never is nil.
 @return List of WKTGeometry that its count always will be equal or greater than zero
 */
- (NSArray *)getGeometries;

/// @name WKTGeometryCollection operations

/**
 Check if two WKTGeometryCollection are equal.
 
 @param otherGeometries WKTGeometryCollection to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTGeometryCollection *)otherGeometries;

/**
 Pass all properties from itself to other WKTGeometryCollection reference.
 
 @exception WKTGeometryCollection Parameter is nil.
 @param otherGeometries WKTGeometryCollection to pass properties
 */
- (void)copyTo:(WKTGeometryCollection *)otherGeometries;

/**
 Return WKT representation.
 
 @return String like GEOMETRYCOLLECTION ( .... ) or GEOMETRYCOLLECTION EMPTY
 */
- (NSString *)toWKT;

@end
