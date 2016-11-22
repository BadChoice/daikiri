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
    mappings[ classString ][@"default"] = builder();
}

+(void)defineAs:(Class)class name:(NSString*)name builder:(NSDictionary*(^)())builder{
    NSString* classString               = NSStringFromClass(class);
    if( ! mappings ) mappings           = [NSMutableDictionary new];
    mappings[ classString ]             = [NSMutableDictionary new];
    mappings[ classString ][name]       = builder();
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

-(id)make{
    NSString* classString = NSStringFromClass(_class);    
    return [_class fromDictionary:mappings[ classString ][_name]];
}

-(id)create{
    NSString* classString = NSStringFromClass(_class);
    return [_class createWith:mappings[ classString ][_name]];
}

@end
