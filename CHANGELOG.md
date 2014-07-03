# Optimizely-iOS-SDK CHANGELOG

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
