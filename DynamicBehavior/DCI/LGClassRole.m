#import "LGClassRole.h"
#import "LGObjectExtender.h"


@implementation LGClassRole {
    Protocol * _protocol;
    Class _implClass;
}

- (instancetype)initWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    self = [super init];
    if (self) {
        _protocol = protocol;
        _implClass = implClass;
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
    return [[LGObjectExtender sharedInstance] extendTarget:obj withClass:_implClass forProtocol:_protocol];
}

@end