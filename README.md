In complex, large-scale projects it is essential to rely on generic code and frameworks to ensure reuse and development speed.
The single inheritance model is a big obstacle from this point of view, that is why languages like Ruby and Scala
are using mixins or traits to solve this problem. This project is an attempt to bring the same functionality to
Objective-C.

# Dynamic Features

In order to automate the data flow in a non-trivial application we want to avoid relying on properties, and instead we
want a mechanism that ensures we provide and consume **ALL** and **ONLY** the pieces of data that belong in a certain
**context**.

## Enumerations

Using WSEnum. Each enum values is defined by a class, so it can provide behavior on top of a "constant" value.

### Sample usage

ActivityEnum.h

    @interface ActivityEnum : WSEnum
    + (ActivityEnum*)WALKING;
    + (ActivityEnum*)RUNNING;
    + (ActivityEnum*)CYCLING; 
    @end

ActivityEnum.m

    @interface RunningActivityEnum : ActivityEnum @end
    @interface WalkingActivityEnum : ActivityEnum @end
    @interface CyclingActivityEnum : ActivityEnum @end
    
    @implementation ActivityEnum
    WS_ENUM(CyclingActivityEnum, CYCLING)
    WS_ENUM(RunningActivityEnum, RUNNING)
    WS_ENUM(WalkingActivityEnum, WALKING)
    @end
    
    @implementation CyclingActivityEnum
    @end
    
    @implementation WalkingActivityEnum
    @end
    
    @implementation RunningActivityEnum
    @end

## The LGEnumDictionary class

An enum dictionary behaves like a dictionary whose keys are restricted to the values of an enumeration. The implementation
is actually backed by an array and it is KVC compliant.

It provides a compromise between a strongly typed object (an instance of a class) and an NSDictionary. The enumeration
expresses the structure of data, and it can be used to do that in a consistent way across an application. For example,
a model and view can use the same enumeration to epxress the dependency on receieving and the promise to provide data
that is structured in a certain way.

### Protocol

The following protocol describes the interface of an LGEnumDictionary:

    @protocol LGEnumDictionary <NSObject>
    - (id)objectForEnum:(WSEnum *)key;
    - (void)setObject:(id)value forEnum:(WSEnum *)key;
    - (void)clearObjects;
    @end

### Sample usage

We can create an instance of LGEnumDictionary by using the factory method dictionaryWithEnumClass:

    LGEnumDictionary *rec = [LGEnumDictionary dictionaryWithEnumClass:[ActivityEnum class]];

    STAssertTrue([[ActivityRecord class] conformsToProtocol:@protocol(LGEnumDictionary)], @"should conform to protocol");

    [rec setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([rec valueForKey:@"WALKING"], @"abc", @"incorrect value");

    [rec setValue:@"def" forKey:@"CYCLING"];
    STAssertEquals([rec valueForKey:@"CYCLING"], @"def", @"incorrect value");
    STAssertEquals([rec objectForEnum:ActivityEnum.CYCLING], @"def", @"incorrect value");

    [rec clearObjects];

Or we can create a dedicated subclass if it is going to be used a lot in a project and/or if we want 
more help from the compiler.

ActivityRecord.h

    @class ActivityEnum;
    
    @interface ActivityRecord : LGEnumDictionary
    - (id)objectForEnum:(ActivityEnum *)key;
    - (void)setObject:(id)value forEnum:(ActivityEnum *)key;
    @end

ActivityRecord.m

    @implementation ActivityRecord {
    
    }
    - (id)init {
        return [super initWithEnumClass:[ActivityEnum class]];
    }
    
    - (id)objectForEnum:(ActivityEnum *)key {
        return [super objectForEnum:key];
    }
    
    - (void)setObject:(id)value forEnum:(ActivityEnum *)key {
        [super setObject:value forEnum:key];
    }
    
    @end
    
## The LGEnumDictionary category

Adding this category to a class makes its instances behave like an enum dictionary. 
As an example we added the category to NSObject (in general this is a bad idea), 
and then we can write code like this:
    
    NSObject *obj = [NSObject new];
    [obj setEnumClass:[ActivityEnum class]];

    [obj setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([obj objectForEnum:ActivityEnum.WALKING], @"abc", @"incorrect value");
    
    [obj clearObjects];

## The LGDynamic class and category

The LGDynamic class makes subclasses behave like a dictionary that will accept any NSString key in a KVC compliant way
(by handling undefined keys). It does not use instance variables, so it can be used as a category 
(by copying and pasting or by defining a macro). You guessed, it uses associative references...

### Sample usage
    SomeDynamic *obj = [SomeDynamic new];

    [obj setValue:@"abc" forKey:@"key1"];

    STAssertEquals([obj valueForKey:@"key1"], @"abc", @"incorrect value");
    STAssertNil([obj valueForKey:@"key2"], @"value of inexistent should be nil");

All the class SomeDynamic has to do is extend LGDynamic 

SomeDynamic.h  
    
    @interface SomeDynamic : LGDynamic
    @end

SomeDynamic.m  
   
    @implementation SomeDynamic 
    @end

# Instance Enhancement and Behavior Injection

TODO

# DCI Features

TODO
