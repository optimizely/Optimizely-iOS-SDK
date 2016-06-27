# 1.6.0
June 27, 2016

*New Features:*

* **Enhanced Preview Mode:** Aside from a new look, the enhanced Preview mode allows you to select multiple variations from different experiments and enable them at the same time. A new API also allows you to enable preview mode programmatically without having to go through the web client. 

* **New APIs:**
    * Enter Preview mode programmatically without having to go through the web client:
    ```[Optimizely enablePreview]```

    * Restart app after reseting user bucketing info, so that at relaunch the user will be in her new bucketed state:
    ```[Optimizely resetUserBucketingAndRestartApp]```. This API can be called any time during the app's lifecycle.

*Bug Fixes:*

* Fixed warning from Optimizely Umbrella Header not importing OptimizelyDimension.h.
* Optimizely File Manager class is not dependent on a Singleton anymore. Avoids errors in initialization.

# 1.5.0
May 23, 2016

*New Features:*

* **Optimizely Attributes:** You can now create Optimizely Attributes for iOS in the project dashboard. These attributes can be used to segment results on the results page and for audience targeting. New APIs to get and set the value for attributes have been created. More details can be found [here](https://help.optimizely.com/Target_Your_Visitors/Mobile_Attributes).

  * You can set an attribute’s value by using either ```[Optimizely setValue:(NSString *)value forAttributeId:(NSString*)attributeId]``` or ```[Optimizely setValue:(NSString *)value forAttributeApiName:(NSString *)attributeApiName].```
  * You can get an attribute’s current value by using either ```[Optimizely getAttributeValueForAttributeId:(NSString *)attributeId] ``` or ```[Optimizely getAttributeValueForAttributeApiName:(NSString *)attributeApiName].```
  * You can get a copy of all attributes by calling [Optimizely getAttributes]. This replaces the previous ``` [Optimizely getDimensions] ``` call.

* **New Headers:**
OptimizelyAttribute.h - Represents an Optimizely Attribute. Read more about Optimizely Attributes [here](https://help.optimizely.com/Target_Your_Visitors/Mobile_Attributes)

* **New APIs:**
Added an API to access the Optimizely running mode:
 ```[Optimizely sharedInstance].runningMode.```

*Bug Fixes:*

* Fixed sending Localytics Name + Variation without parenthesis.
* Fixed memory leak caused by not releasing an allocated memory in a non-arc source file.
* Improved editor stability.
* Refactored kill switch file retrieval to reduce Optimizely startup time.

*Deprecations:*

* ```[Optimizely getDimensions]``` is now deprecated. Please use ```[Optimizely getAttributes]```.
* OptimizelyDimension.h: This class is now deprecated. Please use Optimizely Attribute.

# 1.4.2
March 9, 2016

*Bug Fixes:*

* We made a merge error and the internal version is 1.4.2 instead of 1.4.0. We are trying to make all affected files consistent with 1.4.2 since customers are already using 1.4.2.

# 1.4.1
Skipped

# 1.4.0
February 25, 2016

*New Features:*

  * *Plugins Rearchitecture:* We've spent some time thinking about how Optimizely can integrate with other plugins. We want to enable 3rd parties to build point solutions that leverage Optimizely's platform in new ways.
    * `[Optimizely registerPlugin:(id<OptimizelyPlugin>) plugin]` - register a plugin.
    * Use this method if your app is in Swift instead of `[Optimizely activateAmplitudeIntegration]`, `[Optimizely activateLocalyticsIntegration]`, or `[Optimizely activateMixpanelIntegration]`.
    * If are using a custom Plugin in Objective-C, use the `OptimizelyRegisterPlugin` macro from OptimizelyPlugin.h
  * *Developer Improvements:* We want to enable customers to use the [offline conversions](https://help.optimizely.com/hc/en-us/articles/200040195-Tracking-offline-conversion-events-with-Optimizely) API to its full potential, so we've exposed essential parameters needed to send offline conversion events.
    * `[Optimizely getDimensions]` - get an NSArray of all OptimizelyDimensions in the SDK.
    * `[Optimizely sharedInstance].universalUserId` - your custom Universal User Id for the end user. Set the universalUserId to identify the end user across devices. More info can be found [here](https://help.optimizely.com/hc/en-us/articles/203626830-Universal-User-ID-Beta)
    * `[Optimizely sharedInstance].optimizelyEndUserId` - read only property to get the Optimizely End User Id created by the Optimizely SDK.
  * *New Headers:*
    * OptimizelyDimension.h - A representation of the data in an individual Optimizely Dimension. Read more about Dimensions [here](https://help.optimizely.com/hc/en-us/articles/200040865-Dimensions-Capture-visitor-data-through-the-API).
    * OptimizelyPlugin.h - Integrations allow customers to track Optimizely experiments in an external tool. A plugin written on the Optimizely platform can edit views, live variables, and code blocks. [Read more](http://developers.optimizely.com/integrations/#mobile-analytics).

*Bug Fixes:*

* Fixed an issue with tracking revenue goals with an empty string description.

*Deprecated Methods:*

* `[Optimizely sharedInstance].userId` is now deprecated. Please use either `universalUserId` or `optimizelyEndUserId` instead.

*Breaking Changes:*

* *Optimizely Plugins:* These methods are no longer needed to activate the Optimizely Integrations. The integrations must be activated from the web editor by flipping them to the ON position. Read more about integrations [here](https://help.optimizely.com/hc/en-us/articles/203729580-Introduction-to-Optimizely-Integrations).
  * [`[Optimizely activateAmplitudeIntegration]`](https://help.optimizely.com/hc/en-us/articles/204963198-Integrating-Optimizely-with-Amplitude-for-iOS-and-Android) - activate the Amplitude integration via the Integrations tab in the web editor.
  * [`Optimizely activateLocalyticsIntegration]`](https://help.optimizely.com/hc/en-us/articles/209645787-Integrating-Optimizely-with-Localytics-for-iOS-and-Android) - activate the Localytics integration via the Integrations tab in the web editor.
  * [`[Optimizely activateMixpanelIntegration]`](https://help.optimizely.com/hc/en-us/articles/200040025-Integrating-Optimizely-with-Mixpanel-Web-iOS-and-Android-) -  activate the Mixpanel integration via the Integrations tab in the web editor.

# 1.3.2
November 20, 2015

**Optimizely will no longer support Xcode 6**

*Bug Fixes:*
- Fixed a bug with preview mode and visual experiments

# 1.3.1
November 10, 2015

**Optimizely will no longer support Xcode 6**

*Bug Fixes:*
- Fixed issue when archiving with the SDK

# 1.3.0
November 6, 2015

*Announcements:*
*Twitter Fabric Integration.* We're excited to announce our partnership with Fabric, Twitter's modular mobile platform that makes it easy for developers to install and maintain SDKs within their apps. Find out more [here](https://blog.optimizely.com/2015/10/21/optimizely-twitter-fabric/)

*New Features:*
- *Developer Improvements.* We've added a litany of testing methods to our SDK to help you debug your experiments much more quickly and easily
  - isUserInAudience - Check if the user is in a particular audience
  - getExperimentDataById - Get an experiment's metadata with that experiment's ID
  - resetUserBucketing - Remove a user's bucketing information for all experiments
  - forceVariationOfExperiment - Force a user into a certain experiment variation
Read more in-depth descriptions [here](/ios/reference/index.html#debugging-your-experiments)
- *Manual activation.* You can now manually specify, in code, when you want your experiments to activate (by default, all active experiments are activated when start Optimizely is called). Some important use cases include setting additional targeting metadata before activating an experiment and only bucketing users who visit a certain activity in your app
Read more in-depth descriptions [here](/ios/reference/index.html#experiment-activation-modes)
- *New notification types:*
  - OptimizelyFailedToStartNotification
  - OptimizelyStartedNotification
- *Code Block Callbacks in Edit Mode.* Please note that code block callbacks will only work in edit mode

*Bug Fixes:*
- Fixed bug in language Audience condition

# 1.2.2
October 12, 2015

*Bug Fixes*
- Fixed more warnings in Xcode 7

# 1.2.1
October 6, 2015

*Bug Fixes*
- Fixed warnings stemming from Xcode 7 and static libraries
- Re-added armv7s which was removed by default in Xcode 7

# 1.2.0
October 5, 2015

*New Features*
- *Audience targeting.* Improve your app’s retention by creating audiences of similar users and targeting them with relevant content.
- *Connection-free changes.* Make changes to Live Variables and Code Blocks without connecting your device to Optimizely.
- *Streamlined goal setting.* Save time during instrumentation with a faster and more accurate goal selection experience.
- *Multi-target goals.* Accurately test entirely different variations by connecting multiple view or tap events to a single goal.
- *Advanced preview and QA modes.* Release new features confidently with a rebuilt preview mode that allows you to simulate a live user experience in real time.
- *Localytics integration.* See the impact your Optimizely experiments have on the key business metrics you track using Localytics.
