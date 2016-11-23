//
//  DKFactory.m
//  daikiri
//
//  Created by Badchoice on 22/11/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DKFactory.h"
#import "Daikiri.h"

@implementation DKFactory

static NSMutableDictionary* mappings;

+(void)define:(Class)class builder:(NSDictionary*(^)())builder{
    NSString* classString               = NSStringFromClass(class);
    if( ! mappings ) mappings           = [NSMutableDictionary new];
    mappings[ classString ]             = [NSMutableDictionary new];
    mappings[ classString ][@"default"] = builder().mutableCopy;
}

+(void)defineAs:(Class)class name:(NSString*)name builder:(NSDictionary*(^)())builder{
    NSString* classString               = NSStringFromClass(class);
    if( ! mappings ) mappings           = [NSMutableDictionary new];
    mappings[ classString ]             = [NSMutableDictionary new];
    mappings[ classString ][name]       = builder().mutableCopy;
}

-(id)initWith:(Class)class name:(NSString*)name count:(int)count{
    self    = [super init];
    _class  = class;
    _count  = count;
    _name   = name ? name : @"default";
    return self;
}

+(DKFactory*)factory:(Class)class{
    return [[DKFactory alloc] initWith:class name:nil count:1];
}

+(DKFactory*)factory:(Class)class count:(int)count{
    return [[DKFactory alloc] initWith:class name:nil count:count];
}

+(DKFactory*)factory:(Class)class name:(NSString*)name{
    return [[DKFactory alloc] initWith:class name:name count:1];
}

+(DKFactory*)factory:(Class)class name:(NSString*)name count:(int)count{
    return [[DKFactory alloc] initWith:class name:name count:count];
}

-(NSMutableDictionary*)attributesWithOverride:(NSDictionary*)override{
    NSString* classString         = NSStringFromClass(_class);
    NSMutableDictionary* baseDict = mappings[ classString ][ _name];
    baseDict                      = baseDict.mutableCopy;
    if(override){
        [baseDict addEntriesFromDictionary:override];
    }
    return baseDict;
}

-(id)make{
    return [self make:nil];
}

-(id)create{
    return [self create:nil];
}

-(id)make:(NSDictionary*)overrideAttributes{
    if(_count == 1){
        return [_class fromDictionary: [self attributesWithOverride:overrideAttributes] ];
    }
    else{
        NSMutableArray * result = [NSMutableArray new];
        for(int i= 0; i< _count; i++){
            [result addObject: [self attributesWithOverride:overrideAttributes] ];
        }
        return result;
    }
}

-(id)create:(NSDictionary*)overrideAttributes{
    if(_count == 1){
        NSMutableDictionary * dict = [self attributesWithOverride:overrideAttributes];
        if( ! dict[@"id"] ){
            dict[@"id"] = @([_class all].count + 1);
        }
        return [_class createWith: dict];
    }
    else{
        NSMutableArray * result = [NSMutableArray new];
        for(int i= 0; i< _count; i++){
            NSMutableDictionary * dict = [self attributesWithOverride:overrideAttributes];
            if( ! dict[@"id"] ){
                dict[@"id"] = @([_class all].count + 1);
            }
            [result addObject: dict ];
        }
        return result;
    }
}

@end
