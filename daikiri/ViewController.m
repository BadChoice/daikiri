//
//  ViewController.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "ViewController.h"
#import "Hero.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self example1];
    //[self example2];
    //[self example3];
    //[self example4];
    
    [self example5];
    
    
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

@end
