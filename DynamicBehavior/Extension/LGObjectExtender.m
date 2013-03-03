#import <objc/runtime.h>
#import "LGObjectExtender.h"
#import "LGSelectorExtensible.h"
#import "ObjectWrapper.h"
#import "LGDecorator.h"
#import "LGExtensible.h"
#import "LGBlockExtensible.h"


@implementation LGObjectExtender {

}
+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;

    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;

    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });

    // returns the same object each time
    return _sharedObject;
}

- (id)extendTarget:(id)target withObject:(id)obj forSelector:(SEL)sel {
    if (![obj respondsToSelector:sel]) {
        [NSException raise:@"Illegal arguments" format:@"The extension object %@ does not respond to selector %@", obj, NSStringFromSelector(sel)];
    }
    if ([target conformsToProtocol:@protocol(LGSelectorExtensible)]) {
        [(id <LGSelectorExtensible>) target extendWithObject:obj forSelector:sel];
        return target;
    }
    else if ([target conformsToProtocol:@protocol(LGExtensible)]) {
        [(id <LGExtensible>) target extendWithObject:obj];
        return target;
    }
    else{
        return [LGDecorator decorateInstance:target with:obj];
    }
}

- (id)extendTarget:(id)target withBlock:(extension_block_t)block forSelector:(SEL)sel {
    if (![target conformsToProtocol:@protocol(LGBlockExtensible)]) {
        [NSException raise:@"Illegal arguments" format:@"The target object %@ cannot be extended with a block", target];
    }
    [(id <LGBlockExtensible>) target extendWithBlock:block forSelector:sel];
    return target;
}

- (id)extendTarget:(id)target withClass:(Class)cls forProtocol:(Protocol *)protocol {
    if (![cls conformsToProtocol:@protocol(ObjectWrapper)] || ![cls conformsToProtocol:protocol]) {
        @throw [[NSException alloc] initWithName:@"Invalid arguments" reason:@"Required protocols not implemented" userInfo:nil];
    }
    id extension = [[cls alloc] initWithTarget:target];
    unsigned int count;
    struct objc_method_description *descriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
    for (NSUInteger i = 0; i < count; i++) {
        [self extendTarget:target withObject:extension forSelector:descriptions[i].name];
    }
    return target;
}

- (void)extendTarget:(id)target WithClass:(Class)cls forSelectorsWithPrefix:(NSString *)prefix {
    id extension = [[cls alloc] initWithTarget:target];
    Class currentClass = cls;
    // Iterate over the class and all superclasses
    while (currentClass) {
        // Iterate over all instance methods for this class
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i = 0;
        for (; i < methodCount; i++) {
            SEL sel = method_getName(methodList[i]);
            //NSLog(@"%@ - %@", [NSString stringWithCString:class_getName(currentClass) encoding:NSUTF8StringEncoding],
            //        [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding]);
            if ([NSStringFromSelector(sel) hasPrefix:prefix])
                [self extendTarget:target withObject:extension forSelector:sel];
        }

        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
}


@end