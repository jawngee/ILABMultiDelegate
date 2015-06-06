//
//  ILABMutliDelegate.m
//  Based on Alejandro Isaza's AIMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//  Portions copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "ILABMultiDelegate.h"
#import <objc/runtime.h>

@interface ILABMultiDelegate()
@end

@implementation ILABMultiDelegate

#pragma mark - Init/Dealloc

-(instancetype)init
{
    return [self initWithDelegates:nil];
}

-(instancetype)initWithProtocol:(Protocol *)protocol
{
    if ((self=[self initWithDelegates:nil]))
    {
        _protocol=protocol;
        if (_protocol)
            class_addProtocol([self class], protocol);
    }
    
    return self;
}

-(instancetype)initWithDelegates:(NSArray *)delegates
{
    if ((self=[super init]))
    {
        
        _delegates = [NSPointerArray weakObjectsPointerArray];
        
        for (id delegate in delegates)
            [_delegates addPointer:(__bridge void*)delegate];
    }
    
    return self;
}

-(instancetype)initWithDelegates:(NSArray *)delegates protocol:(Protocol *)protocol
{
    for(id<NSObject> delegate in delegates)
    {
        if (![delegate conformsToProtocol:protocol])
            [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocol",NSStringFromProtocol(protocol)];
    }
    
    if ((self=[self initWithDelegates:delegates]))
    {
        _protocol=protocol;
    }
    
    return self;
}

#pragma mark - SVMultiDelegateProtocol

-(void)addDelegate:(id<NSObject>)delegate
{
    if ([self indexOfDelegate:delegate]!=NSNotFound)
        return;
    
    if (_protocol && ![delegate conformsToProtocol:_protocol])
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocol.",NSStringFromProtocol(_protocol)];
    
    [_delegates addPointer:(__bridge void*)delegate];
}

-(NSUInteger)indexOfDelegate:(id)delegate
{
    for (NSUInteger i=0; i<_delegates.count; i++)
    {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate)
            return i;
    }
    
    return NSNotFound;
}

-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate
{
    if (_protocol && ![delegate conformsToProtocol:_protocol])
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocol.",NSStringFromProtocol(_protocol)];
    
    NSUInteger oldIndex=[self indexOfDelegate:delegate];
    if (oldIndex!=NSNotFound)
        [_delegates removePointerAtIndex:oldIndex];
    
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound)
        index = _delegates.count;
    
    [_delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate
{
    if (_protocol && ![delegate conformsToProtocol:_protocol])
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocol.",NSStringFromProtocol(_protocol)];
    
    NSUInteger oldIndex=[self indexOfDelegate:delegate];
    if (oldIndex!=NSNotFound)
        [_delegates removePointerAtIndex:oldIndex];
    
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound)
        index = 0;
    else
        index += 1;
    
    [_delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

-(void)insertDelegate:(id<NSObject>)delegate atIndex:(NSInteger)index
{
    if (_protocol && ![delegate conformsToProtocol:_protocol])
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocol.",NSStringFromProtocol(_protocol)];
    
    NSUInteger oldIndex=[self indexOfDelegate:delegate];
    if (oldIndex!=NSNotFound)
    {
        if (oldIndex==index)
            return;
        
        [_delegates removePointerAtIndex:oldIndex];
        
        if (oldIndex<index)
            index--;
    }
    
    [_delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

-(void)removeDelegate:(id)delegate
{
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound)
        [_delegates removePointerAtIndex:index];
    
    [_delegates compact];
}

-(void)removeAllDelegates
{
    for (NSUInteger i = _delegates.count; i > 0; i -= 1)
        [_delegates removePointerAtIndex:i - 1];
}

-(BOOL)respondsToSelector:(SEL)selector
{
    if ([super respondsToSelector:selector])
        return YES;
    
    for (id delegate in _delegates)
    {
        if (delegate && [delegate respondsToSelector:selector])
            return YES;
    }
    
    return NO;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;
    
    [_delegates compact];
    
    if (_delegates.count == 0)
        return [self methodSignatureForSelector:@selector(description)];
    
    for (id delegate in _delegates)
    {
        if (!delegate)
            continue;
        
        signature = [delegate methodSignatureForSelector:selector];
        if (signature)
            break;
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    BOOL responded = NO;
    
    for (id delegate in _delegates)
    {
        if (delegate && [delegate respondsToSelector:selector])
        {
            [invocation invokeWithTarget:delegate];
            responded = YES;
        }
    }
    
    if (!responded && _protocol)
    {
        struct objc_method_description methodDesc = protocol_getMethodDescription(_protocol, selector, YES, YES);
        if (methodDesc.name != NULL)
            [self doesNotRecognizeSelector:selector];
    }
}

@end
