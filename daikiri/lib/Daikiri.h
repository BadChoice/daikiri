#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DaikiriJSON.h"
#import "QueryBuilder.h"

@interface Daikiri : DaikiriJSON {
    NSManagedObject     *_managed;
    Daikiri             *_pivot;
    NSMutableDictionary *_relationships;
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
+ (id)create:(Daikiri *)object;

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


// -----------------------------------------
// Convenience methods
// -----------------------------------------
+ (id)createWith:(NSDictionary *)dict;

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

/**
 * Returns the model in the database that matches the id or `nil` if not found
 */
+ (id)find:(NSNumber *)id;

/**
 * Returns all the models that the id is in the identifiers array
 */
+ (NSArray *)findIn:(NSArray *)identifiers;

/**
 * Returns the first model found
 */
+ (id)first;

/**
 * Returns the first model found sorted by 
 */
+ (id)first:(NSString *)sort;

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
 * Retuns all the models that have self as parent with the foreingKey
 */
- (NSArray *)hasMany:(NSString *)model foreignKey:(NSString *)foreignKey;

/**
 * Retuns all the models that have self as parent with the foreingKey
 */
- (NSArray *)hasMany:(NSString *)model foreignKey:(NSString *)foreignKey sort:(NSString *)sort;

/**
 * Get the related models when there is a pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 */
- (NSArray *)belongsToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey foreignKey:(NSString *)foreingKey;

/**
 * Get the related models when there is a pivot table between them,
 * you can acces the pivot information with the `pivot` method of the returning results
 * sorted by sort
 */
- (NSArray *)belongsToMany:(NSString *)model pivot:(NSString *)pivotModel localKey:(NSString *)localKey foreignKey:(NSString *)foreingKey pivotSort:(NSString *)pivotSort;


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
@end
