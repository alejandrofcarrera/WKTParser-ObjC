//
//  WKTPolygon.m
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

#include "WKTPolygon.h"

@implementation WKTPolygon

- (id)init
{
    if (self = [super init])
    {
        self.type = @"Polygon";
        self.dimensions = 0;
        listMultiPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithMultiPoints:(NSArray *)multiPoints
{
    if (self = [self init])
    {
        [self setPolygons:multiPoints];
    }
    return self;
}

- (void)setPolygons:(NSArray *)multiPoints
{
    if(multiPoints == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Polygon"
            reason:@"Parameter Multi Points list is nil"
            userInfo:nil];
    }
    else
    {
        int dimBackup = 0;
        for(int i = 0; i < multiPoints.count; i++)
        {
            if(![multiPoints[i] isKindOfClass:[WKTPointM class]])
            {
                @throw [NSException exceptionWithName:@"WKTParser Polygon"
                    reason:@"Parameter points have a class that is not WKTMultiPoint"
                    userInfo:nil];
            }
            else
            {
                if(i == 0)
                {
                    dimBackup = [(WKTPointM *) multiPoints[0] dimensions];
                    [listMultiPoints addObject:multiPoints[0]];
                }
                else if(dimBackup != [(WKTPointM *) multiPoints[i] dimensions])
                {
                    @throw [NSException exceptionWithName:@"WKTParser Polygon"
                        reason:@"Parameter Multi Points list have WKTMultiPoint with \
                        different dimensions" userInfo:nil];
                }
                else
                {
                    [listMultiPoints addObject:multiPoints[i]];
                }
            }
        }
        self.dimensions = dimBackup;
    }
}

- (NSArray *)getPolygon
{
    return listMultiPoints;
}

- (NSArray *)getInteriorPolygons
{
    if(listMultiPoints.count > 1)
    {
        NSMutableArray *polygonsI = [[NSMutableArray alloc] init];
        for(int i = 1; i < listMultiPoints.count; i++)
        {
            [polygonsI addObject:listMultiPoints[i]];
        }
        return polygonsI;
    }
    else
    {
        return [[NSArray alloc] init];
    }
}

- (WKTPointM *)getExteriorPolygon
{
    if(listMultiPoints.count > 0)
    {
        return listMultiPoints[0];
    }
    else
    {
        return [[WKTPointM alloc] init];
    }
}

- (void)removePolygons
{
    [listMultiPoints removeAllObjects];
    self.dimensions = 0;
}

- (BOOL)isEqual:(WKTPolygon *)otherPolygon
{
    if(otherPolygon == nil || ![otherPolygon isKindOfClass:[WKTPolygon class]])
    {
        return NO;
    }
    else if(self.dimensions != otherPolygon.dimensions)
    {
        return NO;
    }
    else if(listMultiPoints.count != [otherPolygon getPolygon].count)
    {
        return NO;
    }
    else if(![[self getExteriorPolygon] isEqual:[otherPolygon getExteriorPolygon]])
    {
        return NO;
    }
    else if([self getInteriorPolygons].count != [otherPolygon getInteriorPolygons].count)
    {
        return NO;
    }
    else
    {
        NSArray *listOtherPoints = [otherPolygon getPolygon];
        for(int i = 0; i < listMultiPoints.count; i++)
        {
            if(![(WKTPointM *) listMultiPoints[i] isEqual:listOtherPoints[i]])
            {
                return NO;
            }
        }
        return YES;
    }
}

- (void)copyTo:(WKTPolygon *)otherPolygon
{
    if(otherPolygon == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Polygon [copyTo]"
            reason:@"Parameter Polygon is nil"
            userInfo:nil];
    }
    else
    {
        otherPolygon.type = self.type;
        otherPolygon.dimensions = self.dimensions;
        [otherPolygon removePolygons];
        [otherPolygon setPolygons: listMultiPoints];
    }
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"(%@)", [self getExteriorPolygon]];
    NSArray *iPolygons = [self getInteriorPolygons];
    if(iPolygons.count > 0)
    {
        description = [description stringByAppendingString:@", "];
    }
    for(int i = 0; i < iPolygons.count; i++)
    {
        NSString *lString = [NSString stringWithFormat:@"(%@)", iPolygons[i]];
        description = [description stringByAppendingString:lString];
        if(i < iPolygons.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
    }
    iPolygons = nil;
    return description;
}

- (NSString *)toWKT
{
    if(listMultiPoints.count == 0)
    {
        return @"POLYGON EMPTY";
    }
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"POLYGON (%@)", self];
    }
    else
    {
        return [NSString stringWithFormat:@"POLYGONZ (%@)", self];
    }
}

- (MKPolygon *)toMapPolygon
{
    
    // Create Exterior Polygon
    NSArray *pointsExtPolygon = [[self getExteriorPolygon] getListPoints];
    CLLocationCoordinate2D extPolygon[pointsExtPolygon.count];
    for(int i = 0; i < pointsExtPolygon.count; i++)
    {
        WKTPoint *p = pointsExtPolygon[i];
        extPolygon[i] = CLLocationCoordinate2DMake(p.dimensionY, p.dimensionX);
        p = nil;
    }
    
    // Create return Polygon
    MKPolygon *result;
    
    // Create Interior Polygon
    NSArray *listIntPolygons = [self getInteriorPolygons];
    if(listIntPolygons.count > 0)
    {
        NSMutableArray *intPolygons = [[NSMutableArray alloc] init];
        for(int i = 0; i < listIntPolygons.count; i++)
        {
            NSArray *pointsIntPolygon = [(WKTPointM *) listIntPolygons[i] getListPoints];
            CLLocationCoordinate2D intPolygon[pointsIntPolygon.count];
            for(int j = 0; j < pointsIntPolygon.count; j++)
            {
                WKTPoint *p = pointsIntPolygon[j];
                intPolygon[j] = CLLocationCoordinate2DMake(p.dimensionY, p.dimensionX);
                p = nil;
            }
            MKPolygon *pInterior = [MKPolygon polygonWithCoordinates:intPolygon count:pointsIntPolygon.count];
            [intPolygons addObject:pInterior];
            pointsIntPolygon = nil;
            pInterior = nil;
        }
        result = [MKPolygon polygonWithCoordinates:extPolygon count:pointsExtPolygon.count interiorPolygons:intPolygons];
    }
    else
    {
        result = [MKPolygon polygonWithCoordinates:extPolygon count:pointsExtPolygon.count];
    }
    return result;
}

@end
