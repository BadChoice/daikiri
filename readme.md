# Daikiri

## Description
Its a lighweight and simple library to work with models allowing the JSON to Model to Core Data both ways.
Really useful for server / app synchronization.

## Installation

Using pods:


```
pod 'daikiri' ,:git => 'https://github.com/BadChoice/daikiri.git'
```

## Usage

Create a model that inherts from `Daikiri` and add the properties you want to be automatically converted
Note that submodels will automatically be converted if they also inhert from `Daikiri`

#### JSON

```
    #import "Daikiri.h"
    #import "Headquarter.h"

    @interface Hero : Daikiri

    @property (strong,nonatomic) NSString* name;
    @property (strong,nonatomic) NSNumber* age;
    @property (strong,nonatomic) Headquarter* headquarter;

    @end

```

Then you can do:

```
    NSDictionary* d = @{
        @"name" : @"Batman",
        @"age"  : @10,
        @"headquarter":@{
            @"address" : @"patata",
            @"isActive" : @1,
            @"vehicles"   : @[
                @{@"model" : @"Batmobile"},
                @{@"model" : @"Batwing"},
                @{@"model" : @"Tumbler"},
            ]
        }
    };

    Hero * model = [Hero fromDictionary:d];    

```

And convert it back

```
    NSDictionary* modelToDict = [model toDictionary];
    NSLog(@"Model to dict: %@",modelToDict);

```

You can also convert the arrays to its class, for doing so you need to create the method 
`-(Class)property_DaikiriArray` where `property` is the name of the `NSArray` property.

In the previous case we have the model `Headquarter` like this

```
    @interface Headquarter : Daikiri

    @property(strong,nonatomic) NSString* address;
    @property(strong,nonatomic) NSNumber* isActive;
    @property(strong,nonatomic) NSArray*  vehicles;

    @end

```

with the following method 

```
-(Class)vehicles_DaikiriArray{
    return [Vehicle class];
}

```

And vehicles will be converted automatically.


#### CORE DATA

With a `Daikiri` model we can work with coredata in an active recod like way. You just need to name the
model the same way it is in the database `.xcdatamodeld`

A `Daikiri` model comes with an `id` property that is the `primary key` used for all the following methods

Then you can do the following

```
    [model create] //It creates a new record in the database needs to have the id

    model.name = "Bruce wayne";
    model.age = @10;

    [model save]    //Updates the record saved in the database (if it doesn't exists, it will create it)
```

We can also

```
    // Get an specific hero
    Hero* batman = [Hero find:@10]; //Search the model in the database
    [batman delete];                //Deletes it from the database

    // Get all heros
    NSArray* allHeros = [Hero all];    
```

If you want, there are the convenience methods to to those basic actions directly from a dictionary


```    
    +(bool)createWith:(NSDictionary*)dict;
    +(bool)updateWith:(NSDictionary*)dict;    
    +(bool)deleteWith:(NSNumber*)id;
```
    
You can override the `+(NSManagedObjectContext*)managedObjectContext` function in your model if you want to 
use your custom `managedObjectContext`. By default it uses the default `core data` xcode project's

```
    +(NSManagedObjectContext*)managedObjectContext{
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return context;
    }
```



