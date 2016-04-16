//
//  ViewController.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "ViewController.h"
#import "ExampleModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self example1];
    //[self example2];
    //[self example3];
    [self example4];
    
    
}

// json with submodels and arrays
-(void)example1{
    NSDictionary* d = @{
                        @"name" : @"hola",
                        @"age"  : @10,
                        @"submodel":@{
                                @"address" : @"patata",
                                @"isValid" : @1,
                                @"anArray"   : @[
                                        @{@"message" : @"message1"},
                                        @{@"message" : @"message2"},
                                        @{@"message" : @"message3"},
                                        ]
                                }
                        };
    
    ExampleModel * model = [ExampleModel fromDictionary:d];
    
    NSLog(@"Model data: %@ : %@ - %@", model.name, model.age, model.submodel.address);
    
    NSDictionary* modelToDict = [model toDictionary];
    NSLog(@"Model to dict: %@",modelToDict);
}

// json with nulls
-(void)example2{
    NSDictionary* d = @{
                        @"name" : @"hola",
                        @"submodel":@{
                                @"isValid" : @1,
                                @"anArray"   : @[
                                        @{@"message" : @"message1"},
                                        @{@"message" : @"message2"},
                                        @{@"message" : @"message3"},
                                        ]
                                }
                        };
    
    ExampleModel * model = [ExampleModel fromDictionary:d];
    
    NSLog(@"Model data: %@ : %@ - %@", model.name, model.age, model.submodel.address);
    
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
    ExampleModel * model = [ExampleModel fromDictionary:d];
    [model save];
    ExampleModel *foundModel = [ExampleModel find:@10];
    NSLog(@"Fetched model: %@",foundModel);
}


-(void)example4{
    
    NSArray* results = [ExampleModel all];
    for(ExampleModel *example in results){
        NSLog(@"%@",[example toDictionary]);
        [example delete];
    }
}


@end
