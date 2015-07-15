//
//  WKTPoint.h
//
//  WKTParser Point
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

#include "WKTGeometry.h"

/**
 This class represent Point [Geometry](WKTGeometry) on WKT Format.
 
 Its String representation are:
 
 - 2D Representation: POINT (0 0)
 
 - 3D Representation: POINTZ (0 0 0)
 
 At 3D representation may be POINT Z too.
 
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
@interface WKTPoint : WKTGeometry

/// @name Properties

/**
 Dimension X property same as Longitude
 */
@property (nonatomic, readwrite) float dimensionX;

/**
 Dimension Y property same as Latitude
 */
@property (nonatomic, readwrite) float dimensionY;

/**
 Dimension Z property same as Altitude
 */
@property (nonatomic, readwrite) float dimensionZ;

/// @name Constructor

/**
 Basic Constructor that set default values to new instance.
 @return WKTPoint instance
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Complex Constructor that set default values and dimensions to new instance.
 
 This method is the same that init join setDimensionX: and setDimensionY:
 
 @param dimX longitude value (float format)
 @param dimY latitude value (float format)
 @return WKTPoint instance
 */
- (instancetype)initWithDimensionX:(float)dimX andDimensionY:(float)dimY;

/**
 Complex Constructor that set default values and dimensions to new instance.
 
 This method is the same that init join setDimensionX:, setDimensionY: and setDimensionZ: 
 
 @param dimX longitude value (float format)
 @param dimY latitude value (float format)
 @param dimZ altitude value (float format)
 @return WKTPoint instance
 */
- (instancetype)initWithDimensionX:(float)dimX andDimensionY:(float)dimY andDimensionZ:(float)dimZ;

/// @name WKTPoint operations

/**
 Check if two WKTPoint are equal.
 
 @param otherPoint WKTPoint to compare with itself
 @return Boolean
 */
- (BOOL)isEqual:(WKTPoint *)otherPoint;

/**
 Pass all properties from itself to other WKTPoint reference.
 
 @exception WKTPoint Parameter is nil.
 @param otherPoint WKTPoint to pass properties
 */
- (void)copyTo:(WKTPoint *)otherPoint;

/**
 Return WKT representation.
 
 @return String like POINT ( .... ) or POINT EMPTY
 */
- (NSString *)toWKT;

/// @name MapKit operations

/**
 Return MKPointAnnotation representation.

 @exception WKTPoint coordinate is not valid WGS84 format.
 @return MapKit Annotation for add to map
 */
- (MKPointAnnotation *)toMapPointAnnotation;

/**
 Return Coordinate representation.

 @exception WKTPoint coordinate is not valid WGS84 format.
 @return CLLocationCoordinate2D to use
 */
- (CLLocationCoordinate2D)toMapCoordinate;

/**
 Return Location representation.
 
 @exception WKTPoint coordinate is not valid WGS84 format.
 @return CLLocation to use
 */
- (CLLocation *)toLocation;

/**
 Return Point representation.
 
 @exception WKTPoint coordinate is not valid WGS84 format.
 @return MKMapPoint to use
 */
- (MKMapPoint)toMapPoint;

@end
