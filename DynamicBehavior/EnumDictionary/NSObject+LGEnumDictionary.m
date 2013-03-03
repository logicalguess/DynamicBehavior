#import <objc/runtime.h>
#import "NSObject+LGEnumDictionary.h"
#import "WSEnum.h"


@implementation NSObject (LGEnumDictionary)

static char enumClassKey;
static char arrayStoreKey;

- (NSMutableArray *)lgArray {
    @synchronized (self) {
        if (!objc_getAssociatedObject(self, &arrayStoreKey)) {
            Class enumClass = objc_getAssociatedObject(self, &enumClassKey);
            if (enumClass) {
                NSArray *enumValues = [enumClass enumValues];
                int count = [enumValues count];

                NSMutableArray *arrayStore = [NSMutableArray arrayWithCapacity:count];

                for (WSEnum *e in enumValues) {
                    [arrayStore addObject:[NSNull null]];
                }
                objc_setAssociatedObject(self, &arrayStoreKey, arrayStore, OBJC_ASSOCIATION_RETAIN);
            }
            else {
                @throw [[NSException alloc] initWithName:@"Invalid state" reason:@"Enum class not set" userInfo:nil];
            }
        };
        return objc_getAssociatedObject(self, &arrayStoreKey);
    }
}

- (void)setEnumClass:(Class)enumClass {
    @synchronized (self) {
        objc_setAssociatedObject(self, &enumClassKey, enumClass, OBJC_ASSOCIATION_RETAIN);
    }
}


- (id)objectForEnum:(WSEnum *)key {
    return [[self lgArray] objectAtIndex:[key ordinal]];
}

- (void)setObject:(id)value forEnum:(WSEnum *)key {
    [[self lgArray] replaceObjectAtIndex:[key ordinal] withObject:value];
}

- (void)clearObjects {
    for (int i = 0; i < [[self lgArray] count]; i++) {
        [[self lgArray] replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}
@end