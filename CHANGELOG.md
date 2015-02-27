# Optimizely-iOS-SDK CHANGELOG

## 1.0.78
February 26, 2015

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Goals are now triggered based on whether or not the user has ever viewed a given experiment in their lifetime
- Added notification for when a goal is triggered
- Added allExperiments and viewedExperiments which return an array of OptimizelyExperimentData objects that store data pertaining to the current state of each experiment
- Updated our analytics integrations to utilize viewedExperiments
- Added the ability for the developer to disable the Optimizely Gesture
- Removed session and retention goals
- activeExperiments deprecated, please use allExperiments or viewedExperiments

## 1.0.76
February 11, 2015

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Urgent fix for an issue with counting visitors in experiments. For more information please visit our [Optiverse page](https://community.optimizely.com/t5/Mobile-Apps/Known-Issue-Mobile-results-are-over-counting-visitors/m-p/9096)
- Added manual activation through refreshExperimentData
- Added notifications for when an experiment is viewed and when we load new experiment data
- Other minor bug fixes

## 1.0.75
January 14, 2015

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Added a NSNotification for when we get new experiment data
- Fixed a bug with downloading our JSON config

## 1.0.74
January 8, 2015

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Added the ability to edit UIButton images
- Enabled editing of individual table view cells
- Better interactions with other SDKs
- The Optimizely SDK will work with iOS6+ devices, but experiments will only run on iOS7+
- Other bug fixes

## 1.0.70
December 5, 2014

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Added the ability to black list views classes from Id generation
- Fix for scroll view delegate bug

## 1.0.60
November 19, 2014

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Fix a crash for some uses of UIImagePickerController

## 1.0.59
November 17, 2014

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Disable automatic tagging of UITableView and UICollectionView sub views.

## 1.0.58
November 17, 2014

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- Optimizely for iOS is out of beta!
- Adds support for Universal User ID (beta). Target experiments to identified users, and variation bucketing + counting will be consistent across multiple iOS devices. [Learn More](http://developers.optimizely.com/ios/#uuid)
- Default tracking of session frequency and length for all new experiments
- Revenue goals 
- New retention reports
- New goal metrics 
- New Visual Editor: Optimizely now has a brand new visual editor that makes it easy to create your A/B tests
- Removed the need for `OptimizelyPrepareNibs.rb`. you no longer need to run this script to use the visual editor
- New gesture for entering into Edit Mode: just draw the Optimizely O to get into edit mode
- Optimizely URL Scheme is now required for edit mode
- Fixed bugs found in 0.8.57


## 0.8.57
November 10, 2014

**Optimizely versions 0.8 (and up) require iOS 7 or higher.**

- New Visual Editor: Optimizely now has a brand new visual editor that makes it easy to create your A/B tests.
- Removed the need for `OptimizelyPrepareNibs.rb`. you no longer need to run this script to use the visual editor.
- New gesture for entering into Edit Mode: just draw the Optimizely O to get into edit mode
- Optimizely URL Scheme is now required for edit mode

## 0.7.55
September 16, 2014

- Image uploading: you can now upload new images in the Optimizely editor and swap
  them in variations
- Added support for changing  UIImageView's `contentMode` property when changing
  images in a variation
- Added callbacks for live variables so that a developer can be notified when live
  variables are updated
- Fixed a bug with MixPanel integration

## 0.7.54
August 22, 2014

- Google Analytics Integration! You can now send information about active
  experiments and variations to Google Analytics via our new integration
  with Universal Analytics!
- Surface Experiment and Variation Descriptions to developer via the
   `activeExperiments` property
- Fixed a bug where changing button text animated the change

## 0.7.53
August 5, 2014

- New traffic allocation support for bucketing less than 100% of users
- Improved robustness of startOptimizely for use with older XCode projects
- Various bug fixes and performance enhancements
- Improved debugging of custom goals

## 0.6.52
July 15, 2014

- Option to reload experiments on app foregrounding. [Learn More](http://developers.optimizely.com/ios/help/html/Classes/Optimizely.html#//api/name/shouldReloadExperimentsOnForegrounding).
- Ability to target experiments based on custom tags. [Learn More](http://developers.optimizely.com/ios/#customtags).
- Improved `OptimizelyPrepareNibs.rb` script which replaces `OptimizelyPrepareNibs.py` and plays nicely with source control. **Note: For manual installs, please follow steps 5 and 6 in the [manual install process](http://developers.optimizely.com/ios/#manualinstall) to upgrade to this new script.**

## 0.5.51
July 3, 2014

- New Live Variables and Code Blocks syntax which allows instantaneous discovery in
  the Editor. The prior syntax is now deprecated but will be supported in future
  SDKs for at least 6 months. [Learn More](http://developers.optimizely.com/ios/#variables).
- Optimizely now integrates with Mixpanel! [Learn More](http://developers.optimizely.com/ios/help/html/Classes/Optimizely.html#//api/name/activateMixpanelIntegration).
- The currently active experiments (and the variation for each experiment
  that the user is bucketed in) are now available as a property of the
  Optimizely singleton. [Learn More](http://developers.optimizely.com/ios/help/html/Classes/Optimizely.html#//api/name/activeExperiments).
- Option to specify data file download timeout. [Learn More](http://developers.optimizely.com/ios/help/html/Classes/Optimizely.html#//api/name/networkTimeout).

## 0.5.48

June 13, 2014

- Fixes constraint conflict when status bar is hidden

## 0.5.47

June 12, 2014

- Internal logging improvements.
- Fixes a bug where Code Blocks weren't applied in Edit Mode 
  (now they work like Live Variables - you don't have to use 
  Preview to see the changes).
- Fixes slowness in the Editor due to unnecessary socket messages 
  using Live Variables.

## 0.5.46

June 09, 2014

- Fixes a bug where the app was not receiving messages from the editor when launched from a URL instead of from Xcode.

## 0.5.45

May 27, 2014

- Fixes a bug related to app backgrounding.
- Fixes a bug where not calling +startOptimizely leaves variables nil rather than the defaultValue.
- Fixes bug related to visitor segmenting.

## 0.5.44

May 21, 2014

- Launch edit mode from URL
- Secured entering preview mode via URL
- Fix "Unknown App" issue
- Bug fixes, enhancements
- Fixes discrepancy between published SDK version and SDK version used for targeting (they are now one and the same).

## 0.4.42

May 5, 2014

- Changes default background event flush timer to every 2 minutes; adds a flag to change this value (timer was 20 minutes in SDK 0.4.37, which caused results delays for some apps; previously, a flush would only occur after an app had been active for at least 20 minutes and in the foreground, or after 25 events queued up)
- Adds manual event flush capability
- Adds manual experiment fetch capability (trigger fetches of experiment changes to be applied on next app start)
- Adds verbose logging option
- To target this SDK in an experiment, please target SDK version "0.4.42". This discrepancy will be fixed in an upcoming release.

## 0.4.37

April 25, 2014

- iOS 6 fixes
- Improved preview mode
- Simplified variables
- Numerous bugfixes
- To target this SDK in an experiment, please target SDK version "0.3.37". This discrepancy will be fixed in an upcoming release.

## 0.4.32

April 7, 2014

- Numerous bugfixes, including fix for issue where visitors are bucketed incorrectly.
- To target this SDK in an experiment, please target SDK version "0.3.32". This discrepancy will be fixed in an upcoming release.

## 0.3.0

Initial Developer Preview Release
