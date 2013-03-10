#import <objc/runtime.h>
#import "LGExtensible.h"


@implementation LGExtensible

static char extensionKey;

- (id)extension {
    return objc_getAssociatedObject(self, &extensionKey);
}

- (void)extendWithObject:(id)obj {
    objc_setAssociatedObject(self, &extensionKey, obj, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)respondsToSelector:(SEL)sel {
    if ([[self class] instancesRespondToSelector:sel])
        return YES;
    return [[self extension] respondsToSelector:sel];
}

-(id)forwardingTargetForSelector:(SEL)sel {
    id target = nil;
    id extension = [self extension];
    // check the extension first
    if ([extension respondsToSelector:sel])
        target = extension;
    return target;
}
@end