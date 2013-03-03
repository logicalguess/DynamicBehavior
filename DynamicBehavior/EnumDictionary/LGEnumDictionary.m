#import "LGEnumDictionary.h"
#import "WSEnum.h"

@interface LGEnumDictionary () {
    NSMutableArray *arrayStore;
    NSMutableDictionary *nameToEnumMapping;
}

@end

@implementation LGEnumDictionary {

}

- (id)initWithEnumClass:(Class)anEnumClass {
    if (self = [super init]) {
        [self setEnumClass:anEnumClass];
        NSArray *enumValues = [anEnumClass enumValues];
        int count = [enumValues count];

        arrayStore = [NSMutableArray arrayWithCapacity:count];
        nameToEnumMapping = [NSMutableDictionary dictionaryWithCapacity:count];

        for (WSEnum *e in enumValues) {
            [arrayStore addObject:[NSNull null]];
            [nameToEnumMapping setValue:e forKey:[e name]];
        }
    }

    return self;

}

- (id)objectForEnum:(WSEnum *)key {
    return [arrayStore objectAtIndex:[key ordinal]];
}

- (void)setObject:(id)value forEnum:(WSEnum *)key {
    [arrayStore replaceObjectAtIndex:[key ordinal] withObject:value];
}

- (id)valueForKey:(NSString *)key {
    WSEnum *e = [nameToEnumMapping objectForKey:key]; //[enumClass enumWithName:key];
    if (e) {
        return [self objectForEnum:e];
    }
    else {
        return [super valueForKey:key];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    WSEnum *e = [nameToEnumMapping objectForKey:key]; //[enumClass enumWithName:key];
    if (e) {
        [self setObject:value forEnum:e];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return [NSNull null];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [NSException raise:@"No such enum" format:@"Enum value %@ not found in %@", key, [self enumClass]];
}

- (void)clearObjects {
    for (int i = 0; i < [arrayStore count]; i++) {
        [arrayStore replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}

@end