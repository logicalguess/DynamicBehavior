#import <objc/runtime.h>
#import "Something.h"



@implementation Something {

}

- (void)changeLocalStatic {
    static int count = 0;
    count++;
    NSLog(@"Count in %@: %i", self, count);
}

- (void)dispatchOnce {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSLog(@"Dispatching once  in %@", self);
    });
}

- (id) associated {
    //static char storageKey;
    static void * const storageKey = (void*)&storageKey;
    if (!objc_getAssociatedObject(self, &storageKey)) {
        objc_setAssociatedObject(self, &storageKey, [self description], OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &storageKey);
}

@end