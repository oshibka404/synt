#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "DSP/DspFaust.h"

@implementation AppDelegate {
    DspFaust *dspFaust;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dspFaust = new DspFaust(44100, 256);
    dspFaust->start();
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* synthControlChannel = [FlutterMethodChannel
        methodChannelWithName:@"synth.ae/control"
        binaryMessenger:controller.binaryMessenger];
    
    __weak typeof(self) weakSelf = self;
    [synthControlChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        if ([@"getParamsCount" isEqualToString:call.method]) {
            int paramsCount = [weakSelf getParamsCount];
            result(@(paramsCount));
        } else if ([@"getParamInit" isEqualToString:call.method]) {
            NSNumber* idArg = (call.arguments[@"id"]);
            float paramInit = [weakSelf getParamInit:idArg.intValue];
            result(@(paramInit));
        } else if ([@"getParamValue" isEqualToString:call.method]) {
            NSNumber* idParam = call.arguments[@"id"];
            float paramValue =  [weakSelf getParamValue:idParam.intValue];
            result(@(paramValue));
        } else if ([@"setParamValue" isEqualToString:call.method]) {
            NSNumber* idParam = call.arguments[@"id"];
            NSNumber* valueParam = call.arguments[@"value"];
            [weakSelf setParam:idParam.intValue Value:valueParam.floatValue];
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getParamsCount {
    return dspFaust->getParamsCount();
}

- (float)getParamInit:(int)id {
    return dspFaust->getParamInit(id);
}

- (float)getParamValue:(int)id {
    return dspFaust->getParamValue(id);
}

- (void)setParam:(int)id Value:(float)value {
    dspFaust->setParamValue(id, value);
}

@end
