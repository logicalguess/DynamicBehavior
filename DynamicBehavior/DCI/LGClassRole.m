#import "LGClassRole.h"
#import "LGObjectExtender.h"

@interface LGClassRole ()
@property Protocol * protocol;
@property Class implClass;
@end

@implementation LGClassRole

- (instancetype)initWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    self = [super init];
    if (self) {
        [self setProtocol:protocol];
        [self setImplClass:implClass];
    }

    return self;
}

+ (instancetype)roleWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    return [[LGClassRole alloc] initWithProtocol:protocol implClass:implClass];
}

- (Protocol *)protocol {
    return _protocol;
}

- (id)enableOnObject:(id)obj {
    return [[LGObjectExtender sharedInstance] extendTarget:obj withClass:[self implClass] forProtocol:[self protocol]];
}

@end