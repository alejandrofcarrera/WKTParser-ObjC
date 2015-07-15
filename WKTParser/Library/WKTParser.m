//
//  WKTParser.m
//
//  WKTParser Library
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

#include "WKTParser.h"

@implementation WKTParser

+ (NSString *)checkTypeWKT:(NSString *)input
{
    NSArray *WKT_Types = @[@"POINT", @"MULTIPOINT", @"LINESTRING",
            @"MULTILINESTRING", @"POLYGON", @"MULTIPOLYGON", @"POINTZ",
            @"POINT Z", @"MULTIPOINTZ", @"MULTIPOINT Z", @"LINESTRINGZ",
            @"LINESTRING Z", @"MULTILINESTRINGZ", @"MULTILINESTRING Z",
            @"POLYGONZ", @"POLYGON Z", @"MULTIPOLYGONZ", @"MULTIPOLYGON Z",
            @"GEOMETRYCOLLECTION"];
    NSString *result = nil;
    for(NSString *i in WKT_Types)
    {
        if([input rangeOfString:i].location != NSNotFound)
        {
            result = i;
        }
    }
    WKT_Types = nil;
    return result;
}

+ (NSString *)cleanParents:(NSString *)input withTypeGeometry:(NSString *)tGeometry
{
    // Remove one Parent
    if([tGeometry isEqualToString:@"POINT"] || [tGeometry isEqualToString:@"POINT Z"] ||
       [tGeometry isEqualToString:@"POINTZ"] || [tGeometry isEqualToString:@"MULTIPOINT"] ||
       [tGeometry isEqualToString:@"MULTIPOINT Z"] || [tGeometry isEqualToString:@"MULTIPOINTZ"] ||
       [tGeometry isEqualToString:@"LINESTRING"] || [tGeometry isEqualToString:@"LINESTRING Z"] ||
       [tGeometry isEqualToString:@"LINESTRINGZ"] || [tGeometry isEqualToString:@"GEOMETRYCOLLECTION"])
    {
        if([input characterAtIndex:0] != '(' || [input characterAtIndex:input.length-1] != ')')
        {
            @throw [NSException exceptionWithName:@"WKTParser Library"
                reason:@"Parameter input is invalid (Bad Format WKT Geometry)"
                userInfo:nil];
        }
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(0, 1) withString:@""];
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(input.length-1, 1) withString:@""];
    }
    
    // Remove two Parents
    else if([tGeometry isEqualToString:@"MULTILINESTRING"] || [tGeometry isEqualToString:@"MULTILINESTRING Z"] ||
       [tGeometry isEqualToString:@"MULTILINESTRINGZ"] || [tGeometry isEqualToString:@"POLYGON"] ||
       [tGeometry isEqualToString:@"POLYGON Z"] || [tGeometry isEqualToString:@"POLYGONZ"])
    {
        if([input characterAtIndex:0] != '(' || [input characterAtIndex:input.length-1] != ')' ||
           [input characterAtIndex:1] != '(' || [input characterAtIndex:input.length-2] != ')')
        {
            @throw [NSException exceptionWithName:@"WKTParser Library"
                reason:@"Parameter input is invalid (Bad Format WKT Geometry)"
                userInfo:nil];
        }
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(0, 2) withString:@""];
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(input.length-2, 2) withString:@""];
    }
    
    // Remove three Parents
    else if([tGeometry isEqualToString:@"MULTIPOLYGON"] || [tGeometry isEqualToString:@"MULTIPOLYGON Z"] ||
        [tGeometry isEqualToString:@"MULTIPOLYGONZ"])
    {
        if([input characterAtIndex:0] != '(' || [input characterAtIndex:input.length-1] != ')' ||
           [input characterAtIndex:1] != '(' || [input characterAtIndex:input.length-2] != ')' ||
           [input characterAtIndex:2] != '(' || [input characterAtIndex:input.length-3] != ')')
        {
            @throw [NSException exceptionWithName:@"WKTParser Library"
                reason:@"Parameter input is invalid (Bad Format WKT Geometry)"
                userInfo:nil];
        }
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(0, 3) withString:@""];
        input = [input stringByReplacingCharactersInRange:
                 NSMakeRange(input.length-3, 3) withString:@""];
    }
    return input;
}

+ (WKTPoint *)parsePoint:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTPoint alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitSpacesNSString:input];
    WKTPoint *result;
    if(inputSplitted.count != dims)
    {
        @throw [NSException exceptionWithName:@"WKTParser Library"
            reason:@"Dimensions is not equal point's number (Parse WKTPoint)"
            userInfo:nil];
    }
    else if(dims == 3)
    {
        result = [[WKTPoint alloc] initWithDimensionX:[inputSplitted[0] floatValue]
            andDimensionY:[inputSplitted[1] floatValue] andDimensionZ:
            [inputSplitted[2] floatValue]];
    }
    else
    {
        result = [[WKTPoint alloc] initWithDimensionX:[inputSplitted[0] floatValue]
            andDimensionY:[inputSplitted[1] floatValue]];
    }
    inputSplitted = nil;
    return result;
}

+ (WKTPointM *)parseMultiPoint:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTPointM alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitParentCommasNSString:input];
    NSString *newInput = input;
    if(inputSplitted.count > 1)
    {
        newInput = [newInput stringByReplacingCharactersInRange:
                 NSMakeRange(0, 1) withString:@""];
        newInput = [newInput stringByReplacingCharactersInRange:
                 NSMakeRange(newInput.length-1, 1) withString:@""];
        inputSplitted = [WKTString splitParentCommasNSString:newInput];
    }
    else
    {
        inputSplitted = [WKTString splitCommasNSString:newInput];
    }
    NSMutableArray *inputPoints = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputPoints addObject:[self parsePoint:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTPointM alloc] initWithPoints:inputPoints];
}

+ (WKTLine *)parseLine:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTLine alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitCommasNSString:input];
    NSMutableArray *inputPoints = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputPoints addObject:[self parsePoint:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTLine alloc] initWithPoints:inputPoints];
}

+ (WKTLineM *)parseMultiLine:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTLineM alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitParentCommasNSString:input];
    NSMutableArray *inputLines = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputLines addObject:[self parseLine:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTLineM alloc] initWithLines:inputLines];
}

+ (WKTPolygon *)parsePolygon:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTPolygon alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitParentCommasNSString:input];
    NSString *newInput = input;
    if(inputSplitted.count > 1)
    {
        inputSplitted = [WKTString splitParentCommasNSString:newInput];
    }
    NSMutableArray *inputPoints = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputPoints addObject:[self parseMultiPoint:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTPolygon alloc] initWithMultiPoints:inputPoints];
}

+ (WKTPolygonM *)parseMultiPolygon:(NSString *)input withDimensions:(int)dims
{
    if([input isEqualToString:@"EMPTY"])
    {
        return [[WKTPolygonM alloc] init];
    }
    NSArray *inputSplitted = [WKTString splitDoubleParentCommasNSString:input];
    NSMutableArray *inputPolygons = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputPolygons addObject:[self parsePolygon:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTPolygonM alloc] initWithPolygons:inputPolygons];
}

+ (WKTGeometry *)parseGeometry:(NSString *)input
{
    NSString *typeGeometry;
    if (input == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Library"
            reason:@"Parameter input is nil"
            userInfo:nil];
    }
    else if ((typeGeometry = [self checkTypeWKT:input]) == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Library"
            reason:@"Parameter input is invalid (WKT Geometry not recognised)"
            userInfo:nil];
    }
    else
    {
        // Remove GeoSpatial Reference <http://>
        long inputLength = input.length;
        NSString *inputWGeo = [input stringByReplacingOccurrencesOfString:
            @"<[\\s\\S]*>\\s*" withString:@"" options:NSRegularExpressionSearch
            range:NSMakeRange(0, input.length)];
        
        // GeoSpatial Reference
        NSString *gisType = @"CRS84";
        if(inputWGeo.length != inputLength)
        {
            long inputWGeoLength = inputLength - inputWGeo.length;
            NSString *geoURI = [input substringToIndex:inputWGeoLength];
            geoURI = [geoURI substringToIndex:geoURI.length-1];
            geoURI = [geoURI stringByReplacingOccurrencesOfString:@"<http://www.opengis.net/def/crs/" withString:@""];
            NSArray *geoURIParameters = [geoURI componentsSeparatedByString:@"/"];
            if(![geoURIParameters[2] isEqualToString:@"CRS84"])
            {
                gisType = [NSString stringWithFormat:@"%@ %@", geoURIParameters[0], geoURIParameters[2]];
            }
            geoURIParameters = nil;
            geoURI = nil;
            input = inputWGeo;
        }
        inputWGeo = nil;
        
        // Remove Whitespaces
        input = [input stringByReplacingOccurrencesOfString:
            [NSString stringWithFormat:@"%@\\s*", typeGeometry] withString:@""
            options:NSRegularExpressionSearch range:NSMakeRange(0, input.length)];
        
        // Clean Parents of Input and throw Exceptions
        input = [self cleanParents:input withTypeGeometry:typeGeometry];
        
        // Result of parse
        WKTGeometry *result;
        
        if([typeGeometry isEqualToString:@"POINT"])
        {
            result = [self parsePoint:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"POINT Z"] ||
                [typeGeometry isEqualToString:@"POINTZ"])
        {
            result = [self parsePoint:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOINT"])
        {
            result = [self parseMultiPoint:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOINT Z"] ||
                [typeGeometry isEqualToString:@"MULTIPOINTZ"])
        {
            result = [self parseMultiPoint:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"LINESTRING"])
        {
            result = [self parseLine:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"LINESTRING Z"] ||
                [typeGeometry isEqualToString:@"LINESTRINGZ"])
        {
            result = [self parseLine:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"MULTILINESTRING"])
        {
            result = [self parseMultiLine:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"MULTILINESTRING Z"] ||
                [typeGeometry isEqualToString:@"MULTILINESTRINGZ"])
        {
            result = [self parseMultiLine:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"POLYGON"])
        {
            result = [self parsePolygon:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"POLYGON Z"] ||
                [typeGeometry isEqualToString:@"POLYGONZ"])
        {
            result = [self parsePolygon:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOLYGON"])
        {
            result = [self parseMultiPolygon:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOLYGON Z"] ||
                [typeGeometry isEqualToString:@"MULTIPOLYGONZ"])
        {
            result = [self parseMultiPolygon:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"GEOMETRYCOLLECTION"])
        {
            NSArray *collection = [WKTString splitCommasNSString:input];
            WKTGeometryCollection *resGeometry = [[WKTGeometryCollection alloc] init];
            for(int i = 0; i < collection.count; i++)
            {
                @try
                {
                    [resGeometry addGeometry:[self parseGeometry:collection[i]]];
                }
                @catch (NSException *exception)
                {
                    @throw exception;
                    break;
                }
            }
            result = resGeometry;
        }
        else
        {
            @throw [NSException exceptionWithName:@"WKTParser Library"
                reason:@"Parameter input is invalid (WKT Geometry not recognised)"
                userInfo:nil];
        }
        [result setGis:gisType];
        gisType = nil;
        return result;
    }
    return nil;
}

@end
