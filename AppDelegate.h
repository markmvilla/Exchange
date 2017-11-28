//
//  AppDelegate.h
//  Exchange
//
//  Created by Mark Villa on 8/31/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataClass.h"
#import "AFNetworking.h"
#import "SignUPViewController.h"
#import "LayoutViewController.h"
#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "MyStuffViewController.h"
#import "MoreViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)normalLaunch;

@end
