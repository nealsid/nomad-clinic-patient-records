//
//  FieldEditDelegate.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FieldEditDelegate <NSObject>

- (void) newFieldValue:(NSNumber*) newValue;

@end
