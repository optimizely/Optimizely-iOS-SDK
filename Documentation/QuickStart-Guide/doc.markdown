# Optimizely iOS SDK Quickstart Guide

## Table of Contents

1. [Creating an Optimizely Project](#accountcreation)
2. [SDK Installation](#installation)
3. [Creating your first experiment](#quickstart)


## <a name="accountcreation"></a>Creating an iOS Project

To create an iOS project, select "Create New Project" in the [Optimizely Dashboard](https://www.optimizely.com/dashboard):

   <img src="create-project.png" alt="Drawing" style="width: 80%;"/>

Once you've created a project, please take a look at the `Project Code` dialog to find your project ID and API key which you will use during installation:

![Project Code Dialog](project-code.png)

## <a name="installation"></a>SDK Installation
To use Optimizely for iOS you must first integrate the SDK into your app. You can either install the Optimizely SDK using [CocoaPods](http://cocoapods.org) (recommended) or manually.

### Using CocoaPods

Refer to [CocoaPods Getting Started](http://cocoapods.org/#getstarted) if you haven't yet configured your project to work with CocoaPods.


1. Our SDK only supports iOS 6.0 and above, so please make sure your Podfile specifies a [deployment target](http://guides.cocoapods.org/syntax/podfile.html#platform) of iOS 6.0 (or above). Then, add Optimizely to your podfile:

        platform :ios, '6.0'

        # Other Pods 
		pod 'Optimizely-iOS-SDK', :git => 'git@github.com:optimizely/Optimizely-iOS-SDK.git'

2. Run `pod install` from the command line.  This will add and install the Optimizely iOS SDK in your generated CocoaPods workspace. *Note:* by default CocoaPods installs to the first build target in the project.

3. Now you're ready to write some code! Open your app's prefix header file: `MyApp-Prefix.pch` under 'Supporting Files' in a standard XCode project. Add the following line of code to the bottom:

		#import <Optimizely/Optimizely.h>

4 Add the following to the beginning of `application:didFinishLaunchingWithOptions:` in your
app delegate:

       		#ifdef DEBUG
            [Optimizely enableEditor];
            #endif
            
			[Optimizely startOptimizelyWithAPIToken:YOUR_API_TOKEN launchOptions:launchOptions];
					
            // The rest of your initialization code...

You can copy-paste your API token from the `Project Code` dialog within your Optimizely iOS project.

If you have trouble connectiong to the Optimizely Editor in your development environment, remove the `#ifdef DEBUG … #endif` flag and force-enable the editor (just don't ship your production app with the Editor enabled!)

### Manual Installation
0. Clone the Optimizely SDK using `git clone https://github.com/optimizely/Optimizely-iOS-SDK`

1. Drag `Optimizely.framework` from the SDK repository into your project. Check "Copy items into destination group's folder" and make sure the appropriate targets are checked.
    
2. Open the "Build Phases" tab for the app's target. Under "Link Binary with Libraries", add the required frameworks if they're not already included:
   * AdSupport.framework
   * CFNetwork.framework
   * Foundation.framework
   * libicucore.dylib
   * libsqlite3.dylib
   * Security.framework
   * SystemConfiguration.framework
   * UIKit.framework  

3. <a name="objc"></a>Switch to the "Build Settings" tab. Add `-ObjC` to the "Other Linker Flags" build setting.

4. Drag `scripts/OptimizelyPrepareNibs.py` from the SDK into the root of your project. Check "Copy items into destination group's folder" and **uncheck all targets**.
    
5. Open the "Build Phases" tab for the app's target. In the app menu (top of the screen) click "Editor" -> "Add Build Phase" -> "Add Run Script Build Phase". In the script field, write:

		python "$SRCROOT/OptimizelyPrepareNibs.py"

    You may need to modify this path if you added `OptimizelyPrepareNibs.py` to a different directory.
    
    This script needs to run at the start of the build process (right after Target Dependencies). To make sure this happens, drag the Run Script phase you just added to the top of the list of phases, just under "Target Dependencies". The final result should look something like this:
    
    ![Build Targets Screenshot](screenshot-run-build-phase.png)

6. Now you're ready to write some code! Open your app's prefix header file: `MyApp-Prefix.pch` under 'Supporting Files' in a standard XCode project. Add the following line of code to the bottom:

		#import <Optimizely/Optimizely.h>

7. Add the following to the beginning of `application:didFinishLaunchingWithOptions:` in your
app delegate:

			#ifdef DEBUG
	        [Optimizely enableEditor];
	        #endif

			[Optimizely startOptimizelyWithAPIToken:YOUR_API_TOKEN launchOptions:launchOptions];
						
    	    // The rest of your initialization code...
  
### External Dependencies
There are a few external libraries used by the Optimizely SDK. These ship with the Optimizely SDK so there is no need to install them separately.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking):
    used for making network requests.
- [AFDownloadRequestOperation](https://github.com/steipete/AFDownloadRequestOperation):
- [FMDB](https://github.com/ccgus/fmdb):
    Objective-C wrapper for sqlite.
- [SocketRocket](https://github.com/square/SocketRocket):
    used to communicate with the web editor over websockets.

## <a name="quickstart"></a>Creating your first experiment
This guide will walk you through setting up your first experiment using the Optimizley visual editor. If you are using Interface Builder or Storyboards, this is already available to you. However, if you are creating your views programmatically, jump ahead to [Optimizely Visual Editor](#visualeditor) and then return to this guide. 

### Setting up Variations
1. In the [Optimizely Application](http://optimizely.com/dashboard), select the project that you created at the start of the installation process and click "Create Experiment".

   <img src="editor-create-experiment.png" alt="Drawing" style="width: 100%;"/>

2. Once you have chosen a name and created the experiment, the editor begins waiting for a device to enter edit mode. If you haven't already, **run your app in DEBUG mode in the simulator or on a device**. You should see the device appear in the editor. If you don't, check out the troubleshooting section of this guide or [email support](mailto:mobile-support@optimizely.com).

   <img src="editor-select-device.png" alt="Drawing" style="width: 100%;"/>

3. Once you have connected your device, it's time to create a variation.

   <img src="editor-views.png" alt="Drawing" style="width: 100%;"/>  
   1. In your app, navigate to the screen on which you want to run an experiment.
   2. As you mouse over the different elements in the side bar, you should see them highlighted in the app.
   3. When you select the view element that you want to change, the right section of the screen should populate with the properties that you can change on that element.
   4. The change is immediately reflected in your app! Click save to commit your change(s) to the variation.

#### Previewing your variation
To simulate a user's experience when they are in a particular variation, you can use preview mode. Select the variation you want to see and click the 'Preview' button in the top right corner of the screen. This will cause the app to shut down. When you reopen the app, it will have all the changes you specified in your variation.

<img src="editor-preview-button.png" alt="Drawing" style="width: 100%;"/>

### Goals
All experiments must have at least one goal! We automatically track all view controller transitions and screen taps so that they can easily be used as goals. In order to select a particular transition or screen tap as a goal, open the "Goals" dialogue and click "New Goal" in the bottom right.

![Create Goal dialog](editor-add-goal.png)

On this screen, you will see all the view transitions and taps occurring in your app as you interact with it on your device. Select the one that you want to be your goal, give it a name, and click "Save". Optimizely will now track the percentage of your users in each variation that complete that action and the results will appear in our dashboard. If you're curious about the "Create Custom Goal Instead" button, jump ahead to [Custom Goals](#customgoals).

#### _Optional: Allocating Experiment Traffic_
By default, an equal percentage of your traffic will see each variation. If you want to change from the default, you can adjust the targeting allocation from the Options menu.

<img src="editor-traffic-allocation.png" alt="Drawing" style="width: 100%;"/>


## Advanced Testing Info
For additional information about any of the experimental approaches below, see the full [API Documentation](http://ios-preview.optimizely.com/Optimizely-iOS-SDK/Documentation/help/html/Classes/Optimizely.html).

### Optimizely Visual Editor <a name="visualeditor"></a>
The Optimizely editor becomes aware of views it can change from the visual editor by looking for views that have an `optimizelyId` property. When a view with an `optimizelyId` becomes visible in the app, the SDK alerts the web editor of its existence. The `OptimizelyPrepareNibs.py` script assigns an `optimizelyId` automatically to views created with Interface Builder or Storyboards. For automatically tagged views, the behavior will be as follows:

- Optimizely will assign randomly generated `optimizelyIDs` to each UIView prototype in your app; an example might be "MainView-w389gjw" using the OptimizelyPrepareNibs.py script.
- Each UIView will become available in the Optimizely Mobile Editor on [optimizely.com](www.optimizely.com).
- **Important**: Each instance of a UITableViewCell in a UITableView will have the same changes applied to it. *Please use the Preview functionality to verify this behavior before running your experiment.*

If you are creating views programmatically, you must set the `optimizelyId` manually:

    UILabel *label = [[UILabel alloc] initWithFrame:...];
    label.optimizelyId = @"pricing-title-label";

For any views that you want to adjust from the visual editor, you should give them a unique `optimizelyId`.	
### Code blocks

This allows developers to execute different code paths based on the active experiment and variation. Users will be randomly bucketed into a particular variation and the variationId passed into the block will reflect their bucket. This is the most powerful method for creating experiments, but requires the app to be resubmitted to the app store.

To implement, please see the [Code Blocks API Reference](http://ios-preview.optimizely.com/Optimizely-iOS-SDK/Documentation/help/html/Classes/Optimizely.html#//api/name/codeTest:withBlocks:defaultBlock:)

### Named variables

The values of named variables can be affected from the "Variables" tab in the editor. This tab shows all named variables **that have been used while the app is connected to the editor**. If a named variable is only used in a view that you have not visited yet, it will not appear in the list of named variables until you navigate to that view. There are three ways that the Optimizely editor becomes aware of variables it can change:

**Registered variables** are the explicit way of setting the value for variables. Variables are defined in the user's code as seen below, with a (unique) associated key. Once a variable is registered, variations can change the value of variables based on their key. For example, you can create an experiment that tests different values for gravity.

    NSNumber *gravity = [[Optimizely sharedInstance] numberForKey:@"gravity" defaultValue:@(9.8)];

**NSLocalizedString** allows for a less explicit way of changing strings, and requires less integration if the user has already localized their app. The Optimizely SDK automatically displays any `NSLocalizedStrings` in your app and enables you to change their value.

    NSString *buttonLabel = NSLocalizedString(@"Sign up!");

**Bound variables** allow you to set values on class properties. They rely on KVC/KVO.

    [[Optimizely sharedInstance] bindNumberForKey:@"retry-count" toKeyPath:@"maxRetries" onObject:foo];

### Custom Goals <a name="customgoals"></a>
Custom goals allow you to track events other than taps and view changes. There are two steps to creating a custom goal. The first step occurs in the web editor. Click "Goals", then "New Goal", and select "Custom Goal" from the drop-down. You will be prompted for a string to uniquely identify your custom goal. In order to track this goal, send this same string as a parameter to 

    [[Optimizely sharedInstance] trackEvent:(NSString *)]

For example, if we wanted a goal for users deleting a task with a swipe, we might create a custom goal "User Deleted Task" and then call `-trackEvent` with this string in our event handler as follows:

    - (void)userDidSwipeTask:(id)sender {
        [[Optimizely sharedInstance] trackEvent:@"User Deleted Task"];
        //The rest of your handler
    }

## Troubleshooting
**Q: My device is running the app but I can't see it in the editor.**

A: First, confirm your device is connected to the internet. If that turns out to be useless advice, make sure that the API token that you passed into `[Optimizely startOptimizelyWithAPIToken:@"YOUR-API-TOKEN" launchOptions:launchOptions];` matches what you see in the Project Code box within Optimizely.

**Q: My app crashes and I get a run-time error after installing `this class is not key value coding-compliant for the key optimizelyId`**

A: Make sure you added the `-ObjC` linker flag to your build settings (see [Manual Installation](#objc)).