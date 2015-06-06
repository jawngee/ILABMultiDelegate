//
//  ILABTestDelegate.h
//  ILABMultiDelegate
//
//  Created by Jon Gilkison on 6/6/15.
//  Copyright (c) 2015 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILABDelegatingObject.h"

@interface ILABTestDelegate : NSObject<ILABDelegateObjectDelegate>

@property (readonly) NSInteger didSomethingCount;

@end
