//
//  OptimizelyExperimentData.h
//  Optimizely
//
//  Created by Optimizely on 2/19/15.
//  Copyright (c) 2015 Optimizely. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Type describing the current state of the experiment
 */
typedef NS_ENUM (NSUInteger, OptimizelyExperimentDataState) {
    /** Experiment is not running on the Optimizely dashboard. Try starting the experiment on https://www.optimizely.com */
    OptimizelyExperimentDataStateDisabled,
    /** Experiment is pending activation. Usually this means that you can now manually activate it through [Optimizely activateManualExperiment:] */
    OptimizelyExperimentDataStatePending,
    /** Experiment is running */
    OptimizelyExperimentDataStateRunning,
    /** Experiment has been deactivated
     * This can happen if
     * (a) not all of its assets are downloaded by the time our block time runs out, or
     * (b) another experiment has already been activated that makes a conflicting change
     * (c) targeting criteria for this experiment has not been met
     */
    OptimizelyExperimentDataStateDeactivated
};

/**
 *  This class represents the data for the current state of your Optimizely experiment object.
 *  You can choose to access various properties to figure out the current experiment state
 *  within Optimizely.
 */
@interface OptimizelyExperimentData : NSObject

/** Property that tells you the audiences currently associated with this experiment */
@property (nonatomic, readonly, strong) NSString *audiences;

/** Property that tells you the experiment Id */
@property (nonatomic, readonly, strong) NSString *experimentId;

/** Property that tells you the experiment Name */
@property (nonatomic, readonly, strong) NSString *experimentName;

/** Property that tells you whether or not your experiment is a manual activation experiment. */
@property (nonatomic, readonly) BOOL isManual;

/** Property that tells you whether or not your was locked out of activation, because another experiment
 *  was making a conflicting change or your assets did not finish downloading in time
 */
@property (nonatomic, readonly) BOOL locked;

/** Property that tells you the state of the experiment */
@property (readonly) OptimizelyExperimentDataState state;

/** Property that tells you the targeting conditions currently associated with this experiment */
@property (nonatomic, readonly, strong) NSString *targetingConditions;

/** Property that tells you whether or not your user has met targeting conditions */
@property (nonatomic, readonly) BOOL targetingMet;

/** Property that stores the dictionary representation of all variations associated with this experiment */
@property (nonatomic, readonly, strong) NSArray *variations;

/** Property that tells you the active variation Id (can be nil if not bucketed) */
@property (nonatomic, readonly, strong) NSString *variationId;

/** Property that tells you the active variation Name (can be nil if not bucketed) */
@property (nonatomic, readonly, strong) NSString *variationName;

/** Property that counts the number of times the user has seen this experiment */
@property (nonatomic, readonly) NSUInteger visitedCount;

/** Property that computes whether or not the user has seen this experiment in their lifetime */
@property (nonatomic, readonly) BOOL visitedEver;

/** Property that tells you whether or not the user has seen this experiment this session */
@property (nonatomic, readonly) BOOL visitedThisSession;

@end
