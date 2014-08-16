//
//  TableViewDelegate.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/15/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger numberOfRows;

/**
 * Returns true if the rowNumber represents the last row in the table view.
 * Note that this is 1 more than the number of elements in Patients because
 * we provide a row that indicates "No more patients" at the bottom, so this
 * test is frequently done to determine if the user can perform some action on
 * a row.
 *
 * @param rowNumber the Row Number to test whether is last.
 * @returns YES if it's the last row in the table view, NO if not.
 */
- (BOOL) isLastRow:(NSInteger)rowNumber;

@end
