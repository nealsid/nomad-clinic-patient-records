//
//  FieldEditDelegate.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitFieldMetadata.h"

@protocol FieldEditDelegate <NSObject>

- (void) newFieldValuesFieldMetadata:(NSDictionary*)visitFieldMetadata
                              value1:(NSNumber*) newValue
                              value2:(NSNumber*)newValue2;

- (void) newStringFieldValueFieldMetadata:(NSDictionary*) visitFieldMetadata
                                    value:(NSString*) newValue;
@end
