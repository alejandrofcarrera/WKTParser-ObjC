//
//  WKTPolygon.h
//
//  WKTParser Polygon
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

#include "WKTLineM.h"

/**
 This class represent Polygon [Geometry](WKTGeometry) on WKT Format.
 
 Its String representation are:
 
 - 2D Representation: POLYGON ((0 0, 10 0, 10 10, 0 0))
 
 - 3D Representation: POLYGONZ ((0 0 0, 10 0 5, 10 10 5, 0 0 0))
 
 At 3D representation may be POLYGON Z too.
 
 Example of use:

    WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
    WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0];
    WKTPoint *p3 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:15.0];
    WKTPoint *p4 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:15.0];
 	WKTPointM *points = [[WKTPointM alloc] initWithPoints:@[p1, p2, p3, p4]];
 	WKTPolygon *p = [[WKTPolygon alloc] initWithMultiPoints:@[points]];
 
 Example of MapKit Polygon creation:
 
    MKPolygon *mapPolygon = [p toMapPolygon];
    MKMapView *map = [[MKMapView alloc] init];
    [map addOverlay: mapPolygon];
 
 Example of WKT representation:
 
    NSString *wktString = [p toWKT];
	NSLog(@"WKT: %@", wktString);
 
 	// WKT: POLYGON ((5.000000 10.000000, 10.000000 10.000000, 10.000000 15.000000, 5.000000 15.000000))
 
 */
@interface WKTPolygon : WKTGeometry {
    
    NSMutableArray *listMultiPoints;
    
}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTPolygon instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Complex Constructor that set default values and points to new instance.
 
 From this point of view, a polygon is similar to multi linestring.
 
 This method is the same that init join setPolygons:
 
 @param multiPoints List of WKTPointM
 @return WKTPolygon instance
 */
- (instancetype)initWithMultiPoints:(NSArray *)multiPoints;

/// @name Internal operations

/**
 Set and check Multi Points List internal property for after that to generate polygon correctly.
 
 @exception WKTPolygon Parameter is nil, have a class that it is not Multi Point or these classes does not have same dimensions.
 @param multiPoints List of WKTPointM
 */
- (void)setPolygons:(NSArray *)multiPoints;

/// Clear Multi Points List internal property
- (void)removePolygons;

/**
 Return Multi Points List internal property.

 Multi Points List internal property never is nil.
 @return List of WKTPointM that its count always will be equal or greater than zero
 */
- (NSArray *)getPolygon;

/**
 Return Multi Points List which are internal polygons.

 @return List of WKTPointM that its count always will be equal or greater than zero
 */
- (NSArray *)getInteriorPolygons;

/**
 Return Multi Points which is external polygon.

 @return WKTPointM
 */
- (WKTPointM *)getExteriorPolygon;

/// @name WKTPolygon operations

/**
 Check if two WKTPolygon are equal.

 @param otherPolygon WKTPolygon to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTPolygon *)otherPolygon;

/**
 Pass all properties from itself to other WKTPolygon reference.

 @exception WKTPolygon Parameter is nil.
 @param otherPolygon WKTPolygon to pass properties
 */
- (void)copyTo:(WKTPolygon *)otherPolygon;

/**
 Return WKT representation.
 
 @return String like POLYGON (( .... )) or POLYGON EMPTY
 */
- (NSString *)toWKT;

/// @name MapKit operations

/**
 Return MKPolygon representation.
 
 @return MapKit Polygon for add overlay to map or nil if there is not valid polygon
 */
- (MKPolygon *)toMapPolygon;

@end

