#import "LGDecorator.h"


@implementation LGDecorator {
    id _target;
    id _decorator;

}
+ (id)decorateInstance:(id)target withClass:(Class)decoratorClass {
    return [self decorateInstance:target with:[decoratorClass new]];
}

+ (id)decorateInstance:(id)target with:(id)decorator {
    LGDecorator *wrapper = [LGDecorator new];
    wrapper->_target = target;
    wrapper->_decorator = decorator;
    return wrapper;
}

- (BOOL)respondsToSelector:(SEL)sel {
    return [_target respondsToSelector:sel];
}

- (BOOL)isKindOfClass:(Class)cls {
    return [_target isKindOfClass:cls];
}

- (BOOL)conformsToProtocol:(Protocol *)protocol {
    return [_target conformsToProtocol:protocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];

    if ([_target respondsToSelector:aSelector]) {

        NSString *beforeSelAsString = [NSString stringWithFormat:@"before_%@", NSStringFromSelector(aSelector)];
        SEL beforeSel = NSSelectorFromString(beforeSelAsString);
        if ([_decorator respondsToSelector:beforeSel])
            [_decorator performSelector:beforeSel withObject:invocation];

        [invocation invokeWithTarget:_target];

        NSString *afterSelAsString = [NSString stringWithFormat:@"after_%@", NSStringFromSelector(aSelector)];
        SEL afterSel = NSSelectorFromString(afterSelAsString);
        if ([_decorator respondsToSelector:afterSel])
            [_decorator performSelector:afterSel withObject:invocation];
    }
}


@end