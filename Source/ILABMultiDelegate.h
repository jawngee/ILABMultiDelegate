//
//  ILABMutliDelegate.h
//  Based on Alejandro Isaza's AIMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//  Portions copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ILABMultiDelegateProtocol

/**
 *	ILABMultiDelegateProtocol protocol
 */
@protocol ILABMultiDelegateProtocol<NSObject>

/**
 *	Adds a delegate
 *
 *	@param delegate The delegate to add
 */
-(void)addDelegate:(id<NSObject>)delegate;

/**
 *	Inserts a delegate before another one.  If delegate already is in the list, it is moved to the new position.
 *
 *	@param delegate      The delegate to insert
 *	@param otherDelegate The delegate to insert before
 */
-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate;

/**
 *	Inserts a delegate after another one.  If delegate already is in the list, it is moved to the new position.
 *
 *	@param delegate      The delegate to insert
 *	@param otherDelegate The delegate to insert after
 */
-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate;

/**
 *	Inserts a delegate at the given index.  If delegate already is in the list, it is moved to the new position.
 *
 *	@param delegate The delegate to insert
 *	@param index    The index to insert at
 */
-(void)insertDelegate:(id<NSObject>)delegate atIndex:(NSInteger)index;

/**
 *	Removes a specific delegate
 *
 *	@param delegate The delegate to remove
 */
-(void)removeDelegate:(id)delegate;

/**
 *	Removes all delegates
 */
-(void)removeAllDelegates;

@end

#pragma mark - SVMultiDelegate

/**
 *	Does delegate multiplexing, dispatching messages to multiple delegates that it tracks.
 */
@interface ILABMultiDelegate : NSObject<ILABMultiDelegateProtocol>

@property (readonly, nonatomic) NSPointerArray* delegates;  /**< The list of delegates */
@property (readonly, nonatomic) Protocol *protocol;         /**< The `Protocol` that the delegates must conform to, optional */

/**
 *	Creates a new instance with the `Protocol` that the delegates must conform to.  If you later add a
 *  delegate that does not conform to the protocol, an exception will be raised.
 *
 *	@param protocol The `Protocol` to conform to
 *
 *	@return The new instance
 */
-(id)initWithProtocol:(Protocol *)protocol;

/**
 *	Creates a new instance with a list of delegates
 *
 *	@param delegates The list of delegates
 *
 *	@return The new instance
 */
- (id)initWithDelegates:(NSArray*)delegates;

/**
 *	Creates a new instance with a list of delegates and the `Protocol` they must conform to.  If you later add a
 *  delegate that does not conform to the protocol, an exception will be raised.
 *
 *	@param delegates The list of delegates
 *	@param protocol  The `Protocol` the delegates must conform to
 *
 *	@return The new instance
 */
- (id)initWithDelegates:(NSArray*)delegates protocol:(Protocol *)protocol;

-(void)addDelegate:(id<NSObject>)delegate;
-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate;
-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate;
-(void)insertDelegate:(id<NSObject>)delegate atIndex:(NSInteger)index;

-(void)removeDelegate:(id)delegate;
-(void)removeAllDelegates;


@end
