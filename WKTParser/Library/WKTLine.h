//
//  WKTLine.h
//
//  WKTParser Line
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

#include "WKTPointM.h"

/**
 This class represent Multi Line [Geometry](WKTGeometry) on WKT Format.
 
 Multi WKT Line really is WKTLine grouped at NSArray.
 
 Its String representation are:
 
 - 2D Representation: LINESTRING (10 10, 20 20, 10 40)
 
 - 3D Representation: LINESTRINGZ (10 10 5, 20 20 0, 10 40 40)
 
 At 3D representation may be LINESTRING Z too.
 
 Example of use:
 
 	WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
 
 	WKTLine *mLine = [[WKTLine alloc] initWithPoints:@[p1, p2]];
 
 Example of MapKit Polygon creation:
 
 	MKPolyline *mapLine = [mLine toMapLine];
 	MKMapView *map = [[MKMapView alloc] init];
 	[map addOverlay: mapLine];
 
Example of WKT representation:
 
 	NSString *wktString = [mLine toWKT];
 	NSLog(@"WKT: %@", wktString);
 
	// WKT: LINESTRING (5 10, 10 10)
 
 */
@interface WKTLine : WKTGeometry {

    NSMutableArray *listPoints;

}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTLine instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Complex Constructor that set default values and points to new instance.
 
 From this point of view, a polyline is similar to multi points.
 
 This method is the same that init join setListPoints:
 
 @param points List of WKTPoint
 @return WKTLine instance
 */
- (instancetype)initWithPoints:(NSArray *)points;

/// @name Internal operations

/**
 Set and check Points List internal property for after that to generate polyline correctly.
 
 @exception WKTLine Parameter is nil, have a class that it is not Point or these classes does not have same dimensions.
 @param points List of WKTPoint
 */
- (void)setListPoints:(NSArray *)points;

/**
 Return Points List internal property.
 
Points List internal property never is nil.
 @return List of WKTPoint that its count always will be equal or greater than zero
 */
- (NSArray *)getListPoints;

/// Clear Points List internal property
- (void)removeListPoints;

/// @name WKTLine operations

/**
 Check if two WKTLine are equal.
 
 @param otherLine WKTLine to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTLine *)otherLine;

/**
 Pass all properties from itself to other WKTLine reference.
 
 @exception WKTLine Parameter is nil.
 @param otherLine WKTLine to pass properties
 */
- (void)copyTo:(WKTLine *)otherLine;

/**
 Return WKT representation.
 
 @return String like LINESTRING ( .... ) or LINESTRING EMPTY
 */
- (NSString *)toWKT;

/// @name MapKit operations

/**
 Return MKPolyline representation.
 
 @return MapKit Polyline for add overlay to map
 */
- (MKPolyline *)toMapLine;

@end