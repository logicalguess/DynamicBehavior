# Motivation

In complex, large-scale projects it is essential to rely on generic code and frameworks to ensure reuse and development speed.
The single inheritance model is a big obstacle from this point of view, that is why languages like Ruby and Scala
are using mixins or traits to solve this problem. This project is an attempt to bring the same kind of functionality to
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

It provides a compromise between a strongly typed object (an instance of a class) and an <code>NSDictionary</code>. The enumeration
expresses the structure of data, and it can be used to do that in a consistent way across an application. For example,
a model and view can use the same enumeration to express the dependency on receiving and the promise to provide data
that is structured in a certain way.

### Protocol

The following protocol describes the interface of an <code>LGEnumDictionary</code>:

    @protocol LGEnumDictionary <NSObject>
    - (id)objectForEnum:(WSEnum *)key;
    - (void)setObject:(id)value forEnum:(WSEnum *)key;
    - (void)clearObjects;
    @end

### Sample usage

We can create an instance of <code>LGEnumDictionary</code> by using the factory method <code>dictionaryWithEnumClass</code>:

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

All the class <code>SomeDynamic</code> has to do is extend <code>LGDynamic</code> 

SomeDynamic.h  
    
    @interface SomeDynamic : LGDynamic
    @end

SomeDynamic.m  
   
    @implementation SomeDynamic 
    @end

# Instance Enhancement and Behavior Injection

Objective-C allows the addition and modification of methods, and there is definitely a place for that, 
but what we are more interested in the runtime enhancement of object instances in a context dependent manner. 

The most common examples of such enhacements are wrapper patterns (Proxy, Decorator, Adapter, Facade) found in
virtually all programming languages. Arguably, adding a level of indirection to raise the level of abstraction has been
the main engine of progress in computer science, and it is also how large-scale projects remain maintainable (think IOC 
containers).

In this project we are using Objective-C's support for message-forwarding to implement instance 
decoration/proxying/adapting.

## The LGDecorator class

This class helps decorate some of the methods of a particular instance, by invoking a *before* and/or *after* method.

### Sample Usage

Assume we want to decorate the <code>name</code> method of the <code>ActivityEnum</code> class so we log something 
before and after it is invoked. Then we can implement the *before_<method>* and/or *after_<method>* methods in a class, let's call it
<code>ActivityDecorator</code>.

ActivityDecorator.h

    @interface ActivityDecorator : NSObject
    - (void)before_name;
    - (void)after_name;
    @end

ActivityDecorator.m

    @implementation ActivityDecorator
    - (void)before_name {
        NSLog(@"Before interceptor called");
    }
    
    - (void)after_name {
        NSLog(@"After interceptor called");
    }
    @end

Then we can decorate an instance of <code>ActivityEnum</code>:

    ActivityEnum *activity = [LGDecorator decorateInstance:ActivityEnum.WALKING withClass:[ActivityDecorator class]];
    [activity name];

The output will show that the method was indded decorated:

    2013-03-10 13:52:05.289 otest[3185:707] Before interceptor called
    2013-03-10 13:52:05.290 otest[3185:707] After interceptor called
    
Here is the interface of the <code>LGDecorator</code> class:

    @interface LGDecorator : NSObject
    +(id)decorateInstance:(id)target withClass:(Class)decoratorClass;
    +(id)decorateInstance:(id)target with:(id)decorator;
    @end

# DCI Features

TODO - see unit tests for now
