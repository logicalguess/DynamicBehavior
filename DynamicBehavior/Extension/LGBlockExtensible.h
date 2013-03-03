#import <Foundation/Foundation.h>
#import "LGBlockExtensible.h"

typedef id (^extension_block_t)(id target, id param);

@protocol LGBlockExtensible <NSObject>
- (void)extendWithBlock:(extension_block_t)block forSelector:(SEL)sel;
@end

@interface LGBlockExtensible : NSObject <LGBlockExtensible>
@end