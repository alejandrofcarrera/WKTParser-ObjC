//
//  WKTPointM.h
//
//  WKTParser Multi Point
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

#include "WKTPoint.h"

/**
 This class represent Multi Point [Geometry](WKTGeometry) on WKT Format.
 
 Its String representation are:
 
 - 2D Representation: MULTIPOINT ((10 40), (40 30)) or MULTIPOINT (10 40, 40 30)
 
 - 3D Representation: MULTIPOINTZ ((10 40 10), (40 30 5)) or MULTIPOINT (10 40 10, 40 30 5)
 
 At 3D representation may be MULTIPOINT Z too.
 
 Example of use:
 
	WKTPoint *p1 = [[WKTPoint alloc] initWithDimensionX:5.0 andDimensionY:10.0];
	
	WKTPoint *p2 = [[WKTPoint alloc] initWithDimensionX:10.0 andDimensionY:10.0 andDimensionZ:5.0];
 
 Example of MapKit Annotation creation:
 
	MKPointAnnotation *mapPoint = [p1 toMapPointAnnotation];
	[mapPoint setTitle: @"Annotation title"];
 [mapPoint setSubtitle: @"Annotation subtitle"];
	MKMapView *map = [[MKMapView alloc] init];
 [map addAnnotation: mapPoint];
 
 Example of MapKit Point creation:
 
	MKMapPoint coordinateMPoint = [p1 toMapPoint];
	MKPointAnnotation *a1 = [[MKPointAnnotation alloc] init];
	[a1 setCoordinate:MKCoordinateForMapPoint(coordinateMPoint)];
 [a1 setTitle: @"Annotation title"];
 [a1 setSubtitle: @"Annotation subtitle"];
	[map addAnnotation: a1];
 
 Example of Location creation:
 
	CLLocation *loc1 = [p1 toLocation];
 CLLocation *loc2 = [p2 toLocation];
 
 // Distance between two locations
 CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
 
 Example of Coordinate creation:
 
	CLLocationCoordinate2D coord1 = [p1 toMapCoordinate];
 
	MKPointAnnotation *a2 = [[MKPointAnnotation alloc] init];
	[a2 setCoordinate:coordinatePoint];
 [a2 setTitle: @"Annotation title"];
 [a2 setSubtitle: @"Annotation subtitle"];
	[map addAnnotation: a2];
 
 Example of WKT representation:
 
	NSString *wktString = [p1 toWKT];
 NSLog(@"WKT: %@", wktString);
 
	// WKT: POINT (5.000000 10.000000)
 
 */
@interface WKTPointM : WKTGeometry {
    
    NSMutableArray *listPoints;
    
}

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTPointM instance
 */
- (instancetype)init;

/**
 Complex Constructor that set default values and points to new instance.
  
 This method is the same that init join setListPoints:
 
 @param points List of WKTPoint
 @return WKTPointM instance
 */
- (instancetype)initWithPoints:(NSArray *)points;

/// @name Internal operations

/**
 Set and check Points List internal property.
 
 @exception WKTPointM Parameter is nil, have a class that it is not Point or these classes does not have same dimensions.
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

/// @name WKTPolygon operations

/**
 Check if two WKTPointM are equal.
 
 @param otherPointM WKTPointM to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTPointM *)otherPointM;

/**
 Pass all properties from itself to other WKTPointM reference.
 
 @exception WKTPointM Parameter is nil.
 @param otherPointM WKTPointM to pass properties
 */
- (void)copyTo:(WKTPointM *)otherPointM;

/**
 Return WKT representation.
 
 @return String like MULTIPOINT ( .... ) or MULTIPOINT EMPTY
 */
- (NSString *)toWKT;

/**
 Return MKPointAnnotation List representation.
 
 @return MapKit Annotation List for add to map or empty array if there are not valid points
 */
- (NSArray *)toMapMultiAnnotation;

@end
