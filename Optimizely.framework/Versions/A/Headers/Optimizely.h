//
//  Copyright (c) 2014 Optimizely. All rights reserved.
//
//  Optimizely iOS SDK Uses Following Open Source Libraries
//       - AFDownloadRequestOperation
//       - AFNetworking
//       - CTObjectiveCRuntimeAdditions
//       - FMDB
//       - NSDateRFC1123
//       - SocketRocket
//
//  Contributors
//       - Kasra Kyanzadeh
//       - Yonatan Kogan
//       - Marco Sgrignuoli
//       - Richard Klafter
//       - Alex Medearis
//       - Chrix Finne
//       - Rama Ranganath
//       - Hemant Verma

typedef void (^OptimizelySuccessBlock)(BOOL success, NSError *error);

@interface UIView (Optimizely)
@property NSString *optimizelyId;
@end

/** This class defines the entire interface with the Optimizely SDK
 *
 * The Optimizely SDK is organized around a Singleton, accessible via
 * the `+sharedInstance` method. Through this singleton, you can mark variables
 * or assets as available for experimentation, track custom goals, or __(Coming Soon!)__
 * run experiments through code blocks.
 */
@interface Optimizely : NSObject {
}

/** @name Initialization */

/** This method provides access to the Optimizely singleton
 *
 * @return The Optimizely Singleton
 */
+ (instancetype)sharedInstance;

/** Calling this activates the Optimizely framework. If this isn't called, the app will behave
 * as though Optimizely wasn't included. Any configuration should be done before this is called.
 *
 * @param apiToken The apiToken of your iOS project on Optimizely.
 * @param launchOptions A dictionary of launch options. This is typically the variable
 * passed into `-application: didFinishLaunchingWithOptions:`. TODO: Options for launchOptions
 */
+ (void)startOptimizelyWithAPIToken:(NSString*)apiToken launchOptions:(NSDictionary *)launchOptions;

/** Calling this activates the Optimizely framework. If this isn't called, the app will behave
 * as though Optimizely wasn't included. Any configuration should be done before this is called.
 *
 * @param apiToken The apiToken of your iOS project on Optimizely.
 * @param launchOptions A dictionary of launch options. This is typically the variable
 * passed into `-application: didFinishLaunchingWithOptions:`. TODO: Options for launchOptions
 * @param experimentsLoadedCallback A block that will be executed when the Optimizely framework
 * has activated any experiments that pass targeting.
 * @discussion If no data file has been cached (e.g. if
 * this is the first launch) then the experimentsLoadedCallback will not be called until
 * the latest experiments file has been downloaded from the server.
 * If the device is in edit mode, the callback will execute immediately.
 */
+ (void)startOptimizelyWithAPIToken:(NSString *)apiToken
                      launchOptions:(NSDictionary *)launchOptions
          experimentsLoadedCallback:(OptimizelySuccessBlock)experimentsLoadedCallback;

/** This method makes the device available to the Optimizely web editor
 *
 * This method makes it more convenient for a developer to set up an experiment. The only other way
 * to connect a device to the web editor is by opening the app through the appropriate
 * custom URL, accessible from the matching Optimizely project.
 *
 * @warning This method should only be called behind an `#ifdef DEBUG` flag. Otherwise
 * any device running the app could be altered from the web editor.
 * @warning Should only be called before `+(void)startWithProjectId:(NSString*)projectId launchOptions:(NSDictionary *)launchOptions;`.
 */
+ (void)enableEditor;

/** This method deactivate the features that require swizzling.
 *
 */
+ (void)disableSwizzle;

/** @name Events and Goal Tracking */

/** This method immediately starts a network request that sends tracked events 
 * back to Optimizely and fetches the newest experiment data file.
 *
 * This is the same as calling dispatchEvents followed by fetchNewDataFile.
 *
 * Events are automatically flushed at regular intervals by the SDK. This method exists
 * so that the Optimizely SDK can piggy-back on an already activated radio. This can save
 * battery by reducing the number of times the radio is turned on/off.
 *
 * See dispatchInterval to change the frequency of auto dispatch (events and new data file).
 */
+ (void)dispatch;

/** Manually send events to Optimizely
 */
+ (void)dispatchEvents;

/** Manually fetch new data file from Optimizely
 */
+ (void)fetchNewDataFile;

/** This method informs the server that a custom goal with key `description` occured
 *
 * Use this method to let Optimizely know that a custom goal occured. Events are sent in batches
 * to reduce radio/battery usage, so use `-flushEvents` if you want to schedule the request
 * yourself or want to take advantage of a time when the radio is already on.
 * @param description The string uniquely identifying the custom goal you want to track
 * @see -dispatch
 */
- (void)trackEvent:(NSString *)description;

#pragma mark - Variable getters
/** @name Experiment Variables */

/** This method registers an NSString so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;

/** This method registers an UIColor so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (UIColor*)colorForKey:(NSString*)key defaultValue:(UIColor*)defaultValue;

/** This method registers an NSNumber so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (NSNumber*)numberForKey:(NSString*)key defaultValue:(NSNumber*)defaultValue;

/** This method registers an CGPoint so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (CGPoint)pointForKey:(NSString*)key defaultValue:(CGPoint)defaultValue;

/** This method registers an CGSize so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (CGSize)sizeForKey:(NSString*)key defaultValue:(CGSize)defaultValue;

/** This method registers an CGRect so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (CGRect)rectForKey:(NSString*)key defaultValue:(CGRect)defaultValue;

/** This method registers a BOOL so that it can be changed via the Optimizely web editor
 *
 * @param key A key uniquely defining the variable
 * @param defaultValue The value this variable should take on in the absence of an
 * experimental change
 * @return The value of this variable in the active experiment (default if no active experiment)
 */
- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue;

#pragma mark - Code Tests
/** @name Code Tests */

/** This method allows you to set up a code block based experiment
 
 [[Optimizely sharedInstance] codeTest:@"checkout flow" withBlocks:@{
 @"skip signup": ^{
 [self showConfirmation];
 },
 @"free shipping": ^{
 order.shippingCost = 0;
 },
 }
 defaultBlock:^{
 [self showSignup];
 }];
 
 @param codeTestKey A unique key that describes this test
 @param blocks A dictionary that maps descriptive NSString keys to (void (^)(void)) blocks for each
 variation of this test.
 @param defaultBlock This block will be executed if no active experiment involves this code test.
 */
- (void)codeTest:(NSString*)codeTestKey
      withBlocks:(NSDictionary*)blocks
    defaultBlock:(void (^)(void))defaultBlock;

#pragma mark - Properties

/** NSString property that is your project Id */
@property (readonly,strong) NSString *projectId;

/** NSString property that is the current SDK version */
@property (readonly,strong) NSString *sdkVersion;

/** Optional NSString property that is the current app version
 We default this value from bundle if not provided */
@property (nonatomic,strong) NSString *appVersion;

/** Using this you can set the user id idenifying this user
 * This is optional, the default value is vendor id
 */
@property (nonatomic,strong) NSString *userId;

/** Optional Output more verbose logs, helps in debugging 
 * Optimizely related issues 
 */
@property (nonatomic) BOOL verboseLogging;

/**The frequency (in seconds) at which new events are sent and experiment
 * data file is fetched from server. (default value is 2 minutes)
 *
 * Setting this to zero or negative value will disable automatic sending 
 * of events and you will have to manually dispatch events and fetch new data file 
 * using dispatch or dispatchEvent / fetchNewDataFile.
 */
@property (nonatomic) NSTimeInterval dispatchInterval;

@end
