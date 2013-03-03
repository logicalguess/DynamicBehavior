#import <Foundation/Foundation.h>
#import "LGRole.h"


@interface LGBlockRole : NSObject <LGRole>
- (instancetype)initWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector;

+ (instancetype)roleWithProtocol:(Protocol *)protocol blocks:(NSDictionary *)blocksBySelector;


@end