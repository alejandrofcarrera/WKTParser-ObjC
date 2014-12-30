//
//  WKTGeometryCollection.m
//  WKTParser
//
//  Created by Alejandro Fdez Carrera on 01/09/14.
//  Copyright (c) 2014 Alejandro F. Carrera. All rights reserved.
//

#import "WKTGeometryCollection.h"

@implementation WKTGeometryCollection

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = @"GeometryCollection";
        self.gis = @"CRS84";
        listGeometry = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addGeometry:(WKTGeometry *)geometry
{
    if(geometry == nil)
    {
        @throw [NSException exceptionWithName:@"WKTGeometryCollection [addGeometry]"
            reason:@"Parameter Geometry is nil"
            userInfo:nil];
    }
    else
    {
        if([geometry isKindOfClass:[WKTPoint class]] || [geometry isKindOfClass:[WKTPointM class]] ||
           [geometry isKindOfClass:[WKTLine class]] || [geometry isKindOfClass:[WKTLineM class]] ||
           [geometry isKindOfClass:[WKTPolygon class]] || [geometry isKindOfClass:[WKTPolygonM class]])
        {
            [listGeometry addObject:geometry];
        }
        else
        {
            @throw [NSException exceptionWithName:@"WKTGeometryCollection [addGeometry]"
                reason:@"Geometry is invalid (WKT Geometry not recognised)"
                userInfo:nil];
        }
    }
}

- (void)removeGeometries
{
    [listGeometry removeAllObjects];
    self.dimensions = 0;
}

- (NSArray *)getGeometries
{
    return listGeometry;
}

- (BOOL)isEqual:(WKTGeometryCollection *)otherGeometries
{
    if(otherGeometries == nil || ![otherGeometries isKindOfClass:[WKTGeometryCollection class]])
    {
        return NO;
    }
    else if(self.dimensions != otherGeometries.dimensions)
    {
        return NO;
    }
    else if(listGeometry.count != [otherGeometries getGeometries].count)
    {
        return NO;
    }
    else
    {
        NSArray *listOtherGeometries = [otherGeometries getGeometries];
        for(int i = 0; i < listOtherGeometries.count; i++)
        {
            if(![(WKTGeometry *) listGeometry[i] isEqual:listOtherGeometries[i]])
            {
                return NO;
            }
        }
        return YES;
    }
}

- (void)copyTo:(WKTGeometryCollection *)otherGeometries
{
    if(otherGeometries == nil)
    {
        @throw [NSException exceptionWithName:@"WKTGeometryCollection [copyTo]"
            reason:@"Parameter Geometry Collection is nil"
            userInfo:nil];
    }
    else
    {
        otherGeometries.type = self.type;
        otherGeometries.dimensions = self.dimensions;
        [otherGeometries removeGeometries];
        for(int i = 0; listGeometry.count; i++)
        {
            [otherGeometries addGeometry:listGeometry[i]];
        }
    }
}

- (NSString *)description
{
    NSString *description = @"";
    NSArray *lGeometries = [self getGeometries];
    for(int i = 0; i < lGeometries.count; i++)
    {
        NSString *lString = [NSString stringWithFormat:@"(%@)", lGeometries[i]];
        description = [description stringByAppendingString:lString];
        if(i < lGeometries.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
    }
    lGeometries = nil;
    return description;
}

- (NSString *)toWKT
{
    NSString *description = @"";
    NSArray *lGeometries = [self getGeometries];
    for(int i = 0; i < lGeometries.count; i++)
    {
        NSString *lString = [NSString stringWithFormat:@"%@", [lGeometries[i] toWKT]];
        description = [description stringByAppendingString:lString];
        if(i < lGeometries.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
    }
    lGeometries = nil;
    return [NSString stringWithFormat:@"GEOMETRYCOLLECTION(%@)", description];
}

@end
