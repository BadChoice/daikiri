//
//  DaikiriCoreData.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DaikiriCoreData : NSObject


@property (strong,nonatomic) NSString* databaseName;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DaikiriCoreData*)manager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)deleteDatabase;
@end
