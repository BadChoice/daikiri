#import "DKFactory.h"
#import "Daikiri.h"

@implementation DKFactory

static NSMutableDictionary* mappings;

+(void)define:(Class)class builder:(NSDictionary*(^)(DKFaker * faker))builder{
    NSString* classString               = NSStringFromClass(class);
    if( ! mappings ) mappings           = NSMutableDictionary.new;
    mappings[ classString ]             = NSMutableDictionary.new;
    //mappings[ classString ][@"default"] = builder(DKFaker.new).mutableCopy;
    mappings[ classString ][@"default"] = builder;
}

+(void)defineAs:(Class)class name:(NSString*)name builder:(NSDictionary*(^)(DKFaker * faker))builder{
    NSString* classString               = NSStringFromClass(class);
    if( ! mappings ) mappings           = NSMutableDictionary.new;
    mappings[ classString ]             = NSMutableDictionary.new;
    //mappings[ classString ][name]       = builder(DKFaker.new).mutableCopy;
    mappings[ classString ][name]       = builder;
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
    NSString* classString                     = NSStringFromClass(_class);
    NSDictionary*(^builder)(DKFaker * faker)  = mappings[ classString ][ _name];
    NSMutableDictionary* baseDict = builder(DKFaker.new).mutableCopy;
    if (override){
        [baseDict addEntriesFromDictionary:override];
    }
    
    [self applyBlocksToDict:baseDict];
    
    return baseDict;
}

-(void)applyBlocksToDict:(NSMutableDictionary*)dict{
    for(NSString* key in dict.allKeys){
        if([dict[key] isKindOfClass:NSClassFromString(@"NSBlock")]){
            id(^myAwesomeBlock)(void) = dict[key];
            dict[key] = myAwesomeBlock();
        }
    }
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
    NSMutableArray * result = NSMutableArray.new;
    for(int i= 0; i< _count; i++){
        [result addObject: [_class fromDictionary: [self attributesWithOverride:overrideAttributes] ]];
    }
    return result;
}

-(id)create:(NSDictionary*)overrideAttributes{
    if (_count == 1){
        NSMutableDictionary * dict = [self attributesWithOverride:overrideAttributes];
        if( ! dict[@"id"] ){
            dict[@"id"] = @([_class all].count + 1);
        }
        return [_class createWith: dict];
    }

    NSMutableArray * result = NSMutableArray.new;
    for(int i= 0; i< _count; i++){
        NSMutableDictionary * dict = [self attributesWithOverride:overrideAttributes];
        if( ! dict[@"id"] ){
            dict[@"id"] = @([_class all].count + 1);
        }
        [result addObject: dict ];
    }
    return result;
}

@end
