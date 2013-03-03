#import <Foundation/Foundation.h>
#import "LGRole.h"


@interface LGClassRole : NSObject <LGRole>
- (instancetype)initWithProtocol:(Protocol *)protocol implClass:(Class)implClass;
+ (instancetype)roleWithProtocol:(Protocol *)protocol implClass:(Class)implClass;
@end