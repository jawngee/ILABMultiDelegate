ILABMultiDelegate
=============

This is based very heavily on Alejandro Isaza's [MultiDelegate](https://github.com/aleph7/MultiDelegate).

MultiDelegate is a delegate multiplexing class for Objective-C. In other words, it will dispatch delegate methods to multiple objects, instead of being restricted to a single delegate object. You can also use it as a generic method dispatch mechanism. For more information see the [blog post](http://a-coding.com/delegate-multiplexing/).

## Using With Pre-existing Classes (UIScrollView, UITableView, etc.)

Suppose you have a `UITableView` and you want to implement the data source using two separate classes: one is the actual data source implementing the `tableView:numberOfRowsInSection:` method and the other one is the cell factory implementing the `tableView:cellForRowAtIndexPath:` method to construct the cells. 

First create an `ILABMultiDelegate` instance. You need to keep a strong reference to this instance because most objects don't retain their delegates:
```objc
_multiDelegate = [[ILABMultiDelegate alloc] initWithProtocol:@protocol(UITableViewDataSource)];
```

Then add all the actual delegates to the `_multiDelegate` object:
```
[_multiDelegate addDelegate:self];
[_multiDelegate addDelegate:_dataSource];
```

Finally set the table's data source as the delegate multiplexer:
```
self.tableView.dataSource = (id)_multiDelegate;
```

## Using With Your Own Classes

If you are writing a class and you want to have multi-delegate support, it's pretty easy to add.  Here is the header for a class that will have multi-delegate support:

```objc
#import "ILABMultiDelegate.h"

@protocol ILABYourClassDelegate;

@interface ILABYourClass : NSObject

@property (readonly) id<ILABMultiDelegateProtocol, ILABYourClassDelegate> delegate;

-(void)doSomething;

@end

@protocol ILABDelegateObjectDelegate<NSObject>

-(void)didSomething;

@end
```

You notice that our `delegate` property is `readonly`.  That's because your delegate will actually be an instance of `ILABMultiDelegate`.  Because it's marked with `ILABMultiDelegateProtocol` you can use the `addDelegate:` and `insertDelegate:` methods to actually add your delegates.

Your implementation would then look like this:

```objc
@implementation ILABYourClass

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

```

Here we are creating the instance of `ILABMultiDelegate` and assigning it to our _delegate ivar by casting it to `id`.  Notice how we are passing the protocol of our delegate to the constructor?  We do this to insure that any future delegates added conform to the protocol.  If you try to add a delegate that doesn't conform, it will throw an exception.  If you don't want this behavior, you can simply do:

```objc
_delegate=(id)[[ILABMultiDelegate alloc] init];
```

From this point forward you can treat it just as you would `id<ILABYourClassDelegate>`.

To add a delegate, your client class would:

```objc
ILABYourClass *myClass=[ILABYourClass new];
[myClass.delegate addDelegate:self];

```


## Things of Note

* Every method invocation will be forwarded to each object in the list in the order they were added.
* If a method returns a value the return value will be from the last object that responded to the method. For example if object `A` implements method `getInt` by returning `1`, object `B` implements `getInt` by returning `2` and object `C` doesn't implement `getInt`, calling `getInt` on an `ILABMultiDelegate` containing `A`, `B` and `C` (in that order) will return `2`.
* `ILABMultiDelegate` doesn't keep strong references to the objects added to it.
* Some objects only call `respondsToSelector:` when you first set the delegate to improve performance, so make sure you add all your delegates to the `ILABMultiDelegate` before you set it as the delegate.

## Installation

If you are using [CocoaPods](https://github.com/cocoapods/cocoapods), add this to your `Podfile`:
```ruby
pod 'ILABMultiDelegate'
```
Otherwise add `ILABMultiDelegate.h/.m` to your project.

## Special Thanks

Of course, special thanks to Alejandro Isaza for writing [MultiDelegate](https://github.com/aleph7/MultiDelegate) on which this is 80% lifted from.
