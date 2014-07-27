//
//  NEMRImageTransformer.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/19/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "NEMRImageTransformer.h"

@implementation NEMRImageTransformer

+ (Class) transformedValueClass {
  return [NSData class];
}

- (id) transformedValue:( id) value {
  if (! value) {
    return nil;
  }
  
  if ([ value isKindOfClass:[ NSData class]]) {
    return value;
  }
  
  return UIImagePNGRepresentation( value);

}

- (id) reverseTransformedValue:( id) value {
  return [UIImage imageWithData:value];
}

@end