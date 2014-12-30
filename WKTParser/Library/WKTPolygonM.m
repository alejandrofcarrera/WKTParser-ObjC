//
//  WKTPolygonM.m
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

#include "WKTPolygonM.h"

@implementation WKTPolygonM

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = @"MultiPolygon";
        self.gis = @"CRS84";
        listPolygons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithPolygons:(NSArray *)polygons
{
    if (self = [self init])
    {
        [self setPolygons:polygons];
    }
    return self;
}

- (void)setPolygons:(NSArray *)polygons
{
    if(polygons == nil)
    {
        @throw [NSException exceptionWithName:@"WKTPolygonM [setPolygons]"
            reason:@"Parameter Polygons is nil"
            userInfo:nil];
    }
    else
    {
        int dimBackup = 0;
        for(int i = 0; i < polygons.count; i++)
        {
            if(![polygons[i] isKindOfClass:[WKTPolygon class]])
            {
                @throw [NSException exceptionWithName:@"WKTPolygonM [setPolygons]"
                    reason:@"Parameter Polygons have a class that is not WKTPolygon"
                    userInfo:nil];
            }
            else
            {
                if(i == 0)
                {
                    dimBackup = [(WKTPolygon *) polygons[0] dimensions];
                    [listPolygons addObject:polygons[0]];
                }
                else if(dimBackup != [(WKTPolygon *) polygons[i] dimensions])
                {
                    @throw [NSException exceptionWithName:@"WKTPolygonM [setPolygons]"
                        reason:@"Parameter Polygons have WKTPolygon with \
                        different dimensions" userInfo:nil];
                }
                else
                {
                    [listPolygons addObject:polygons[i]];
                }
            }
        }
        self.dimensions = dimBackup;
    }
}

- (NSArray *)getPolygons
{
    return listPolygons;
}

- (void)removePolygons
{
    [listPolygons removeAllObjects];
    self.dimensions = 0;
}

- (BOOL)isEqual:(WKTPolygonM *)otherPolygonM
{
    if(otherPolygonM == nil || ![otherPolygonM isKindOfClass:[WKTPolygonM class]])
    {
        return NO;
    }
    else if(self.dimensions != otherPolygonM.dimensions)
    {
        return NO;
    }
    else if(listPolygons.count != [otherPolygonM getPolygons].count)
    {
        return NO;
    }
    else
    {
        NSArray *listOtherPolygons = [otherPolygonM getPolygons];
        for(int i = 0; i < listPolygons.count; i++)
        {
            if(![(WKTPolygon *) listPolygons[i] isEqual:listOtherPolygons[i]])
            {
                return NO;
            }
        }
        return YES;
    }
}

- (void)copyTo:(WKTPolygonM *)otherPolygonM
{
    if(otherPolygonM == nil)
    {
        @throw [NSException exceptionWithName:@"WKTPolygonM [copyTo]"
            reason:@"Parameter Multi Polygon is nil"
            userInfo:nil];
    }
    else
    {
        otherPolygonM.type = self.type;
        otherPolygonM.dimensions = self.dimensions;
        [otherPolygonM removePolygons];
        [otherPolygonM setPolygons: listPolygons];
    }
}

- (NSString *)description
{
    NSString *description = @"";
    NSArray *lPolygons = [self getPolygons];
    for(int i = 0; i < lPolygons.count; i++)
    {
        NSString *lString = [NSString stringWithFormat:@"(%@)", lPolygons[i]];
        description = [description stringByAppendingString:lString];
        if(i < lPolygons.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
        lString = nil;
    }
    lPolygons = nil;
    return description;
}

- (NSString *)toWKT
{
    if(listPolygons.count == 0)
    {
        return @"MULTIPOLYGON EMPTY";
    }
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"MULTIPOLYGON (%@)", self];
    }
    else
    {
        return [NSString stringWithFormat:@"MULTIPOLYGONZ (%@)", self];
    }
}

- (NSArray *)toMapMultiPolygon
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *polygons = [self getPolygons];
    for(int i = 0; i < polygons.count; i++)
    {
        [result addObject:[(WKTPolygon *) polygons[i] toMapPolygon]];
    }
    polygons = nil;
    return result;
}


@end
