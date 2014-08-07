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

- (id)init
{
    if (self == nil)
    {
        self = [super init];
        self.type = @"MultiLine";
        self.dimensions = 0;
        listLines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithLines:(NSArray *)lines
{
    if (self == nil)
    {
        self = [self init];
    }
    [self removeListLines];
    [self setListLines:lines];
    return self;
}

- (void)setListLines:(NSArray *)lines
{
    if(lines == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Multi Line"
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
                @throw [NSException exceptionWithName:@"WKTParser Multi Line"
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
                    @throw [NSException exceptionWithName:@"WKTParser Multi Line"
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

- (void)copyTo:(WKTLineM *)otherLineM
{
    if(otherLineM == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Multi Line [copyTo]"
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

@end