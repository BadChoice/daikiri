//
//  ViewController.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "ViewController.h"
#import "Hero.h"
#import "Enemy.h"
#import "Friend.h"
#import "EnemyHero.h";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self example1]; //Json
    //[self example2];
    //[self example3];
    //[self example4];
    
    //[self example5]; //CoreData
    
    [self example6]; //Relationships
    
    
}

// json with submodels and arrays
-(void)example1{
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
    
    NSLog(@"Model data: %@ : %@ - %@", model.name, model.age, model.headquarter.address);
    
    NSDictionary* modelToDict = [model toDictionary];
    NSLog(@"Model to dict: %@",modelToDict);
}

// json with nulls
-(void)example2{
    NSDictionary* d = @{
                        @"name" : @"hola",
                        @"headquarter":@{
                                @"isActive" : @1,
                                @"vehicles"   : @[
                                        @{@"model" : @"Batmobile"},
                                        @{@"model" : @"Batwing"},
                                        @{@"model" : @"Tumbler"},
                                        ]
                                }
                        };
    
    Hero * model = [Hero fromDictionary:d];
    
    NSLog(@"Model data: %@ : %@ - %@", model.name, model.age, model.headquarter.address);
    
    NSDictionary* modelToDict = [model toDictionary];
    NSLog(@"Model to dict: %@",modelToDict);
}


/**
 Core data
 */
-(void)example3{
    NSDictionary* d = @{
                        @"id"   : @10,
                        @"name" : @"hola",
                        @"age"  : @10
                        };
    Hero * model = [Hero fromDictionary:d];
    [model save];
    Hero *foundModel = [Hero find:@10];
    NSLog(@"Fetched model: %@",foundModel);
}


-(void)example4{
    
    NSArray* results = [Hero all];
    for(Hero *hero in results){
        NSLog(@"%@",[hero toDictionary]);
        [hero delete];
    }
}


-(void)example5{
    NSDictionary* d = @{
                        @"id"   : @1,
                        @"name" : @"Batman",
                        @"age"  : @99
                        };
    Hero * model = [Hero fromDictionary:d];
    [model save];   //If exists it does an update, if not it does a create
    
    NSLog(@"%@",[model toDictionary]);
    model.name = @"Bruce wayne";
    model.age  = @39;
    [model update]; //this updates the previous record
    
    
    //List everyting in the ExampleModel table and clear it (we can see the change
    NSArray* results = [Hero all];
    for(Hero *example in results){
        NSLog(@"%@",[example toDictionary]);
        [example delete];
    }
}

-(void)example6{
    
    
    //Add models to database
    Hero * batman       = [Hero fromDictionary:@{@"id":@1, @"name":@"Batman"         ,@"age":@49}];
    Hero * spiderman    = @{@"id":@2, @"name":@"Spiderman"      ,@"age":@19};
    Hero * superman     = @{@"id":@3, @"name":@"Superman"       ,@"age":@99};
    
    Enemy* luxor        = @{@"id":@1, @"name":@"Luxor"          ,@"age":@32};
    Enemy* green_goblin = @{@"id":@2, @"name":@"Green Goblin"   ,@"age":@56};
    Enemy* thanos       = @{@"id":@3, @"name":@"Thanos"         ,@"age":@99};
    Enemy* joker        = @{@"id":@4, @"name":@"Joker"          ,@"age":@45};
    
    Friend* robin       = @{@"id":@1, @"name":@"Robin"         ,@"hero_id":@1};
    Friend* maryJane    = @{@"id":@2, @"name":@"Mary Jane"     ,@"hero_id":@2};
    Friend* blackCat    = @{@"id":@3, @"name":@"Black cat"     ,@"hero_id":@2};
    
    EnemyHero
    
}

@end
