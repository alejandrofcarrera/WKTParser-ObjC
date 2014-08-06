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

+ (NSString *) checkTypeWKT:(NSString *)input
{
    NSArray *WKT_Types = @[@"POINT", @"MULTIPOINT", @"LINESTRING",
            @"MULTILINESTRING", @"POLYGON", @"MULTIPOLYGON"];
    NSString *result = nil;
    for(NSString *i in WKT_Types)
    {
        if([input rangeOfString:i].location != NSNotFound)
        {
            result = i;
            break;
        }
    }
    WKT_Types = nil;
    return result;
}

+ (WKTPoint *)parsePoint:(NSString *)input withDimensions:(int)dims
{
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
        result = [[WKTPoint alloc] initWithDimensionX:[inputSplitted[0] doubleValue]
            andDimensionY:[inputSplitted[1] doubleValue] andDimensionZ:
            [inputSplitted[2] doubleValue]];
    }
    else
    {
        result = [[WKTPoint alloc] initWithDimensionX:[inputSplitted[0] doubleValue]
            andDimensionY:[inputSplitted[1] doubleValue]];
    }
    inputSplitted = nil;
    return result;
}

+ (WKTPointM *)parseMultiPoint:(NSString *)input withDimensions:(int)dims
{
    NSArray *inputSplitted = [WKTString splitCommasNSString:input];
    NSMutableArray *inputPoints = [[NSMutableArray alloc]init];
    for(int i = 0; i < inputSplitted.count; i++)
    {
        [inputPoints addObject:[self parsePoint:inputSplitted[i] withDimensions:dims]];
    }
    inputSplitted = nil;
    return [[WKTPointM alloc] initWithPoints:inputPoints];
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
    
    else if ((typeGeometry = [self checkTypeWKT:input]) != nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Library"
            reason:@"Parameter input is invalid (WKT Geometry not recognised)"
            userInfo:nil];
    }
    else
    {
        // Remove GeoSpatial Reference <http://>
        input = [input stringByReplacingOccurrencesOfString:
            @"<[\\s\\S]*>\\s*" withString:@"" options:NSRegularExpressionSearch
            range:NSMakeRange(0, input.length)];
        
        // Remove Whitespaces
        input = [input stringByReplacingOccurrencesOfString:
            [NSString stringWithFormat:@"%@\\s*", typeGeometry] withString:@""
            options:NSRegularExpressionSearch range:NSMakeRange(0, input.length)];
        
        if([typeGeometry isEqualToString:@"POINT"])
        {
            return [self parsePoint:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"POINT Z"])
        {
            return [self parsePoint:input withDimensions:3];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOINT"])
        {
            return [self parseMultiPoint:input withDimensions:2];
        }
        else if([typeGeometry isEqualToString:@"MULTIPOINT Z"])
        {
            return [self parseMultiPoint:input withDimensions:3];
        }
    }
    return nil;
}

@end
