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

- (id)initWithDimensionX:(double)dimX andDimensionY:(double)dimY
{
    if(self == nil)
    {
        self = [super init];
        self.dimensions = 2;
        self.type = @"Point";
        self.dimensionX = dimX;
        self.dimensionY = dimY;
    }
    return self;
}

- (id)initWithDimensionX:(double)dimX andDimensionY:(double)dimY andDimensionZ:(double)dimZ
{
    if(self == nil)
    {
        self = [super init];
        self.dimensions = 3;
        self.type = @"Point";
        self.dimensionX = dimX;
        self.dimensionY = dimY;
        self.dimensionZ = dimZ;
    }
    return self;
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
        @throw [NSException exceptionWithName:@"WKTParser Point [copyTo]"
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

@end
