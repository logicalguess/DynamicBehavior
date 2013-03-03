#import <objc/runtime.h>
#import "LGSelectorExtensible.h"


@implementation LGSelectorExtensible


- (NSMutableDictionary *)lgExtensions {
    static char extensionsKey;
    @synchronized (self) {
        if (!objc_getAssociatedObject(self, &extensionsKey)) {
            objc_setAssociatedObject(self, &extensionsKey, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN);
        }
        return objc_getAssociatedObject(self, &extensionsKey);
    }
}

- (void)extendWithObject:(id)obj forSelector:(SEL)sel {
    [[self lgExtensions] setValue:obj forKey:NSStringFromSelector(sel)];
}

- (BOOL)respondsToSelector:(SEL)sel {
    if ([[self class] instancesRespondToSelector:sel] || [[self lgExtensions] valueForKey:NSStringFromSelector(sel)])
        return YES;
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)sel {
    id target = nil;
    id extension = [[self lgExtensions] valueForKey:NSStringFromSelector(sel)];
    if (extension)
        target = extension;
    return target;
}

@end