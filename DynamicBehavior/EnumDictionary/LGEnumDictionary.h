#import <Foundation/Foundation.h>

@class WSEnum;

@protocol LGEnumDictionary <NSObject>
- (id)objectForEnum:(WSEnum *)key;
- (void)setObject:(id)value forEnum:(WSEnum *)key;
- (void)clearObjects;
@end


@interface LGEnumDictionary : NSObject <LGEnumDictionary>

@property(nonatomic, retain) Class enumClass;

+ (LGEnumDictionary *)dictionaryWithEnumClass:(Class)enumClass;

- (id)initWithEnumClass:(Class)enumClass;
- (id)objectForEnum:(WSEnum *)key;
- (void)setObject:(id)value forEnum:(WSEnum *)key;
- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)clearObjects;

@end