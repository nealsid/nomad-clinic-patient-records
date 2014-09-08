//
//  Utils.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/15/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDate*)dateFromMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year {
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:day];
  [comps setMonth:month];
  [comps setYear:year];
  NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDate *date = [cal dateFromComponents:comps];
  return date;
}

+ (NSString*) dateToMediumFormat:(NSDate*) d {
  static NSDateFormatter* dateFormatter;
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
  }
  return [dateFormatter stringFromDate:d];
}

@end
