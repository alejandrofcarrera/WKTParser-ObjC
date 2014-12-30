//
//  WKTLine.m
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

#include "WKTLine.h"

@implementation WKTLine

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = @"Line";
        self.gis = @"CRS84";
        listPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithPoints:(NSArray *)points
{
    if (self = [self init])
    {
        [self setListPoints:points];
    }
    return self;
}

- (void)setListPoints:(NSArray *)points
{
    if(points == nil)
    {
        @throw [NSException exceptionWithName:@"WKTLine [setListPoints]"
            reason:@"Parameter points is nil"
            userInfo:nil];
    }
    else
    {
        int dimBackup = 0;
        for(int i = 0; i < points.count; i++)
        {
            if(![points[i] isKindOfClass:[WKTPoint class]])
            {
                @throw [NSException exceptionWithName:@"WKTLine [setListPoints]"
                    reason:@"Parameter points have a class that is not WKTPoint"
                    userInfo:nil];
            }
            else
            {
                if(i == 0)
                {
                    dimBackup = [(WKTPoint *) points[0] dimensions];
                    [listPoints addObject:points[0]];
                }
                else if(dimBackup != [(WKTPoint *) points[i] dimensions])
                {
                    @throw [NSException exceptionWithName:@"WKTLine [setListPoints]"
                        reason:@"Parameter points have WKTPoint with different dimensions"
                        userInfo:nil];
                }
                else
                {
                    [listPoints addObject:points[i]];
                }
            }
        }
        self.dimensions = dimBackup;
    }
}

- (NSArray *)getListPoints
{
    return listPoints;
}

- (void)removeListPoints
{
    [listPoints removeAllObjects];
    self.dimensions = 0;
}

- (BOOL)isEqual:(WKTLine *)otherLine
{
    if(otherLine == nil || ![otherLine isKindOfClass:[WKTLine class]])
    {
        return NO;
    }
    else if(self.dimensions != otherLine.dimensions)
    {
        return NO;
    }
    else if(listPoints.count != [otherLine getListPoints].count)
    {
        return NO;
    }
    else
    {
        NSArray *listOtherPoints = [otherLine getListPoints];
        for(int i = 0; i < listPoints.count; i++)
        {
            if(![(WKTPoint *) listPoints[i] isEqual:listOtherPoints[i]])
            {
                return NO;
            }
        }
        return YES;
    }
}

- (void)copyTo:(WKTLine *)otherLine
{
    if(otherLine == nil)
    {
        @throw [NSException exceptionWithName:@"WKTLine [copyTo]"
            reason:@"Parameter Line is nil"
            userInfo:nil];
    }
    else
    {
        otherLine.type = self.type;
        otherLine.dimensions = self.dimensions;
        [otherLine removeListPoints];
        [otherLine setListPoints: listPoints];
    }
}

- (NSString *)description
{
    NSString *description = @"";
    for(int i = 0; i < listPoints.count; i++)
    {
        NSString *pString = [NSString stringWithFormat:@"%@", listPoints[i]];
        description = [description stringByAppendingString:pString];
        if(i < listPoints.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
        pString = nil;
    }
    return description;
}

- (NSString *)toWKT
{
    if(listPoints.count == 0)
    {
        return @"LINESTRING EMPTY";
    }
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"LINESTRING (%@)", self];
    }
    else
    {
        return [NSString stringWithFormat:@"LINESTRINGZ (%@)", self];
    }
}

- (MKPolyline *)toMapLine
{
    CLLocationCoordinate2D points[listPoints.count];
    for(int i = 0; i < listPoints.count; i++)
    {
        points[i] = [listPoints[i] toMapCoordinate];
    }
    return [MKPolyline polylineWithCoordinates:points count:listPoints.count];
}

@end
