#import <objc/runtime.h>
#import "LGDynamic.h"


@implementation LGDynamic {

}

- (NSMutableDictionary*)lgDictionary
{
    static char dictionaryKey;
    @synchronized (self) {
        if (!objc_getAssociatedObject(self, &dictionaryKey)) {
            objc_setAssociatedObject(self, &dictionaryKey, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN);
        }
        return objc_getAssociatedObject(self, &dictionaryKey);
    }
}

- (id) valueForUndefinedKey:(NSString *)key {
    return [[self lgDictionary] valueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [[self lgDictionary] setValue:value forKey:key];
}

@end