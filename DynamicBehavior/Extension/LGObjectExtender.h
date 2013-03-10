#import <Foundation/Foundation.h>
#import "LGBlockExtensible.h"


@interface LGObjectExtender : NSObject
+ (id)sharedInstance;

- (id)extendTarget:(id)target withObject:(id)obj forSelector:(SEL)sel;
- (id)extendTarget:(id)target withBlock:(extension_block_t)block forSelector:(SEL)sel;
- (id)extendTarget:(id)target withClass:(Class)cls forProtocol:(Protocol *)protocol;
- (id)extendTarget:(id)target WithClass:(Class)cls forSelectorsWithPrefix:(NSString *)prefix;


@end