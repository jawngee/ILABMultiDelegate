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

@interface ILABMultiDelegate() {
    NSPointerArray* delegates;
    NSMutableArray<Protocol *> *protocols;
    NSString *protocolNames;
    BOOL strictMode;
}
@end

@implementation ILABMultiDelegate

@synthesize protocols = protocols;

#pragma mark - Init/Dealloc

-(instancetype)init {
    [NSException raise:@"ILABMultiDelegate can not be initialized without specifying one or more protocols." format:@"You cannot initialize ILABMultiDelegate by calling it's `init` method."];
    
    return nil;
}

-(instancetype)initWithProtocol:(Protocol *)protocol {
    return [self initWithProtocols:@[protocol] strict:YES];
}

-(instancetype)initWithProtocols:(NSArray<Protocol *> *)protocolsArray {
    return [self initWithProtocols:protocolsArray strict:YES];
}

+(id)delegateWithProtocol:(Protocol *)protocol {
    return (id)[[[self class] alloc] initWithProtocols:@[protocol] strict:YES];
}

+(id)delegateWithProtocols:(NSArray<Protocol *> *)protocols strict:(BOOL)strict {
    return (id)[[[self class] alloc] initWithProtocols:protocols strict:strict];
}

-(instancetype)initWithProtocols:(NSArray<Protocol *> *)protocolsArray strict:(BOOL)strict {
    if ((self = [super init])) {
        if (protocolsArray.count == 0) {
            [NSException raise:@"Missing protocols for ILABMultiDelegate." format:@"You must specify one or more protocols for the ILABMultiDelegate."];
        }
        
        strictMode = strict;
        
        protocols = [NSMutableArray new];
        
        NSMutableArray *protocolNameList = [NSMutableArray new];
        
        delegates = [NSPointerArray weakObjectsPointerArray];
        for(Protocol *protocol in protocolsArray) {
            class_addProtocol([self class], protocol);
            [protocols addObject:protocol];
            [protocolNameList addObject:NSStringFromProtocol(protocol)];
        }
        
        protocolNames = [protocolNameList componentsJoinedByString:@", "];
    }
    
    return self;
}

#pragma mark - SVMultiDelegateProtocol

-(BOOL)delegateConformsToProtocols:(id<NSObject>)delegate {
    if (!strictMode) {
        return YES;
    }
    
    for(Protocol *protocol in protocols) {
        if (![delegate conformsToProtocol:protocol]) {
            return NO;
        }
    }
    
    return YES;
}

-(void)addDelegate:(id<NSObject>)delegate {
    if ([self indexOfDelegate:delegate]!=NSNotFound)
        return;
    
    if (![self delegateConformsToProtocols:delegate]) {
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocols.", protocolNames];
    }
    
    [delegates addPointer:(__bridge void*)delegate];
}

-(NSUInteger)indexOfDelegate:(id)delegate {
    for (NSUInteger i=0; i<delegates.count; i++)
    {
        if ([delegates pointerAtIndex:i] == (__bridge void*)delegate)
            return i;
    }
    
    return NSNotFound;
}

-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate {
    if (![self delegateConformsToProtocols:delegate]) {
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocols.", protocolNames];
    }
    
    NSUInteger oldIndex=[self indexOfDelegate:delegate];
    if (oldIndex!=NSNotFound) {
        [delegates removePointerAtIndex:oldIndex];
    }
    
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound) {
        index = delegates.count;
    }
    
    [delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate {
    if (![self delegateConformsToProtocols:delegate]) {
        [NSException raise:@"Delegate does not conform to protocol." format:@"Delegate does not conform to %@ protocols.", protocolNames];
    }
    
    NSUInteger oldIndex=[self indexOfDelegate:delegate];
    if (oldIndex!=NSNotFound) {
        [delegates removePointerAtIndex:oldIndex];
    }
    
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound) {
        index = 0;
    } else {
        index += 1;
    }
    
    [delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

-(void)removeDelegate:(id)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound) {
        [delegates removePointerAtIndex:index];
    }
    
    [delegates compact];
}

-(void)removeAllDelegates {
    for (NSUInteger i = delegates.count; i > 0; i -= 1) {
        [delegates removePointerAtIndex:i - 1];
    }
}

-(BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector]) {
        return YES;
    }
    
    for (id delegate in delegates) {
        if (delegate && [delegate respondsToSelector:selector]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature) {
        return signature;
    }
    
    [delegates compact];
    
    if (delegates.count == 0) {
        return [self methodSignatureForSelector:@selector(description)];
    }
    
    for (id delegate in delegates) {
        if (!delegate) {
            continue;
        }
        
        signature = [delegate methodSignatureForSelector:selector];
        if (signature) {
            break;
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (delegates.count==0) {
        return;
    }
    
    SEL selector = [invocation selector];
    BOOL responded = NO;
    BOOL hasDelegates = NO;
    
    NSArray *delegatesCopy = [delegates copy];
    for (id delegate in delegatesCopy) {
        if (delegate) {
            hasDelegates = YES;
        }
        
        if (delegate && [delegate respondsToSelector:selector]) {
            [invocation invokeWithTarget:delegate];
            if ([invocation methodSignature].methodReturnLength > 0) {
                return;
            }
            
            responded = YES;
        }
    }
    
    if (hasDelegates && !responded && strictMode) {
        for(Protocol *protocol in protocols) {
            struct objc_method_description methodDesc = protocol_getMethodDescription(protocol, selector, YES, YES);
            if (methodDesc.name != NULL) {
                [self doesNotRecognizeSelector:selector];
            }
        }
    }
}

@end
