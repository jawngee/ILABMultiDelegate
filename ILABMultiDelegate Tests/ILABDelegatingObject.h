//
//  ILABDelegatingObject.h
//  ILABMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILABMultiDelegate.h"

@protocol ILABDelegateObjectDelegate;

@interface ILABDelegatingObject : NSObject

@property (readonly) id<ILABMultiDelegateProtocol, ILABDelegateObjectDelegate> delegate;

-(void)doSomething;
-(NSInteger)needResult;
-(void)doSomethingOptional;
-(NSInteger)needResultOptional;

@end

@protocol ILABDelegateObjectDelegate<NSObject>

-(void)didSomething;
-(NSInteger)returnResult;

@optional

-(void)didSomethingOptional;
-(NSInteger)returnResultOptional;

@end
