//
//  ILABTestDelegate.m
//  ILABMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//

#import "ILABTestDelegate.h"

@implementation ILABTestDelegate

-(instancetype)init
{
    if ((self=[super init]))
    {
        _didSomethingCount=0;
    }
    
    return self;
}

-(void)didSomething
{
    _didSomethingCount++;
}

-(NSInteger)returnResult
{
    return _didSomethingCount*2;
}

@end
