//
//  OptimizelyPlugin.h
//  Optimizely
//
//  Created by Josiah Gaskin on 9/17/15.
//  Copyright (c) 2015 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Optimizely;

/**
 * This protocol must be implemented by classes which wish to integrate with Optimizely
 * via the Plugin System. For more information on creating a plugin see our documentation:
 */
@protocol OptimizelyPlugin <NSObject>

/**
 * Required properties and methods to comply with the protocol
 */
@required

/**
 * Each plugin must have a unique identifier. The bundle name of the plugin is usually
 * sufficient. For example: 'com.optimizely.crashreporting'
 * This property will be queried after the plugin initialization but before start is called.
 */
@property(nonatomic, strong) NSString *pluginId;

/*
 * iOS plugins are expected to handle their own permission requests appropriately
 */

/**
 * Declare all dependencies on other plugins here. This selector will be queried
 * before start is called, but after initialization.
 * @return a list of plugin identifiers
 */
- (NSSet *)getDependencies;


/**
 * @return true if this plugin should receive and handle touch events. This selector
 * will be queried after start has been called.
 */
- (BOOL)shouldHandleTouchEvents;


/*
 * iOS plugins are expected to handle UIApplication* notifications as needed
 */


/**
 * iOS plugins can subscribe to the NSNotification center notifications for the Optimizely
 * notifications listed in Optimizely.h#NSNotification Keys
 */

/**
 * Initialize the plugin and start any listeners or threads.
 * @param optimizely A reference to the Optimizely singleton so that services can be accessed
 * @param config The config object for this plugin from the data file
 * @return true if the plugin was started successfully, false otherwise.
 */
- (BOOL)startWithOptimizely:(Optimizely *)optimizely withConfig:(NSDictionary *)config;

/**
 * Stop the extension and clean up any objects that are owned by the extension.
 */
- (void)stop;

/**
 * Optional properties and methods to implement
 */
@optional

/**
 * Declare all LiveVariable keys that this plugin wishes to modify. This selector
 * will be queried after start has been called. May return nil if this plugin
 * does not modify live variables.
 * @return a set of strings which correspond to the LiveVariable key names.
 */
- (NSSet *)getLiveVariables;

/**
 * Declare all CodeBlock keys that this plugin wishes to modify. This selector
 * will be queried after start has been called. May return nil if this plugin
 * does not modify code blocks.
 * @return a set of strings which correspond to the CodeBlock key names.
 */
- (NSSet *)getCodeBlocks;

/**
 * Evaluate the given live variable and return the value. The value must be
 * of the type denoted by cls. The default value should be returned if the plugin
 * does not care
 * @param cls the class of the expected type
 * @param key the name of the live variable
 * @param defaultValue the default value for the live variable
 * @return the calculated value for the live variable
 */
- (id)evaluateLiveVariableOfType:(Class)cls forKey:(NSString *)key defaultValue:(id)defaultValue;

/**
 * Evaluate the given code block and return the name of the branch that should
 * be executed. Nil may be returned if the plugin does not care.
 * @param key the name of the code block
 * @return the name of the branch to execute.
 */
- (NSString *)evaluateCodeBlockForKey:(NSString *)key;

/**
 * If shouldHandleTouchEvents returns true, touch events will be passed to the plugin.
 * This selector will be queried after start has been called.
 * @param event The event that the plugin will process
 */
- (void)processTouchEvent:(UIEvent *)event;

/**
 * Declare the dimension names that this plugin handles.
 * @return nil or a NSSet of dimension names
 */
- (NSSet *)dimensionNames;

/**
 * Evaluate a dimension name against it's condition.
 * @param dimensionName name of the condition to evaluate.  Useful for switching on the different dimension names supported
 *        by this plugin.
 * @param condition NSDictionary containing key value pairs used by the Optimizely dimension evaluator, i.e.:
 *        { "name: "skymosity.currentTemperature", "value": "10:60", "match_type": "range", "content_type" : "third_party_dimension" }
 * @return true if the condition passes for the given dimension name and false if it doesn't.
 */
- (BOOL)evaluateDimension:(NSString *)dimensionName withCondition:(NSDictionary *)condition;

@end

/**
 * Enable and register your plugin with the Optimizely runtime. This macro can be
 * included in your plugin library in order to automatically enable your plugin for
 * use with the Optimizely runtime.
 */
#define OptimizelyRegisterPlugin(classname) \
    static void __attribute__((constructor)) initialize_ ## classname() { \
        [Optimizely registerPlugin:[[classname alloc] init]]; \
    }
