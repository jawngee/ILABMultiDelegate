//
//  ILABDelegatingObject.m
//  ILABMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//

#import "ILABDelegatingObject.h"

@interface ILABDelegatingObject()
{
    
}
@end

@implementation ILABDelegatingObject

-(instancetype)init
{
    if ((self=[super init]))
    {
        _delegate=(id)[[ILABMultiDelegate alloc] initWithProtocol:@protocol(ILABDelegateObjectDelegate)];
    }
    
    return self;
}


-(void)doSomething
{
    [_delegate didSomething];
}

-(NSInteger)needResult
{
    return [_delegate returnResult];
}

-(void)doSomethingOptional
{
    [_delegate didSomethingOptional];
}

-(NSInteger)needResultOptional
{
    if ([_delegate respondsToSelector:@selector(returnResultOptional)])
        return [_delegate returnResultOptional];
    
    return NSNotFound;
}


@end
