//
//  DaikiriCoreData.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DaikiriCoreData.h"

@implementation DaikiriCoreData


+ (DaikiriCoreData*) manager {
    static DaikiriCoreData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "works.revo.daikiri" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL* )applicationSupportDirectory{
    NSError *error;
    NSURL* appSupportDir = [[NSFileManager defaultManager]
                            URLForDirectory:NSApplicationSupportDirectory
                            inDomain:NSUserDomainMask
                            appropriateForURL:nil
                            create:YES
                            error:&error];
    return appSupportDir;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store

    NSString* dbFilename = [NSString stringWithFormat:@"%@.sqlite",self.databaseName];
    
    //_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL         = [[self applicationSupportDirectory] URLByAppendingPathComponent:dbFilename];
    NSError *error          = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    //Lightweigh migration
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

-(NSString*)databaseName{
    if(_databaseName == nil){
        _databaseName = [[NSBundle mainBundle]
                                objectForInfoDictionaryKey:@"CFBundleName"];
    }
    
    return _databaseName;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Clear DB
- (void)deleteDatabase{
    [self deleteAllEntities];
    
    NSError *error      = nil;
    BOOL result         = YES;
    
    NSString* dbFilename = [NSString stringWithFormat:@"%@.sqlite",self.databaseName];
    
    NSURL *storeURL     = [[self applicationSupportDirectory]    URLByAppendingPathComponent:dbFilename];
    NSURL *walURL       = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"];
    NSURL *shmURL       = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"];
    
    
    for (NSURL *url in @[storeURL, walURL, shmURL]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            result = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        }
    }
    
    _managedObjectContext       = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel         = nil;
    
}

-(void)deleteAllEntities{
    NSArray* entities = self.managedObjectModel.entities;
    for(NSEntityDescription* entity in entities) {        
        NSFetchRequest*  fetchRequest       = [[NSFetchRequest alloc] initWithEntityName:entity.name];
        NSBatchDeleteRequest* deleteReqest  = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        
        NSError* error;
        [self.managedObjectContext executeRequest:deleteReqest error:&error];
    }
}

@end
