//
//  ILABMultiDelegate_Tests.m
//  ILABMultiDelegate Tests
//
//  Created by Jon Gilkison on 6/6/15.
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ILABDelegatingObject.h"
#import "ILABTestDelegate.h"
#import "ILABTestDelegateNoProtocol.h"

@interface ILABMultiDelegate_Tests : XCTestCase
{
    ILABDelegatingObject *delegatingObject;
}

@end

@implementation ILABMultiDelegate_Tests

- (void)setUp
{
    [super setUp];
    
    delegatingObject=[ILABDelegatingObject new];
}

- (void)tearDown
{
    delegatingObject=nil;

    [super tearDown];
}

-(void)testMultiDelegateConformsToProtocol
{
    ILABMultiDelegate *multiDelegate=(ILABMultiDelegate *)delegatingObject.delegate;
    XCTAssertTrue([multiDelegate conformsToProtocol:@protocol(ILABDelegateObjectDelegate)]);
}

- (void)testAddDelegate
{
    ILABMultiDelegate *multiDelegate=(ILABMultiDelegate *)delegatingObject.delegate;
    
    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate];

    XCTAssertEqual(multiDelegate.delegates.count, 1u);
    XCTAssertEqual((__bridge id)[multiDelegate.delegates pointerAtIndex:0], testDelegate);
    
    ILABTestDelegate *testDelegate1 = [ILABTestDelegate new];
    [delegatingObject.delegate insertDelegate:testDelegate1 beforeDelegate:testDelegate];
    XCTAssertEqual(multiDelegate.delegates.count, 2u);
    XCTAssertEqual((__bridge id)[multiDelegate.delegates pointerAtIndex:0], testDelegate1);
    
    ILABTestDelegate *testDelegate2 = [ILABTestDelegate new];
    [delegatingObject.delegate insertDelegate:testDelegate2 afterDelegate:testDelegate];
    XCTAssertEqual(multiDelegate.delegates.count, 3u);
    XCTAssertEqual((__bridge id)[multiDelegate.delegates pointerAtIndex:2], testDelegate2);
}

- (void)testAddBeforeAndAfterNil
{
    ILABMultiDelegate *multiDelegate=(ILABMultiDelegate *)delegatingObject.delegate;

    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate insertDelegate:testDelegate afterDelegate:nil];
    XCTAssertEqual(multiDelegate.delegates.count, 1u);
    XCTAssertEqual((__bridge id)[multiDelegate.delegates pointerAtIndex:0], testDelegate);
    
    [delegatingObject.delegate removeAllDelegates];
    
    [delegatingObject.delegate insertDelegate:testDelegate beforeDelegate:nil];
    XCTAssertEqual(multiDelegate.delegates.count, 1u);
    XCTAssertEqual((__bridge id)[multiDelegate.delegates pointerAtIndex:0], testDelegate);
}

- (void)testRemoveDelegate
{
    ILABMultiDelegate *multiDelegate=(ILABMultiDelegate *)delegatingObject.delegate;

    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate];
    XCTAssertEqual(multiDelegate.delegates.count, 1u);
    
    [multiDelegate removeDelegate:testDelegate];
    XCTAssertEqual(multiDelegate.delegates.count, 0u);
}

- (void)testRespondsToSelector
{
    ILABMultiDelegate *multiDelegate=(ILABMultiDelegate *)delegatingObject.delegate;

    XCTAssertFalse([delegatingObject.delegate respondsToSelector:@selector(didSomething)]);
    
    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate];
    
    XCTAssertTrue([multiDelegate respondsToSelector:@selector(didSomething)]);
    XCTAssertFalse([multiDelegate respondsToSelector:@selector(didSomethingOptional)]);
}

- (void)testForwardInvocation
{
    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate];
    
    XCTAssertEqual(0, testDelegate.didSomethingCount);
    [delegatingObject doSomething];
    XCTAssertEqual(1, testDelegate.didSomethingCount);
}

- (void)testReturnValue
{
    ILABTestDelegate *testDelegate = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate];

    [delegatingObject doSomething];
    XCTAssertEqual(2, [delegatingObject.delegate returnResult]);
}

- (void)testReturnValueOfMultipleDelegates
{
    ILABTestDelegate *testDelegate1 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate1];
    
    [delegatingObject doSomething];

    ILABTestDelegate *testDelegate2 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate2];
    
    [delegatingObject doSomething];
    
    XCTAssertEqual(2, [delegatingObject.delegate returnResult]);
}

-(void)testOptionalMethod
{
    ILABTestDelegate *testDelegate1 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate1];
    
    XCTAssertNoThrow([delegatingObject doSomethingOptional], @"Should not thrown an exception if a delegate does not implement an optional method");
}

-(void)testOptionalReturnMethod
{
    ILABTestDelegate *testDelegate1 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate1];
    
    XCTAssertNoThrow([delegatingObject needResultOptional], @"Should not thrown an exception if a delegate does not implement an optional method");
    XCTAssertEqual(NSNotFound, [delegatingObject needResultOptional]);
}

-(void)testProtocolConformance
{
    ILABTestDelegateNoProtocol *testDelegate1=[ILABTestDelegateNoProtocol new];
    XCTAssertThrows([delegatingObject.delegate addDelegate:testDelegate1],@"Should throw an exception if a delegate does not declare that it implements a protocol.");
}

- (void)testDeallocatedDelegate
{
    ILABTestDelegate *testDelegate1 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate1];

    ILABTestDelegate *testDelegate2 = [ILABTestDelegate new];
    [delegatingObject.delegate addDelegate:testDelegate2];
    
    // Force deallocation of one delegate
    testDelegate1 = nil;
    
    XCTAssertNoThrow([delegatingObject doSomething], @"Should not thrown an exception if a delegate was deallocated");
}

@end
