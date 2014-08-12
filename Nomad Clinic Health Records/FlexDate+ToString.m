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

  if (self.year && self.month) {
    return [NSString stringWithFormat:@"%@/%@", self.month, self.year];
  }

  if (self.year) {
    return [NSString stringWithFormat:@"%@", self.year];
  }

  return @"";
}


@end
