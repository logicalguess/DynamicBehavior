#import <objc/runtime.h>
#import "LGBlockRole.h"
#import "LGObjectExtender.h"

@interface LGBlockRole ()
@property Protocol *protocol;
@property NSMutableDictionary *blocksBySelector;
@end

@implementation LGBlockRole

- (instancetype)initWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector {
    self = [super init];
    if (self) {
        [self setProtocol:protocol];
        [self setBlocksBySelector:[NSMutableDictionary dictionary]];
        unsigned int count;
        struct objc_method_description *descriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
        for (NSUInteger i = 0; i < count; i++) {
            NSString *sel = NSStringFromSelector(descriptions[i].name);
            id block = [blocksBySelector valueForKey:sel];
            if (block) {
                [[self blocksBySelector] setValue:block forKey:sel];
            }
        }
        if ([[self blocksBySelector] count] != [blocksBySelector count]) {
            NSLog(@"Some selectors are not on protocol");
        }
        if ([[self blocksBySelector] count] != count) {
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