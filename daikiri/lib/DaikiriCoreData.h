//
//  DaikiriCoreData.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DaikiriCoreData : NSObject{
    BOOL _useTestDatabase;
}

@property (strong,nonatomic) NSString* databaseName;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DaikiriCoreData*)manager;

- (void)useTestDatabase:(BOOL)useTestDatabase;
- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;
- (void)deleteDatabase;
- (void)deleteAllEntities;

- (void) setDefaultConnection:(NSString *) connectionName;

//=======================================================
#pragma mark - Transactions
//=======================================================
- (void)beginTransaction;
- (void)commit;
- (void)rollback;
- (void)transaction:(void(^)(void))callback;

@end
