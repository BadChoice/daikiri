#import "RVCollection.h"
#import "Daikiri.h"
#import "DaikiriCoreData.h"
#import "QueryBuilder.h"

@implementation Daikiri

static NSString* swiftPrefix = nil;

//==================================================================
#pragma mark - Create / Save / Update / Destroy
//==================================================================
+(instancetype)create:(Daikiri*)toCreate{
    
    if( ! toCreate.id ){
        NSLog(@"model without id");
        return nil;
    }
    
    Daikiri* previous = [self.class find:toCreate.id];
    if( previous ) {
        NSLog(@"Model already exists with id: %@, returning the one from the DB",toCreate.id);
        return previous;
    }
    
    __block NSManagedObject *object;
    [self.class.managedObjectContext performBlockAndWait:^{
        object = [NSEntityDescription insertNewObjectForEntityForName:self.class.entityName inManagedObjectContext:self.class.managedObjectContext];
        [toCreate valuesToManaged:object];
        [self.class saveCoreData];
    }];

    return toCreate;
}

+(void)setSwiftPrefix:(NSString*)theSwiftPrefix{
    swiftPrefix = theSwiftPrefix;
}

+(NSString*)swiftPrefix{
    return swiftPrefix;
}

-(bool)save{
    Daikiri* previous = [self.class find:self.id];
    if(previous) {
        return [self update];
    }
    return [self.class create:self];
}

-(bool)update{
    if(_managed){
        [self valuesToManaged:_managed];
        return [self.class saveCoreData];
    }

    Daikiri* previous = [self.class find:self.id];
    if (!previous){
        NSLog(@"Model not in database");
        return false;
    }

    [previous destroy];
    [self save];
    return true;
}

-(instancetype)fresh{
    return [self.class find:self.id];
}

-(instancetype)refresh {
    Daikiri* fresh = [self fresh];
    [self.class properties:^(NSString* name){
        [self setValue:[fresh valueForKey:name] forKey:name];
    }];
    return self;
}

-(bool)destroy{
    if(_managed){
        __block bool result;
        [self.class.managedObjectContext performBlockAndWait:^{
            [[self.class managedObjectContext] deleteObject:self->_managed];
            result = [self.class saveCoreData];
        }];
        return result;
    }
    Daikiri *toDelete = [self.class find:self.id];
    return [toDelete destroy];
}

//==================================================================
#pragma mark - Convenience methods
//==================================================================
+(bool)updateWith:(NSDictionary*)dict{
    Daikiri* object = [self.class fromDictionary:dict];
    return [object update];
}

+(instancetype)createWith:(NSDictionary*)dict{
    Daikiri* object = [self.class fromDictionary:dict];
    return [self.class create:object];
}

+(bool)destroyWith:(NSNumber*)id{
    Daikiri * object = [self.class find:id];
    return [object destroy];
}

+(void)destroyWithArray:(NSArray*)idsArray{
    [idsArray each:^(NSNumber* objectId ) {
        [self.class destroyWith:objectId];
    }];
}

+(void)truncate{
    NSFetchRequest* request             = [NSFetchRequest fetchRequestWithEntityName: [self.class entityName]];
    NSBatchDeleteRequest* deleteReqest  = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [self.managedObjectContext executeRequest:deleteReqest error:nil];
}

//==================================================================
#pragma mark - Active record
//==================================================================
+(instancetype)find:(NSNumber*)id{
    if (id == nil) return nil;
    return [self.query where:@"id" is:id].first;
}

+(NSArray*)findIn:(NSArray*)identifiers{
    return [self.query where:@"id" in:identifiers].get;
}

+(instancetype)first{
    return [self first:@"id"];
}

+(instancetype)first:(NSString*)sort{
    return [self.query orderBy:sort].first;
}

+(NSArray*)all{
    return [self all:nil];
}

+(NSArray*)all:(NSString*)sort{
    return [self.query orderBy:sort].get;
}

-(Daikiri*)belongsTo:(NSString*)model localKey:(NSString*)localKey{
    NSString* cacheKey = str(@"belongs-to-%@-%@", model,localKey);
    id cached = [self getRelationshipCached:cacheKey];
    if(cached) return cached;
    return [self setRelationship:cacheKey object:[NSClassFromString(model) find:[self valueForKey:localKey]]];
}

-(NSArray*)hasMany:(NSString*)model foreignKey:(NSString*)foreignKey{
    return [self hasMany:model foreignKey:foreignKey sort:nil];
}

-(NSArray*)hasMany:(NSString*)model foreignKey:(NSString*)foreignKey sort:(NSString *)sort{
    NSString* cacheKey = str(@"has-many-%@-%@", model, foreignKey);
    id cached = [self getRelationshipCached:cacheKey];
    if(cached) return cached;
    return [self setRelationship:cacheKey object:[[NSClassFromString(model).query where:foreignKey is:self.id] orderBy:sort].get];
}

-(NSArray*)belongsToMany:(NSString*)model pivot:(NSString*)pivotModel localKey:(NSString*)localKey foreignKey:(NSString*)foreingKey{
    return [self belongsToMany:model pivot:pivotModel localKey:localKey foreignKey:foreingKey pivotSort:nil];
}

-(NSArray*)belongsToMany:(NSString*)model pivot:(NSString*)pivotModel localKey:(NSString*)localKey foreignKey:(NSString*)foreingKey pivotSort:(NSString *)pivotSort{
    NSString* cacheKey = str(@"belongs-many-%@-%@-%@-%@", model, pivotModel, localKey, foreingKey);
    id cached = [self getRelationshipCached:cacheKey];
    if (cached) return cached;

    //Pivots
    NSArray *pivots = [[NSClassFromString(pivotModel).query where:localKey is:self.id] orderBy:pivotSort].get;
    
    //Objects (attaching pivots)
    NSMutableArray* finalResults = NSMutableArray.new;
    for(id pivot in pivots){
        id object = [NSClassFromString(model) find:[pivot valueForKey:foreingKey]];
        if (object) {
            [object         setPivot:pivot];
            [finalResults   addObject:object];
        } else {
            NSLog(@"[WARNING] Daikiri is trying to get a belongs to many object but it doesn't exist");
        }
    }
    return [self setRelationship:cacheKey object:finalResults];
}

+(QueryBuilder*)query{
    return [QueryBuilder query:NSStringFromClass(self.class)];
}

-(id)getRelationshipCached:(NSString*)relationship{
    if (isRelationshipCachingDisabled) {
        return nil;
    }
    if(!_relationships) return nil;
    return _relationships[relationship];
}

-(id)setRelationship:(NSString*)relationship object:(id)object{
    if (isRelationshipCachingDisabled) {
        return object;
    }
    //return object; //Until we find a good way
    if(object == nil) return object;
    if(!_relationships) _relationships = NSMutableDictionary.new;
    _relationships[relationship] = object;
    return object;
}

-(Daikiri *)invalidateRelationships{
    _relationships = nil;
    return self;
}

-(Daikiri *)withoutRelationshipCaching{
    isRelationshipCachingDisabled = true;
    return self;
}

//==================================================================
#pragma mark - HELPERS
//==================================================================
-(void)valuesToManaged:(NSManagedObject*)managedObject{
    [managedObject setValue:[self valueForKey:@"id"] forKey:@"id"];
    
    [self.class properties:^(NSString *name) {
        id value    = [self valueForKey:name];
        if([value isKindOfClass:NSString.class]){
            [managedObject setValue:value forKey:name];
        }
        else if([value isKindOfClass:NSNumber.class]){
            [managedObject setValue:value forKey:name];
        }
    }];
}

+(id)fromManaged:(NSManagedObject*)managedObject{
    Daikiri *newObject = self.class.new;
    [newObject setValue:[managedObject valueForKey:@"id"] forKey:@"id"];
    
    [self.class properties:^(NSString *name) {
        @try{
            id value = [managedObject valueForKey:name];
            if([value isKindOfClass:NSString.class]){
                [newObject setValue:value forKey:name];
            }
            else if([value isKindOfClass:NSNumber.class]){
                [newObject setValue:value forKey:name];
            }
        }@catch (NSException * e) {
            //NSLog(@"Model value not in core data entity: %@", e);
        }
    }];
    [newObject setManaged:managedObject];
    return newObject;
}

+(NSArray*)managedArrayToDaikiriArray:(NSArray*)results{
    NSMutableArray* daikiriObjects = NSMutableArray.new;
    for(NSManagedObject* managed in results){
        [daikiriObjects addObject:[self.class fromManaged:managed]];
    }
    return daikiriObjects;
}

-(void)setManaged:(NSManagedObject *)managed{
    _managed = managed;
}

-(Daikiri*)pivot{
    return _pivot;
}

-(void)setPivot:(Daikiri*)pivot{
    _pivot = pivot;
}

//==================================================================
#pragma mark - Core data
//==================================================================
+(NSString*)entityName{
    NSString* entityName = NSStringFromClass(self.class);
    if (self.class.usesPrefix){
        return [entityName substringFromIndex:2];
    }
    if (self.class.swiftPrefix){
        return [entityName replace:self.class.swiftPrefix with:@""];
    }
    return entityName;
}

+(NSManagedObjectContext*)managedObjectContext{
    NSManagedObjectContext * context = [DaikiriCoreData manager].managedObjectContext;
    return context;
}

+(BOOL)usesPrefix{
    return false;
}

+(BOOL)saveCoreData{
    
    __block BOOL savedOK = NO;
    
    [self.class.managedObjectContext performBlockAndWait:^{
        NSError *error;
        savedOK = [[self.class managedObjectContext] save:&error];
        if(!savedOK) NSLog(@"Save core data failed: %@", error.localizedDescription);
    }];
    
    return savedOK;
}

-(void)dealloc{
    _managed = nil;
    _pivot   = nil;
    _relationships = nil;
}

@end
