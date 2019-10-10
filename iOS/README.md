# Helpshift's iOS SDK wrapper for Webchat

## Introduction

This is an implementation which shows how to embed the Helpshift Webchat product into a native iOS App.
This is **only a POC** and is not an officially supported version of the Helpshift SDK.
For a richer interaction and more native support, please head over to the [Helpshift iOS SDK Documentation](https://developers.helpshift.com/ios/getting-started/)

## When to use this

1. If you want to support iOS versions below iOS 10 which are not currently supported by the Helpshift iOS SDK 
2. If you want to get Bots support up and running to automate your Digital Customer Service experience and evaluate it's value
3. If you have other concerns about adding 3rd party closed source SDKs into your application.


## How to use this

The HelpshiftWebchatSdk project has 2 targets,
1. Falcon : which is the test application
2. HelpshiftWebchatSdk.framework : which is a framework which exposes a very thin API on top of the Webchat SDK

### To integrate as is within your application, 

1. Open the HelpshiftWebchatSdk.xcodeproj file and build the HelpshiftWebchatSdk target.
2. Drag and drop the framework from the Products folder into your application
3. Initialise the SDK by calling 
```
    [Helpshift installWithPlatformId:@"platform-id"
                           andDomain:@"domain"];
```
4. If you want to open the conversation screen use the below API

```
    [Helpshift showConversationWith:self andWebchatDelegate:self];
```

5. This SDK requires the use of the login API to ensure that conversations can be persisted across app restarts. To do this, please use 

```
    [Helpshift loginWithUserIdentifier:@"id"
                              withName:@"name"
                              andEmail:@"email"];
```

### Delegates

If you want to listen to Helpshift events which are published by the Webchat SDK, please implement the *HelpshiftWebchatDelegate* and set the delegate in the `showConversationWith:andWebchatDelegate` method
For an example, please refer to the *Falcon -> ViewController.m* file

## Limitations

1. Unless the webview is loaded into memory by calling the `showConversationWith:andWebchatDelegate` method, you will not be able to receive new Agent messages in the conversation.
2. When the app is not running, there is no way to get notified about new Agent messages.
3. Since the Webchat SDK cannot store any local data, you will need to use the login API if you want to continue conversations between app restarts.
