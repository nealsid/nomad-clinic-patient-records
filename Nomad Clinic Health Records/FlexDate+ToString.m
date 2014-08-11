//
//  FlexDate+ToString.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/11/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "FlexDate+ToString.h"

@implementation FlexDate (ToString)

- (NSString*)toString {
  if (self.specificdate) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:self.specificdate];
  }
  if (self.minimum_year && !self.maximum_year) {
    return [NSString stringWithFormat:@"%@", self.minimum_year];
  }

  if (self.minimum_year && self.maximum_year) {
    return [NSString stringWithFormat:@"%@ - %@", self.minimum_year, self.maximum_year];
  }
  return @"";
}


@end
