#import "LGClassRole.h"
#import "LGObjectExtender.h"

@interface LGClassRole ()
@property(readonly) Protocol * protocol;
@property(readonly) Class implClass;
@end

@implementation LGClassRole

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

- (id)enableOnObject:(id)obj {
    return [[LGObjectExtender sharedInstance] extendTarget:obj withClass:[self implClass] forProtocol:[self protocol]];
}

@end