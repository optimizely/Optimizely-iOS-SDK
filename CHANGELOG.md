# Optimizely-iOS-SDK CHANGELOG

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