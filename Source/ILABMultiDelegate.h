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
 ILABMultiDelegateProtocol protocol
 */
@protocol ILABMultiDelegateProtocol<NSObject>

/**
 Adds a delegate
 
 @param delegate The delegate to add
 */
-(void)addDelegate:(id<NSObject>)delegate;

/**
 Inserts a delegate before another one.  If delegate already is in the list, it is moved to the new position.
 
 @param delegate      The delegate to insert
 @param otherDelegate The delegate to insert before
 */
-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate;

/**
 Inserts a delegate after another one.  If delegate already is in the list, it is moved to the new position.
 
 @param delegate      The delegate to insert
 @param otherDelegate The delegate to insert after
 */
-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate;


/**
 Removes a specific delegate
 
 @param delegate The delegate to remove
 */
-(void)removeDelegate:(id)delegate;

/**
 Removes all delegates
 */
-(void)removeAllDelegates;

@end

#pragma mark - SVMultiDelegate

/**
 Does delegate multiplexing, dispatching messages to multiple delegates that it tracks.
 */
@interface ILABMultiDelegate : NSObject<ILABMultiDelegateProtocol>

@property (readonly, nonatomic) NSArray<Protocol *> *protocols;         ///< The `Protocol` that the delegates must conform to, optional 

/**
 Creates a new instance with the `Protocol` that the delegates must conform to.  If you later add a
 delegate that does not conform to the protocol, an exception will be raised.
 
 @param protocol The `Protocol` to conform to
 @return The new instance
 */
-(instancetype)initWithProtocol:(Protocol *)protocol;


/**
 Creates a new instance with the `Protocol` that the delegates must conform to.  If you later add a
 delegate that does not conform to the protocol, an exception will be raised.
 
 @param protocol The `Protocol` to conform to
 @return The new instance
 */
+(id)delegateWithProtocol:(Protocol *)protocol;


/**
 Creates a new instance with the `Protocol` that the delegates must conform to.  If you later add a
 delegate that does not conform to the protocol, an exception will be raised.
 
 @param protocols The `Protocol` to conform to
 @return The new instance
 */
-(instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols;


/**
 Creates a new instance with the `Protocol` that the delegates must conform to.  If you later add a
 delegate that does not conform to the protocol, an exception will be raised.
 
 @param protocols The `Protocol` to conform to
 @param strict For multiple protocols, insure that the added delegates conform to them.  Default is YES.
 @return The new instance
 */
-(instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols strict:(BOOL)strict;


/**
 Convenience class method for intializing a new delegate for a given list of protocols.
 
 @param protocols The `Protocol` to conform to
 @param strict For multiple protocols, insure that the added delegates conform to them.  Default is YES.
 @return The new instance
 */
+(id)delegateWithProtocols:(NSArray<Protocol *> *)protocols strict:(BOOL)strict;


/**
 Add a delegate
 
 @param delegate The delegate to add
 */
-(void)addDelegate:(id<NSObject>)delegate;


/**
 Insert a delegate before another delegate in the list
 
 @param delegate The delegate to insert
 @param otherDelegate The delegate to insert before
 */
-(void)insertDelegate:(id<NSObject>)delegate beforeDelegate:(id)otherDelegate;


/**
 Insert a delegate after another delegate in the list
 
 @param delegate The delegate to insert
 @param otherDelegate The other deletage to insert after
 */
-(void)insertDelegate:(id<NSObject>)delegate afterDelegate:(id)otherDelegate;


/**
 Removes a delegate
 
 @param delegate The delegate to remove
 */
-(void)removeDelegate:(id)delegate;


/**
 Removes all delegates.
 */
-(void)removeAllDelegates;


@end
