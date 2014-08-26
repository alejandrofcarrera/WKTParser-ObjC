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

@interface WKTPoint : WKTGeometry

@property (nonatomic, readwrite) double dimensionX;

@property (nonatomic, readwrite) double dimensionY;

@property (nonatomic, readwrite) double dimensionZ;

- (id)init;

- (id)initWithDimensionX:(double)dimX andDimensionY:(double)dimY;

- (id)initWithDimensionX:(double)dimX andDimensionY:(double)dimY andDimensionZ:(double)dimZ;

- (BOOL)isEqual:(WKTPoint *)otherPoint;

- (void)copyTo:(WKTPoint *)otherPoint;

- (NSString *)toWKT;

- (MKPointAnnotation *)toMapPointAnnotation;

- (MKMapPoint)toMapPoint;

@end
