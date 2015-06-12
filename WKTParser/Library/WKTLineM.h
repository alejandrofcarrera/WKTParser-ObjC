//
//  WKTLineM.h
//
//  WKTParser Multi Line
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

#include "WKTLine.h"

/**
 This class represent Multi Line [Geometry](WKTGeometry) on WKT Format.
 
 Multi WKT Line really is WKTLine grouped at NSArray.
 
 Its String representation are:
 
 - 2D Representation: MULTILINESTRING ((10 10, 20 20, 10 40))
 
 - 3D Representation: MULTILINESTRINGZ ((10 10 5, 20 20 0, 10 40 40))
 
 At 3D representation may be MULTIPOLYGON Z too.
 
 Example of use:
 
 	WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
 	WKTLine *mLine1 = [[WKTLine alloc] initWithPoints:@[p1, p2]];

	WKTPoint *p3 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	WKTPoint *p4 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
 	WKTLine *mLine2 = [[WKTLine alloc] initWithPoints:@[p3, p4]];
 
 	WKTLineM *mLine = [[WKTLineM alloc] initWithLines:@[mLine1, mLine2]];
 
 Example of MapKit Polygon creation:
 
 	NSArray *mapLines = [mLine toMapMultiLine];
 	MKMapView *map = [[MKMapView alloc] init];
 	for(MKPolyline *i in mapLines)
	{
		[map addOverlay: i];
 	}
 
 Example of WKT representation:
 
 	NSString *wktString = [mLine toWKT];
 	NSLog(@"WKT: %@", wktString);
 
	// WKT: MULTILINESTRING ((5 10, 10 10), (5 10, 10 10))
 
 */
@interface WKTLineM : WKTGeometry {
    
    NSMutableArray *listLines;
    
}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTLineM instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Complex Constructor that set default values and polygons to new instance.
 
 This method is the same that init join setListLines:
 
 @param lines List of WKTLine
 @return WKTLineM instance
 */
- (instancetype)initWithLines:(NSArray *)lines;

/// @name Internal operations

/**
 Set and check Polyline List internal property.
 
 @exception WKTLineM Parameter is nil, have a class that it is not Polyline or these classes does not have same dimensions.
 @param lines List of WKTLine
 */
- (void)setListLines:(NSArray *)lines;

/**
 Return Polyline List internal property.
 
 Polyline List internal property never is nil.
 @return List of WKTLine that its count always will be equal or greater than zero
 */
- (NSArray *)getListLines;

/// Clear Polyline List internal property
- (void)removeListLines;

/// @name WKTLineM operations

/**
 Check if two WKTLineM are equal.
 
 @param otherLineM WKTLineM to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTLineM *)otherLineM;

/**
 Pass all properties from itself to other WKTLineM reference.
 
 @exception WKTLineM Parameter is nil.
 @param otherLineM WKTLineM to pass properties
 */
- (void)copyTo:(WKTLineM *)otherLineM;

/**
 Return WKT representation.
 
 @return String like MULTILINESTRING (( .... )) or MULTILINESTRING EMPTY
 */
- (NSString *)toWKT;

/// @name MapKit operations

/**
 Return MKPolyline List representation.
 
 @return MapKit Polyline List for add overlay to map or empty array if there are not valid polylines
 */
- (NSArray *)toMapMultiLine;

@end