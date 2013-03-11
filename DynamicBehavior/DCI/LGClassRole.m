#import "LGClassRole.h"
#import "LGObjectExtender.h"

@interface LGClassRole ()
@property(readonly) Protocol * protocol;
@property(readonly) Class implClass;
@end

@implementation LGClassRole

+ (instancetype)roleWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    return [[LGClassRole alloc] initWithProtocol:protocol implClass:implClass];
}

- (instancetype)initWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    self = [super init];
    if (self) {
        _protocol = protocol;
        _implClass = implClass;
    }

    return self;
}

- (id)enableOnObject:(id)obj {
    return [[LGObjectExtender sharedInstance] extendTarget:obj withClass:[self implClass] forProtocol:[self protocol]];
}

@end