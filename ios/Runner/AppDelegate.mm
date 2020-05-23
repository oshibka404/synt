#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "DSP/DspFaust.h"

@implementation AppDelegate {
    DspFaust *dspFaust;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dspFaust = new DspFaust(44100, 256); // TODO: get rid of hardcoded SR & buff size
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* synthControlChannel = [FlutterMethodChannel
        methodChannelWithName:@"synth.ae/control"
        binaryMessenger:controller.binaryMessenger];
    
    __weak typeof(self) weakSelf = self;
    [synthControlChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        if ([@"start" isEqualToString:call.method]) {
            bool success = [weakSelf start];
            result(@(success));
        } else if ([@"stop" isEqualToString:call.method]) {
            [weakSelf stop];
            result(nil);
        } else if ([@"isRunning" isEqualToString:call.method]) {
            bool isRunningResult = [weakSelf isRunning];
            result(@(isRunningResult));
        } else if ([@"getParamsCount" isEqualToString:call.method]) {
            int paramsCount = [weakSelf getParamsCount];
            result(@(paramsCount));
        } else if ([@"getParamInit" isEqualToString:call.method]) {
            NSNumber* idArg = (call.arguments[@"id"]);
            float paramInit = [weakSelf getParamInit:idArg.intValue];
            result(@(paramInit));
        } else if ([@"getParamValue" isEqualToString:call.method]) {
            NSNumber* idArg = call.arguments[@"id"];
            float paramValue =  [weakSelf getParamValue:idArg.intValue];
            result(@(paramValue));
        } else if ([@"getParamMin" isEqualToString:call.method]) {
            NSNumber* idArg = call.arguments[@"id"];
            float paramMin =  [weakSelf getParamMin:idArg.intValue];
            result(@(paramMin));
        } else if ([@"getParamMax" isEqualToString:call.method]) {
            NSNumber* idArg = call.arguments[@"id"];
            float paramMax =  [weakSelf getParamMax:idArg.intValue];
            result(@(paramMax));
        } else if ([@"setParamValue" isEqualToString:call.method]) {
            NSNumber* idParam = call.arguments[@"id"];
            NSNumber* valueParam = call.arguments[@"value"];
            [weakSelf setParam:idParam.intValue Value:valueParam.floatValue];
            result(nil);
        } else if ([@"keyOn" isEqualToString:call.method]) {
            NSNumber* pitchParam = call.arguments[@"pitch"];
            NSNumber* velocityParam = call.arguments[@"velocity"];
            long voiceId = [weakSelf keyOn:pitchParam.intValue WithVelocity:velocityParam.intValue];
            result(@(voiceId));
        } else if ([@"keyOff" isEqualToString:call.method]) {
            NSNumber* pitchParam = call.arguments[@"pitch"];
            int keyOffResult = [weakSelf keyOff:pitchParam.intValue];
            result(@(keyOffResult));
        } else if ([@"allNotesOff" isEqualToString:call.method]) {
            [weakSelf allNotesOff];
            result(nil);
        } else if ([@"newVoice" isEqualToString:call.method]) {
            long voiceId = [weakSelf newVoice];
            result(@(voiceId));
        } else if ([@"deleteVoice" isEqualToString:call.method]) {
            NSNumber* voiceParam = call.arguments[@"voice"];
            int deleteVoiceResult = [weakSelf deleteVoice:voiceParam.intValue];
            result(@(deleteVoiceResult));
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (bool)start {
    return dspFaust->start();
}

- (void)stop {
    dspFaust->stop();
}

- (bool)isRunning {
    return dspFaust->isRunning();
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

- (float)getParamMin:(int)id {
    return dspFaust->getParamMin(id);
}

- (float)getParamMax:(int)id {
    return dspFaust->getParamMax(id);
}

- (void)setParam:(int)id Value:(float)value {
    dspFaust->setParamValue(id, value);
}

- (uintptr_t)keyOn:(int)pitch WithVelocity:(int)velocity {
    return dspFaust->keyOn(pitch, velocity);
}

- (int)keyOff:(int)pitch {
    return dspFaust->keyOff(pitch);
}

- (void)allNotesOff {
    dspFaust->allNotesOff();
}

- (uintptr_t)newVoice {
    return dspFaust->newVoice();
}

- (int)deleteVoice:(int)voice {
    return dspFaust->deleteVoice(voice);
}

@end
