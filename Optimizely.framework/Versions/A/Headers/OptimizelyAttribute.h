//
//  OptimizelyAttribute.h
//  Optimizely
//
//  Created by Joshua H. Wang on 5/2/16.
//  Copyright © 2016 Optimizely Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class contains the data associated with an Optimizely Attribute.
 * You can choose to access various properties of the Attribute to debug or send offline conversions.
 * This class replaces Optimizely Dimension from version 1.4.2.
 */
@interface OptimizelyAttribute : NSObject <NSCopying>

/** The unique identifier for the attribute */
@property (nonatomic, readonly, strong) NSString *attributeId;

/** The value of the attribute */
@property (nonatomic, readonly, strong) NSString *attributeValue;

/** A unique name to refer to this attribute when tracking data in a client-side API call
 * May be null
 */
@property (nonatomic, readonly, strong) NSString *attributeApiName;

/** The segment Id used for offline conversions */
@property (nonatomic, readonly, strong) NSString *segmentId;

@end
