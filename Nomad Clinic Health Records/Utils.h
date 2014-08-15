//
//  Utils.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/15/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDate*)dateFromMonth:(NSInteger)month
                     day:(NSInteger)day
                    year:(NSInteger)year;

@end
