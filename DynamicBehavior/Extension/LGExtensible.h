@protocol LGExtensible <NSObject>
- (void)extendWithObject:(id)obj;
@end

@interface LGExtensible : NSObject <LGExtensible>
@end