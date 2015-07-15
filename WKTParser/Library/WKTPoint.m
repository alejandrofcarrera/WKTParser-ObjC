//
//  WKTPoint.m
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

#include "WKTPoint.h"

@implementation WKTPoint

@synthesize dimensionX;
@synthesize dimensionY;
@synthesize dimensionZ;

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = @"Point";
        self.gis = @"CRS84";
    }
    return self;
}

- (instancetype)initWithDimensionX:(float)dimX andDimensionY:(float)dimY
{
    if(self = [self init])
    {
        self.dimensions = 2;
        self.dimensionX = dimX;
        self.dimensionY = dimY;
    }
    return self;
}

- (instancetype)initWithDimensionX:(float)dimX andDimensionY:(float)dimY andDimensionZ:(float)dimZ
{
    if(self = [self init])
    {
        self.dimensions = 3;
        self.dimensionX = dimX;
        self.dimensionY = dimY;
        self.dimensionZ = dimZ;
    }
    return self;
}

- (void)setDimensionZ:(float)dimZ
{
    if(self.dimensions)
    {
        self.dimensions = 3;
    }
    dimensionZ = dimZ;
}

- (BOOL)isEqual:(WKTPoint *)otherPoint
{
    if(otherPoint == nil || ![otherPoint isKindOfClass:[WKTPoint class]])
    {
        return NO;
    }
    else if(self.dimensions != otherPoint.dimensions)
    {
        return NO;
    }
    else
    {
        if(self.dimensions == 2)
        {
            return self.dimensionX == otherPoint.dimensionX &&
               self.dimensionY == otherPoint.dimensionY;
        }
        else
        {
            return self.dimensionX == otherPoint.dimensionX &&
               self.dimensionY == otherPoint.dimensionY &&
               self.dimensionZ == otherPoint.dimensionZ;
        }
    }
}

- (void)copyTo:(WKTPoint *)otherPoint
{
    if(otherPoint == nil)
    {
        @throw [NSException exceptionWithName:@"WKTPoint [copyTo]"
            reason:@"Parameter Point is nil"
            userInfo:nil];
    }
    else
    {
        otherPoint.type = self.type;
        otherPoint.dimensions = self.dimensions;
        otherPoint.dimensionX = self.dimensionX;
        otherPoint.dimensionY = self.dimensionY;
        if(self.dimensions == 3)
        {
            otherPoint.dimensionZ = self.dimensionZ;
        }
    }
}

- (NSString *)description
{
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"%f %f", dimensionX, dimensionY];
    }
    else
    {
        return [NSString stringWithFormat:@"%f %f %f", dimensionX, dimensionY, dimensionZ];
    }
}

- (NSString *)toWKT
{
    if(self.dimensions == 0)
    {
        return @"POINT EMPTY";
    }
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"POINT (%@)", self];
    }
    else
    {
        return [NSString stringWithFormat:@"POINTZ (%@)", self];
    }
}

// Latitude (DimensionY) Longitude (DimensionX)
- (MKPointAnnotation *)toMapPointAnnotation
{
    MKPointAnnotation *result = [[MKPointAnnotation alloc] init];
    result.coordinate = [self toMapCoordinate];
    return result;
}

// Latitude (DimensionY) Longitude (DimensionX)
- (CLLocationCoordinate2D)toMapCoordinate
{
    if(![self.gis isEqualToString:@"CRS84"])
    {
        @throw [NSException exceptionWithName:@"WKTPoint [toMapCoordinate]"
            reason:@"Point dimensions are not CRS84 system"
            userInfo:nil];
    }
    return CLLocationCoordinate2DMake(dimensionY, dimensionX);
}

// Latitude (DimensionY) Longitude (DimensionX)
- (CLLocation *)toLocation
{
    if(![self.gis isEqualToString:@"CRS84"])
    {
        @throw [NSException exceptionWithName:@"WKTPoint [toLocation]"
            reason:@"Point dimensions are not CRS84 system"
            userInfo:nil];
    }
    return [[CLLocation alloc] initWithLatitude:dimensionY longitude:dimensionX];
}

// X (DimensionX) Y (DimensionY)
- (MKMapPoint)toMapPoint
{
    if(![self.gis isEqualToString:@"CRS84"])
    {
        @throw [NSException exceptionWithName:@"WKTPoint [toMapPoint]"
            reason:@"Point dimensions are not CRS84 system"
            userInfo:nil];
    }
    return MKMapPointMake(dimensionX, dimensionY);
}

@end
