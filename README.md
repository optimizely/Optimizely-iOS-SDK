# Optimizely for iOS

[![Version](http://cocoapod-badges.herokuapp.com/v/Optimizely-iOS-SDK/badge.png)](http://cocoadocs.org/docsets/Optimizely-iOS-SDK)
[![Platform](http://cocoapod-badges.herokuapp.com/p/Optimizely-iOS-SDK/badge.png)](http://cocoadocs.org/docsets/Optimizely-iOS-SDK)

## Developer Preview

This is a preview release of our iOS product. Our objective is to get feedback on the product and improve it prior to public launch. Your [feedback](mailto:mobile-support@optimizely.com) is critical and will help us shape the future of this product!

While we have taken every effort to test and ensure that our SDK works in a variety of apps, there may still be bugs in our preview release. Please read the Technical Overview before submitting your app to the App Store with the Optimizely SDK.

## Requirements
We support all build targets for iOS 6.0 and above.

## Getting Started

To install Optimizely, please refer to our [Quick Start Guide](Documentation/QuickStart-Guide).

## Technical Overview
Optimizely for iOS works similarly to Optimizely on the web: after you create an experiment in our Editor, an experiment config is generated and uploaded to our global CDN.

The Optimizely SDK downloads experiment configs in the background, validates, then executes any new experiments on next app load (i.e. after the application has been terminated by the OS or the user).

At initialization time, Optimizely will process the experiment config at the beginning of your app session for up to 2 seconds. This ensures a user of your app will only ever see one variation in an experiment and all experiments will activate, even those affecting the first screen of your app. We use the `vendorIdentifier` similarly to a 1st-party cookie on the web to identify and bucket users.

We have tested the client SDK in a number of apps, and believe that it is robust to most common failure scenarios.  Additionally, the SDK has a built in 'kill switch' - if you pause/delete all running experiments in your project, the config file read by the SDK from our CDN on its next pass will be empty and the SDK won't execute.

Please test every variation you create using the Preview functionality in the web editor before starting an experiment on a live app.

## Pricing
iOS is included on all Silver, Gold, and Platinum Optimizely plans during our developer preview; experiments will count against your Monthly Unique Visitor allotment, as they do for web experiments.

After public launch we reserve the right to charge separately for the iOS service. We will let you continue to use the alpha version of the product until some reasonable time after public launch to give you a chance to migrate to the public SDK once available.

## Support and Feedback
We want your feedback! For any and all questions, comments, or kudos, please get in touch with us at [mobile-support@optimizely.com](mailto:mobile-support@optimizely.com)

## Legal
By using this SDK and the account provided to you, you agree to abide by the [Optimizely Terms of Service](http://optimizely.com/terms).
