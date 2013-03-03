@protocol LGSelectorExtensible <NSObject>
- (void)extendWithObject:(id)obj forSelector:(SEL)sel;
@end

@interface LGSelectorExtensible : NSObject <LGSelectorExtensible>
@end