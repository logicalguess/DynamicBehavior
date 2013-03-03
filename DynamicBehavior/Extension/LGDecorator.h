#import <Foundation/Foundation.h>


@interface LGDecorator : NSObject
+(id)decorateInstance:(id)target withClass:(Class)decoratorClass;
+(id)decorateInstance:(id)target with:(id)decorator;
@end