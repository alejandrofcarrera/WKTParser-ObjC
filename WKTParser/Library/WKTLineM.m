//
//  WKTLineM.m
//
//  WKTParser Multi Line
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

#include "WKTLineM.h"

@implementation WKTLineM

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = @"MultiLine";
        self.gis = @"CRS84";
        listLines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithLines:(NSArray *)lines
{
    if (self = [self init])
    {
        [self setListLines:lines];
    }
    return self;
}

- (void)setListLines:(NSArray *)lines
{
    if(lines == nil)
    {
        @throw [NSException exceptionWithName:@"WKTLineM [setListLines]"
            reason:@"Parameter points is nil"
            userInfo:nil];
    }
    else
    {
        int dimBackup = 0;
        for(int i = 0; i < lines.count; i++)
        {
            if(![lines[i] isKindOfClass:[WKTLine class]])
            {
                @throw [NSException exceptionWithName:@"WKTLineM [setListLines]"
                    reason:@"Parameter lines have a class that is not WKTLine"
                    userInfo:nil];
            }
            else
            {
                if(i == 0)
                {
                    dimBackup = [(WKTLine *) lines[0] dimensions];
                    [listLines addObject:lines[0]];
                }
                else if(dimBackup != [(WKTLine *) lines[i] dimensions])
                {
                    @throw [NSException exceptionWithName:@"WKTLineM [setListLines]"
                        reason:@"Parameter lines have WKTLine with different dimensions"
                        userInfo:nil];
                }
                else
                {
                    [listLines addObject:lines[i]];
                }
            }
        }
        self.dimensions = dimBackup;
    }
}

- (NSArray *)getListLines
{
    return listLines;
}

- (void)removeListLines
{
    [listLines removeAllObjects];
    self.dimensions = 0;
}

- (BOOL)isEqual:(WKTLineM *)otherLineM
{
    if(otherLineM == nil || ![otherLineM isKindOfClass:[WKTLineM class]])
    {
        return NO;
    }
    else if(self.dimensions != otherLineM.dimensions)
    {
        return NO;
    }
    else if(listLines.count != [otherLineM getListLines].count)
    {
        return NO;
    }
    else
    {
        NSArray *listOtherLines = [otherLineM getListLines];
        for(int i = 0; i < listLines.count; i++)
        {
            if(![(WKTLine *) listLines[i] isEqual:listOtherLines[i]])
            {
                return NO;
            }
        }
        return YES;
    }
}

- (void)copyTo:(WKTLineM *)otherLineM
{
    if(otherLineM == nil)
    {
        @throw [NSException exceptionWithName:@"WKTLineM [copyTo]"
            reason:@"Parameter Multi Line is nil"
            userInfo:nil];
    }
    else
    {
        otherLineM.type = self.type;
        otherLineM.dimensions = self.dimensions;
        [otherLineM removeListLines];
        [otherLineM setListLines: listLines];
    }
}

- (NSString *)description
{
    NSString *description = @"";
    for(int i = 0; i < listLines.count; i++)
    {
        NSString *lString = [NSString stringWithFormat:@"(%@)", listLines[i]];
        description = [description stringByAppendingString:lString];
        if(i < listLines.count - 1)
        {
            description = [description stringByAppendingString:@", "];
        }
        lString = nil;
    }
    return description;
}

- (NSString *)toWKT
{
    if(listLines.count == 0)
    {
        return @"MULTILINESTRING EMPTY";
    }
    if(self.dimensions == 2)
    {
        return [NSString stringWithFormat:@"MULTILINESTRING (%@)", self];
    }
    else
    {
        return [NSString stringWithFormat:@"MULTILINESTRINGZ (%@)", self];
    }
}

- (NSArray *)toMapMultiLine
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < listLines.count; i++)
    {
        [result addObject:[(WKTLine *) listLines[i] toMapLine]];
    }
    return result;
}

@end