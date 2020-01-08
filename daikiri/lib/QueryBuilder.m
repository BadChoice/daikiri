#import "QueryBuilder.h"
#import <CoreData/CoreData.h>
#import "Daikiri.h"
#import "RVCollection.h"

@implementation QueryBuilder


-(id)initWithModel:(NSString*)model{
    if (self= [super init]) {
        _model          = Daikiri.swiftPrefix ? [model replace:Daikiri.swiftPrefix with:@""] : model;
        _predicates     = NSMutableArray.new;
        _sortPredicates = NSMutableArray.new;
    }
    return self;
}

+(QueryBuilder*)query:(NSString*)model{
    QueryBuilder* query = [[self alloc] initWithModel:model];
    return query;
}

//============================================================
#pragma mark - Where
//============================================================
-(QueryBuilder*)where:(NSString*)field is:(id)value{
    return [self where:field operator:@"=" value:value];
}
-(QueryBuilder*)where:(NSString*)field operator:(NSString*)operator value:(id)value{
    if([operator isEqualToString:@"="]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K = %@",field, value]];
    }
    else if([operator isEqualToString:@">"]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K > %@",field, value]];
    }
    else if([operator isEqualToString:@">="]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K >= %@",field, value]];
    }
    else if([operator isEqualToString:@"<"]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K < %@",field, value]];
    }
    else if([operator isEqualToString:@"<="]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K <= %@",field, value]];
    }
    else if([operator isEqualToString:@"<>"] || [operator isEqualToString:@"!="]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K != %@",field, value]];
    }
    else if([operator isEqualToString:@"like"]){
        [self whereAny:@[field] like:value];
    }
    else if([operator isEqualToString:@"in"] || [operator isEqualToString:@"IN"]){
        [_predicates addObject:[NSPredicate predicateWithFormat:@"%K IN %@",field, value]];
    }
    return self;
}

-(QueryBuilder*)whereAny:(NSArray*)fields like:(id)value{
    NSMutableArray* orPredicates = NSMutableArray.new;
    for(NSString* field in fields){
        NSMutableArray* andPredicates = NSMutableArray.new;
        NSArray *terms;
        if ([value isKindOfClass:NSString.class]) {
            terms = [value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else{
            terms = @[value];
        }
        [[terms reject:^BOOL(NSString* term) {
            return [term isKindOfClass:NSString.class] && isEmptyString(term);
        }] each:^(NSString* term ) {
            [andPredicates addObject:[NSPredicate predicateWithFormat:@"%K contains[cd] %@", field, term]];
        }];
        [orPredicates addObject:[NSCompoundPredicate andPredicateWithSubpredicates:andPredicates]];
    }
    [_predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:orPredicates]];
    return self;
}

-(QueryBuilder*)whereAny:(NSArray*)fields is:(id)value{
    NSMutableArray* orPredicates = [NSMutableArray new];
    for(NSString* field in fields){
        [orPredicates addObject:[NSPredicate predicateWithFormat:@"%K = %@",field, value]];
    }
    [_predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:orPredicates]];
    return self;
}

-(QueryBuilder*)where:(NSString*)field in:(NSArray*)values{
    if (isNull(values)){
        values = @[];
    }
    
    [_predicates addObject:[NSPredicate predicateWithFormat:@"%K IN %@",field, values]];
    return self;
}

//============================================================
#pragma mark - Sort
//============================================================
-(QueryBuilder*)orderBy:(NSString*)key{
    if(key != nil){
        return [self orderBy:key ascendig:YES];
    }
    return self;
}

-(QueryBuilder*)orderBy:(NSString*)key ascendig:(BOOL)ascending{
    if(key != nil){
        [_sortPredicates addObject:[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]];
    }
    
    return self;
}

//============================================================
#pragma mark - Skip / take
//============================================================
-(QueryBuilder*)skip:(int)count{
    skip = @(count);
    return self;
}

-(QueryBuilder*)take:(int)count{
    take = @(count);
    return self;
}

//============================================================
#pragma mark - Raw
//============================================================
-(QueryBuilder*)raw:(NSString*)raw{
    [_predicates addObject:[NSPredicate predicateWithFormat:raw]];
    return self;
}

-(QueryBuilder*)addPredicate:(NSPredicate*)predicate{
    [_predicates addObject:predicate];
    return self;
}

//============================================================
#pragma mark - Execute query
//============================================================
-(NSUInteger)count{
    NSFetchRequest *request;
    
    Class modelClass        = self.getClass;
    NSString* entityName    = [modelClass performSelector:@selector(entityName)];
    request                 = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:_predicates];
    [request setPredicate:compoundPredicate];
    
    __block NSUInteger result;
    [[modelClass managedObjectContext] performBlockAndWait:^{
        NSError *error   = nil;
        result = [[modelClass managedObjectContext] countForFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
    return result;
}

-(Class)getClass{
    if (Daikiri.swiftPrefix){
        return NSClassFromString([NSString stringWithFormat:@"%@%@", Daikiri.swiftPrefix, _model]);
    }
    return NSClassFromString(_model);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

-(NSArray*)doQuery{
    
    NSFetchRequest *request;
    
    Class modelClass        = self.getClass;
    NSString* entityName    = [modelClass performSelector:@selector(entityName)];
    request                 = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if(skip){
        [request setFetchOffset:skip.intValue];
    }
    
    if(take){
        [request setFetchLimit:take.intValue];
    }
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:_predicates];
    [request setPredicate:compoundPredicate];
    
    [request setSortDescriptors:_sortPredicates];
    
    __block NSArray *results;
    [[modelClass managedObjectContext] performBlockAndWait:^{
        NSError *error   = nil;
        results = [[modelClass managedObjectContext] executeFetchRequest:request error:&error];
        if ( ! results) {
            NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
    return results;
}

-(NSArray*)get{
    return [self.getClass performSelector:@selector(managedArrayToDaikiriArray:) withObject:[self doQuery]];
}

-(id)first{
    NSArray* results = [[[self skip:0] take:1] doQuery];
    
    if([results count] > 0){
        Daikiri *mo = [self.getClass performSelector:@selector(fromManaged:) withObject:results[0]];
        return mo;
    }
    return nil;
}

#pragma clang diagnostic pop

@end
