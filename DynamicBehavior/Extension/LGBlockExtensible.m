#import "LGBlockExtensible.h"
#import <objc/runtime.h>


@implementation LGBlockExtensible


- (NSMutableDictionary*)lgBlocks
{
    static char blocksKey;
    @synchronized (self) {
        if (!objc_getAssociatedObject(self, &blocksKey)) {
            objc_setAssociatedObject(self, &blocksKey, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN);
        }
        return objc_getAssociatedObject(self, &blocksKey);
    }
}

- (void)extendWithBlock:(extension_block_t)block forSelector:(SEL)sel {
    [[self lgBlocks] setValue:block forKey:NSStringFromSelector(sel)];
}

- (BOOL)respondsToSelector:(SEL)sel {
    if ([[self class] instancesRespondToSelector:sel] || [[self lgBlocks] valueForKey:NSStringFromSelector(sel)])
        return YES;
    return NO;
}

-(id)singleParam:(id *)param {
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    if (signature)
        return signature;
    return [self methodSignatureForSelector:@selector(singleParam:)];
    //return GetMethodSignatureForBlock([[self lgBlocks] valueForKey:NSStringFromSelector(sel)]);  //for any block
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    extension_block_t block = [[self lgBlocks] valueForKey:NSStringFromSelector(sel)];
    if (!block)
        [NSException raise:@"Missing block" format:@"No block configured for selector %@", NSStringFromSelector(sel)];

    NSObject *param;
    [invocation getArgument:&param atIndex:2];

    __block NSObject *blockSafeSelf = self;
    id ret = block(blockSafeSelf, param);
    [invocation setReturnValue:&ret];

    //[invocation invokeUsingIMP:imp_implementationWithBlock(block)];  //for any block
}

@end