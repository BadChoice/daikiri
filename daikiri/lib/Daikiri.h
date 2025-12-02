#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DaikiriJSON.h"
#import "QueryBuilder.h"

@interface Daikiri : DaikiriJSON {
    NSManagedObject     *_managed;
    Daikiri             *_pivot;
    NSMutableDictionary *_relationships;
    Boolean             isRelationshipCachingDisabled;
}

@property(strong, nonatomic) NSNumber *id;

// -----------------------------------------
// Create / Save / Update / Destroy
// -----------------------------------------

/**
 * Creates a new object to de database
 * It MUST have the id field filled or it won't be inserted
 * If the object already exists, the db one will be returned
 */
+ (instancetype)create:(Daikiri *)object;

/**
 * The save function uses the model ID for checking if it already
 * exists so it will do an update, or if model ID is null or can't
 * find the object, it will create a new one and save it to the
 * database
 */
- (bool)save;

/**
 * Updates the object in the database (needs the id the be filled)
 */
- (bool)update;

/**
 * Deletes the object from the database. Id field is required
 */
- (bool)destroy;


/**
 * Deletes all the records of this model from the database
 */
+ (void)truncate;

/**
 Returns a new instance fetched from the database. Current object is not modified
 */
-(instancetype)fresh;

/**
 Fetches the data from the database and refreshes itself with it, so current object is modified
 */
-(instancetype)refresh;


// -----------------------------------------
// Convenience methods
// -----------------------------------------
+ (instancetype)createWith:(NSDictionary *)dict;

+ (bool)updateWith:(NSDictionary *)dict;

+ (bool)destroyWith:(NSNumber *)id;

+ (void)destroyWithArray:(NSArray *)idsArray;

// -----------------------------------------
// Eloquent like
// -----------------------------------------
/**
 * Returns a base queryBuilder instance for the model that can be used to add query filters
 */
+ (QueryBuilder *)query;

/**
 * Removes the cached relationships
 * @return object itself so it can be chained
 */
- (Daikiri *)invalidateRelationships;


/** Disables the relationships cachin for this instance */
- (Daikiri *)withoutRelationshipCaching;

/**
 * Returns the model in the database that matches the id or `nil` if not found
 */
+ (instancetype)find:(NSNumber *)id;

/**
 * Returns all the models that the id is in the identifiers array
 */
+ (NSArray *)findIn:(NSArray *)identifiers;

/**
 * Returns the first model found
 */
+ (instancetype)first;

/**
 * Returns the first model found sorted by
 */
+ (instancetype)first:(NSString *)sort;

/**
 * Returns all the models in the database
 */
+ (NSArray *)all;

/**
 * Returns all the models in the database sorted by key
 */
+ (NSArray *)all:(NSString *)sort;

/**
 * Returns the parent model related with the localKey
 */
- (Daikiri *)belongsTo:(NSString *)model localKey:(NSString *)localKey;

/**
 * Retuns all the models that have self as parent with the foreignKey
 */
- (NSArray *)hasMany:(NSString *)model foreignKey:(NSString *)foreignKey;

/**
 * Retuns all the models that have self as parent with the foreignKey
 */
- (NSArray *)hasMany:(NSString *)model foreignKey:(NSString *)foreignKey sort:(NSString *)sort;

/**
 * Get the related models when there is a pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 */
- (NSArray *)belongsToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey foreignKey:(NSString *)foreignKey;

/**
 * Get the related models when there is a pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 * sorted by sort
 */
- (NSArray *)belongsToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey foreignKey:(NSString *)foreignKey pivotSort:(NSString *)pivotSort;

/**
 * Get the related models when there is a polymorphic relation it adds type and id to type and id
 */
-(id)morphTo:(NSString*)relationship;
/**
 * Get the related models when there is a polymorphic relation
 */
-(id)morphTo:(NSString*)typeKey idKey:(NSString*)idKey;


/**
 * Gets many related through a polymorphic relationship
 */
-(NSArray*)morphMany:(NSString*)model relationship:(NSString*)relationship sort:(NSString*)sort;

/**
 * Gets many related through a polymorphic relationship
 */
-(NSArray*)morphMany:(NSString*)model typeKey:(NSString*)typeKey idKey:(NSString*)idKey sort:(NSString*)sort;

/**
 * Get the related models when there is a polymorphic pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 */
- (NSArray *)morphToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey localType:(NSString *)localType foreignKey:(NSString *)foreignKey;

/**
 * Get the related models when there is a polymorphic pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 * sorted by sort
 */
- (NSArray *)morphToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey localType:(NSString *)localType foreignKey:(NSString *)foreignKey pivotSort:(NSString *)pivotSort;


-(NSArray*)morphedByMany:(NSString*)model relationship:(NSString*)relationship localKey:(NSString*)localKey pivotModel:(NSString*)pivotModel;

/**
 * In `belongsToMany` relationships you can access to the pivot model with
 * this method, otherwise, it will be nil
 */
- (Daikiri *)pivot;

- (void)setPivot:(Daikiri *)pivot;

/**
 * Overridable function so each model can define its managedObjectContext
 * By default it returns the DaikiriCoredata.manager
 */
+ (NSManagedObjectContext *)managedObjectContext;


/** In Swift class names contain a prefix that is incompatible with the corde data entity name, so we can provide it to make it work with swift*/
+(void)setSwiftPrefix:(NSString*)theSwiftPrefix;

/** The swift module prefix provided to make it match with coredata entity names that can't contain the module infront*/
+(NSString*)swiftPrefix;

/** Gets the class name, checks for objc - and swift versions*/
+(Class)classFor:(NSString*)model;
+(NSString*)entityName;

@end
