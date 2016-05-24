//
//  OptimizelyDimension.h
//  Optimizely
//
//  Created by Optimizely on 2/18/16.
//  Copyright © 2016 Optimizely Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class contains the data associated with a dimension.
 * You can choose to access various properties dimension to debug or send offline conversions.
 */
@interface OptimizelyDimension : NSObject

#pragma mark -- deprecated fields --

/** The unique identifier for the dimension */
@property (nonatomic, readonly, strong) NSString *dimensionId __attribute((deprecated("This property will be removed in SDK 1.6")));

/** The value of the dimension */
@property (nonatomic, readonly, strong) NSString *dimensionValue __attribute((deprecated("This property will be removed in SDK 1.6")));

/** A unique name to refer to this dimension when tracking data in a client-side API call
 * May be null
 */
@property (nonatomic, readonly, strong) NSString *dimensionAPIName __attribute((deprecated("This property will be removed in SDK 1.6")));

/** The segment Id used for offline conversions */
@property (nonatomic, readonly, strong) NSString *segmentId __attribute((deprecated("This property will be removed in SDK 1.6")));

/** The name of the dimension **/
@property (nonatomic, readonly, strong) NSString *dimensionName __attribute((deprecated("This property will be removed in SDK 1.6")));

/** A description of the dimension
 * May be null
 */
@property (nonatomic, readonly, strong) NSString *dimensionDescription __attribute((deprecated("This property will be removed in SDK 1.6")));

@end
