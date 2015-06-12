//
//  WKTPolygonM.h
//
//  WKTParser Multi Polygon
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

#include "WKTPolygon.h"

/**
 This class represent Multi Polygon [Geometry](WKTGeometry) on WKT Format.
 
 Multi WKT Polygon really is WKTPolygon grouped at NSArray.

 Its String representation are:
 
 - 2D Representation: MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)), ((10 10, 20 20, 30 30, 40 40)))
 
 - 3D Representation: MULTIPOLYGONZ (((0 0 0, 10 0 5, 10 10 5, 0 0 0)), ((10 10 0, 20 20 5, 30 30 5, 40 40 0)))
 
 At 3D representation may be MULTIPOLYGON Z too.
 
 Example of use:
 
	WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
	WKTPoint *p3 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:15.0];
	WKTPoint *p4 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:15.0];
	WKTPointM *pointsP1 = [[WKTPointM alloc] initWithPoints:@[p1, p2, p3, p4]];
	WKTPolygon *polygon1 = [[WKTPolygon alloc] initWithMultiPoints:@[pointsP1]];
 
	WKTPoint *p5 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
	WKTPoint *p6 = [[WKTPoint alloc] initWithDimensionX:20.0 andDimensionY:20.0];
	WKTPoint *p7 = [[WKTPoint alloc] initWithDimensionX:30.0 andDimensionY:30.0];
	WKTPoint *p8 = [[WKTPoint alloc] initWithDimensionX:40.0 andDimensionY:40.0];
	WKTPointM *pointsP2 = [[WKTPointM alloc] initWithPoints:@[p5, p6, p7, p8]];
	WKTPolygon *polygon2 = [[WKTPolygon alloc] initWithMultiPoints:@[pointsP2]];
 
	WKTPolygonM *pM = [[WKTPolygonM alloc] initWithPolygons:@[polygon1, polygon2]];
 
 Example of MapKit Polygon creation:
 
 	NSArray *mapPolygons = [pM toMapMultiPolygon];
 	MKMapView *map = [[MKMapView alloc] init];
    for(MKPolygon *i in mapPolygons)
 	{
		[map addOverlay: i];
 	}
 
 Example of WKT representation:
 
 	NSString *wktString = [pM toWKT];
 	NSLog(@"WKT: %@", wktString);
 	
 	// WKT: MULTIPOLYGON (((5.000000 10.000000, 10.000000 10.000000, 10.000000 15.000000,
 	//      5.000000 15.000000)), ((10.000000 10.000000, 20.000000 20.000000, 30.000000 
 	//      30.000000, 40.000000 40.000000)))
 
 */
@interface WKTPolygonM : WKTGeometry {
 
    NSMutableArray *listPolygons;
    
}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTPolygonM instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Complex Constructor that set default values and polygons to new instance.
 
 This method is the same that init join setPolygons:
 
 @param polygons List of WKTPolygon
 @return WKTPolygonM instance
 */
- (instancetype)initWithPolygons:(NSArray *)polygons;

/// @name Internal operations

/**
 Set and check Polygon List internal property.
 
 @exception WKTPolygonM Parameter is nil, have a class that it is not Polygon or these classes does not have same dimensions.
 @param polygons List of WKTPolygon
 */
- (void)setPolygons:(NSArray *)polygons;

/// Clear Polygon List internal property
- (void)removePolygons;

/**
 Return Polygon List internal property.
 
 Polygon List internal property never is nil.
 @return List of WKTPolygon that its count always will be equal or greater than zero
 */
- (NSArray *)getPolygons;

/// @name WKTPolygonM operations

/**
 Check if two WKTPolygonM are equal.
 
 @param otherPolygonM WKTPolygonM to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTPolygonM *)otherPolygonM;

/**
 Pass all properties from itself to other WKTPolygonM reference.

 @exception WKTPolygonM Parameter is nil.
 @param otherPolygonM WKTPolygonM to pass properties
 */
- (void)copyTo:(WKTPolygonM *)otherPolygonM;

/**
 Return WKT representation.
 
 @return String like MULTIPOLYGON ((( .... ))) or MULTIPOLYGON EMPTY
 */
- (NSString *)toWKT;

/// @name MapKit operations

/**
 Return MKPolygon List representation.
 
 @return MapKit Polygon List for add overlay to map or empty array if there are not valid polygons
 */
- (NSArray *)toMapMultiPolygon;

@end

