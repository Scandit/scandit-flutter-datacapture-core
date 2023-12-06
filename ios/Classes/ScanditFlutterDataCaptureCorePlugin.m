/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

#import <scandit_flutter_datacapture_core/scandit_flutter_datacapture_core-Swift.h>

#import "ScanditFlutterDataCaptureCorePlugin.h"

@interface ScanditFlutterDataCaptureCorePlugin ()

@property (nonatomic, strong) ScanditFlutterDataCaptureCore *coreInstance;

- (instancetype)initWithCoreInstance:(ScanditFlutterDataCaptureCore *)coreInstance;

@end

@implementation ScanditFlutterDataCaptureCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"com.scandit.datacapture.core.method/datacapture_defaults"
              binaryMessenger:registrar.messenger];
    ScanditFlutterDataCaptureCore *coreInstance = [[ScanditFlutterDataCaptureCore alloc]
        initWithMethodChannel:channel
                    messenger:registrar.messenger];
    ScanditFlutterDataCaptureCorePlugin *plugin = [[ScanditFlutterDataCaptureCorePlugin alloc]
        initWithCoreInstance:coreInstance];
    [registrar addMethodCallDelegate:plugin channel:channel];
    [registrar registerViewFactory:coreInstance withId:@"com.scandit.DataCaptureView"];
}

- (instancetype)initWithCoreInstance:(ScanditFlutterDataCaptureCore *)coreInstance {
    if (self = [super init]) {
        _coreInstance = coreInstance;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self.coreInstance handle:call result:result];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self.coreInstance dispose];
}

@end
