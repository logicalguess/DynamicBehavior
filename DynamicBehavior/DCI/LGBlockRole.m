#import <objc/runtime.h>
#import "LGBlockRole.h"
#import "LGObjectExtender.h"


@implementation LGBlockRole {
    Protocol *_protocol;
    NSMutableDictionary *_blocksBySelector;
}

- (instancetype)initWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector {
    self = [super init];
    if (self) {
        _protocol = protocol;
        _blocksBySelector = [NSMutableDictionary dictionary];
        unsigned int count;
        struct objc_method_description *descriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
        for (NSUInteger i = 0; i < count; i++) {
            NSString *sel = NSStringFromSelector(descriptions[i].name);
            id block = [blocksBySelector valueForKey:sel];
            if (block) {
                [_blocksBySelector setValue:block forKey:sel];
            }
        }
        if ([_blocksBySelector count] != [blocksBySelector count]) {
            NSLog(@"Some selectors are not on protocol");
        }
        if ([_blocksBySelector count] != count) {
            NSLog(@"Some selectors on protocol not implemented");
        }
    }

    return self;
}

+ (instancetype)roleWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector {
    return [[LGBlockRole alloc] initWithProtocol:protocol blocks:blocksBySelector];
}

- (Protocol *)protocol {
    return _protocol;
}

- (id)enableOnObject:(id)obj {
    for (NSString *sel in _blocksBySelector) {
        [[LGObjectExtender sharedInstance] extendTarget:obj withBlock:[_blocksBySelector objectForKey:sel] forSelector:NSSelectorFromString(sel)];
    }
    return obj;
}

@end