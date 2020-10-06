#import <Foundation/Foundation.h>
#import "DKObject.h"

@interface DaikiriJSON : DKObject

/*
 Things left to do:
 - Eloquent like
 */

//-----------------
// DICT
//-----------------
/**
 * Creates a new model using the dictionary as a source
 *
 * - √ Submodels. Automatically converts to the submodel to its class as long as it extends `Daikiri`
 *
 * - √ Arrays. to be able to do the conversion to another model
 * the method `-(Class)property_DaikiriArray` should be defined.
 */
+(instancetype)fromDictionary:(NSDictionary*)dict;


/**
 * Fills a model using the dictionary as a source
 *
 * - √ Submodels. Automatically converts to the submodel to its class as long as it extends `Daikiri`
 *
 * - √ Arrays. to be able to do the conversion to another model
 * the method `-(Class)property_DaikiriArray` should be defined.
 */
+(instancetype)fromDictionary:(NSDictionary*)dict placeholder:(DaikiriJSON*)placeholder;

/**
 * It calls the +(id)fromDictionary but first 
 * converting the string to a dict
 */
+(instancetype)fromDictionaryString:(NSString*)string;

/**
 * Creates a dictionary from the model
 *
 * - √ Submodels
 * - √ Arrays
 */
-(NSDictionary*)toDictionary;

/**
 * Creates a dictionary from the model, we can send an array of keys that shouldn't be ignored
 *
 * - √ Submodels
 * - √ Arrays
 */
-(NSDictionary*)toDictionary:(NSArray*)foceKeys;

/**
 * Return an array of strings with the names of the values to ignore
 */
-(NSArray*)toDictionaryIgnore;


/**
 * Does a map with [self.class fromDictionary];
 */
+(NSArray*)fromDictionaryArray:(NSArray*)array;

/**
 * Does a map with [self.class toDictionary];
 */
+(NSArray*)toDictionaryArray:(NSArray*)array;


@end
