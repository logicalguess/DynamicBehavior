#import <Foundation/Foundation.h>
#import "LGRole.h"


@interface LGClassRole : NSObject <LGRole>
+ (instancetype)roleWithProtocol:(Protocol *)protocol implClass:(Class)implClass;
- (instancetype)initWithProtocol:(Protocol *)protocol implClass:(Class)implClass;
@end