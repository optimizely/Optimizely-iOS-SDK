//
//  OptimizelyDimension.h
//  Optimizely
//
//  Created by Optimizely on 2/18/16.
//  Copyright © 2016 Optimizely Engineering. All rights reserved.
//

/**
 * This class represents the data about an individual dimension.
 * You can choose to access various properties dimension to debug or send offline conversions.
 */
@interface OptimizelyDimension : NSObject

/** The name of the dimension **/
@property (nonatomic, readonly, strong) NSString *dimensionName;

/** The unique identifier for the dimension **/
@property (nonatomic, readonly, strong) NSString *dimensionId;

/** The value of the dimension **/
@property (nonatomic, readonly, strong) NSString *dimensionValue;

/** A description of the dimension
 * May be null
 */
@property (nonatomic, readonly, strong) NSString *dimensionDescription;

/** A unique name to refer to this dimension when tracking data in a client-side API call
 * May be null
 */
@property (nonatomic, readonly, strong) NSString *dimensionAPIName;


@end
