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
Note that `submodels` will automatically be converted if they also inhert from `Daikiri`

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

##### Setup
`Daikiri` Comes with a `CoreData` manager. It creaes the `managedObjectContents` and connects to the database named `yourprojectname.sqlite` at 
`applicationDocumentsDirectory`.

You can change the project name by setting the property `databaseName` of the `DaikiriCoreData` manager

```
[DaikiriCoreData manager].databaseName = @"youdatabasename";
```

You should place this call before any other `CoreData` call so it's recomended to do it at `didFinishLaunchingWithOptions`.

The only thing you need to do is to add a call to `[[DaikiriCoreData manager] saveContex]` in your app delegate `-(void)applicationWillTerminate:(UIApplication *)application` to save the context even if there is a crash.


However, you can also use you custom `CoreData` manager by overridin the `+(NSManagedObjectContext*)managedObjectContext` function in your model.

```
+(NSManagedObjectContext*)managedObjectContext{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return context;
}
```




##### Core data models
With a `Daikiri` model we can work with coredata in an active recod like way. You just need to name the
model the same way it is in the database `.xcdatamodeld`

A `Daikiri` model comes with an `id` property that is the `primary key` used for all the following methods

Then you can do the following

```
[model create] //It creates a new record in the database needs to have the id

model.name = "Bruce wayne";
model.age  = @10;

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
    


#### Relationships
Alongs with the `find` and `all` When your models are in the database you have diferent ways to acces their relationships

`belongsTo`, `hasMany` and `belongsToMany`.

Check the examples below to understand them

```
//Add models to database
Hero * batman               = [Hero createWith:@{@"id":@1, @"name":@"Batman"         ,@"age":@49}];
Hero * spiderman            = [Hero createWith:@{@"id":@2, @"name":@"Spiderman"      ,@"age":@19}];
Hero * superman             = [Hero createWith:@{@"id":@3, @"name":@"Superman"       ,@"age":@99}];

Enemy* luxor                = [Enemy createWith:@{@"id":@1, @"name":@"Luxor"          ,@"age":@32}];
Enemy* greenGoblin          = [Enemy createWith:@{@"id":@2, @"name":@"Green Goblin"   ,@"age":@56}];
Enemy* joker                = [Enemy createWith:@{@"id":@4, @"name":@"Joker"          ,@"age":@45}];

Friend* robin               = [Friend createWith:@{@"id":@1, @"name":@"Robin"         ,@"hero_id":batman.id}];
Friend* maryJane            = [Friend createWith:@{@"id":@2, @"name":@"Mary Jane"     ,@"hero_id":spiderman.id}];
Friend* blackCat            = [Friend createWith:@{@"id":@3, @"name":@"Black cat"     ,@"hero_id":spiderman.id}];

EnemyHero* luxorBatman      = [EnemyHero createWith:@{@"id":@1, @"hero_id":batman.id      ,@"enemy_id":luxor.id, @"level":@7}];
EnemyHero* luxorSuperman    = [EnemyHero createWith:@{@"id":@2, @"hero_id":superman.id    ,@"enemy_id":luxor.id, @"level":@5}];
EnemyHero* jokerBatman      = [EnemyHero createWith:@{@"id":@3, @"hero_id":batman.id      ,@"enemy_id":joker.id, @"level":@10}];
EnemyHero* greenGoblinSpider= [EnemyHero createWith:@{@"id":@4, @"hero_id":spiderman.id   ,@"enemy_id":greenGoblin.id, @"level":@10}];


NSLog(@"Robin's hero is: %@",robin.hero.name);      //Belongs to

for(Friend* friend in spiderman.friends){           //has many
    NSLog(@"Spiderman friend: %@",friend.name);
}

for(Enemy* enemy in batman.enemies){                //Belongs to many
    NSLog(@"Batman enemy: %@ with level: %@",enemy.name, ((EnemyHero*)enemy.pivot).level);
}
```



