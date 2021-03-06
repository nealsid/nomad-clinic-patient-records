//
//  NEMRAppDelegate.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/19/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "ClinicViewController.h"
#import "NEMRAppDelegate.h"


#import "ClinicViewController.h"
#import "DiseaseTableViewController.h"
#import "PatientsTableViewController.h"
#import "Patient.h"

@import CoreData;

@interface NEMRAppDelegate ()
@end

@implementation NEMRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  /* Set up root view controller */
  UITabBarController* tbc = [[UITabBarController alloc] init];

  UINavigationController* navController = [[UINavigationController alloc] init];
  navController.navigationBar.titleTextAttributes =
      [NSDictionary dictionaryWithObjects:@[[UIColor blackColor],
                                            [UIFont boldSystemFontOfSize:24]]
                                  forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  ClinicViewController* vc = [[ClinicViewController alloc] init];
  [navController pushViewController:vc animated:NO];
  //  [navController.navigationBar setBackgroundColor:[UIColor colorWithRed:54.0/255 green:79.0/255 blue:42.0/255 alpha:1.0]];
  //  [navController.navigationBar setBackgroundColor:[UIColor colorWithRed:0xda/255.0 green:0xee/255.0 blue:0xff/255.0 alpha:1.0]];
  self.window.tintColor = [UIColor darkGrayColor];
  UINavigationController* diseaseNavController = [[UINavigationController alloc] init];
  DiseaseTableViewController* diseaseVc = [[DiseaseTableViewController alloc] init];
  [diseaseNavController pushViewController:diseaseVc animated:YES];
  diseaseNavController.navigationBar.titleTextAttributes =
      [NSDictionary dictionaryWithObjects:@[[UIColor blackColor],
                                            [UIFont boldSystemFontOfSize:24]]
                                  forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  UIImage* stetho = [UIImage imageNamed:@"stetho"];
  navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Clinics"
                                                           image:stetho
                                                   selectedImage:nil];
  UIImage* crowd = [UIImage imageNamed:@"crowd"];
  diseaseNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Diseases"
                                                                  image:crowd
                                                          selectedImage:nil];
  tbc.tabBar.tintColor = [UIColor colorWithHue:.6 saturation:.8 brightness:.96 alpha:1.0];
  tbc.viewControllers = @[navController, diseaseNavController];
  [tbc setModalTransitionStyle:UIModalTransitionStylePartialCurl];

  [self.window setRootViewController:tbc];
  return YES;
}

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
  [color setFill];
  [rPath fill];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although
      // it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Nomad_Clinic_Health_Records" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }

  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

  int dbNum = 0;
  NSString* storeFilename = [NSString stringWithFormat:@"Nomad_Clinic_Health_Records-%d.sqlite", dbNum];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFilename];

  while (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    dbNum++;
    storeFilename = [NSString stringWithFormat:@"Nomad_Clinic_Health_Records-%d.sqlite", dbNum];
    storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFilename];
  }

  return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
