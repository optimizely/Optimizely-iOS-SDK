# Optimizely for iOS Developer Preview

This is a preview release of our iOS product. Our objective is to get feedback on the product and improve it prior to public launch. Your [feedback](mailto:mobile-support@optimizely.com) is critical and will help us shape the future of this product!

While we have taken every effort to test and ensure that our SDK works in a variety of apps, there may still be bugs in our preview release. Please read the Technical Overview before submitting your app to the App Store with the Optimizely SDK.

## Requirements
We support all build targets for iOS 6.0 and above.

## Getting Started

To install Optimizely, please refer to our **[Quick Start Guide](http://developers.optimizely.com/ios/)**.

## Technical Overview
Optimizely for iOS works similarly to Optimizely on the web: after you create an experiment in our Editor, an experiment config is generated and uploaded to our global CDN.

The Optimizely SDK downloads experiment configs in the background, validates, then executes any new experiments on next app load (i.e. after the application has been terminated by the OS or the user).

Optimizely will display your splash screen while it downloads and processes the experiment config from our global CDN. Our CDN is [very fast](http://blog.optimizely.com/2013/12/11/why-cdn-balancing/) and this process usually completes quite quickly. The download times out after 2 seconds; if so, no experiments are activated. This ensures a user of your app will only ever see one variation in an experiment and all experiments will activate. We use the `vendorIdentifier` similarly to a 1st-party cookie on the web to identify and bucket users.

We have tested the client SDK in a number of apps, and believe that it is robust to most common failure scenarios.  Additionally, the SDK has a built in 'kill switch' - if you delete or archive all running experiments in your project, the config file read by the SDK from our CDN on its next pass will be empty and the SDK won't execute.

**Please test every variation you create using the Preview functionality in the web editor before starting an experiment on a live app.**

## Known Issues

- When using Optimizely to replace a dynamically-rendered image, the new image might not consistently render while using the Editor. Please use Preview to test how the replaced image will render in production.

## Pricing
iOS is included on all Silver, Gold, and Platinum Optimizely plans during our developer preview; experiments will count against your Monthly Unique Visitor allotment, as they do for web experiments.

After public launch we reserve the right to charge separately for the iOS service. We will let you continue to use the alpha version of the product until some reasonable time after public launch to give you a chance to migrate to the public SDK once available.

## Support and Feedback
We want your feedback! For any and all questions, comments, or kudos, please get in touch with us at [mobile-support@optimizely.com](mailto:mobile-support@optimizely.com)

## Legal
By using this SDK and the account provided to you, you agree to abide by the [Optimezely iOS Beta Terms of Service](http://developers.optimizely.com/ios/terms).
