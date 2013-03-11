#import <Foundation/Foundation.h>
#import "LGRole.h"


@interface LGBlockRole : NSObject <LGRole>
+ (instancetype)roleWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector;
- (instancetype)initWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector;
@end