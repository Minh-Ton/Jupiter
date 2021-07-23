#import "Jupiter.h"

%group JupiterLockscreen

%hook CSFixedFooterViewController
- (void)viewDidLoad {
    %orig;
	if (!LSWeatherView) {
		LSWeatherView = [[%c(WUIDynamicWeatherBackground) alloc] initWithFrame:UIScreen.mainScreen.bounds];
		LSWeatherView.gradientLayer = nil;
		[[self view] addSubview:LSWeatherView];
        [[self view] bringSubviewToFront:LSWeatherView];
	}
    if (WeatherWidget.todayModel.forecastModel.city) {
        LSWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	LSWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    if (LSWeatherView) [LSWeatherView.condition resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    if (LSWeatherView) [LSWeatherView.condition pause];
}
%end

%hook SBControlCenterController

- (void)_willPresent { 
	%orig;
	if (LSWeatherView) [LSWeatherView.condition pause];
}

%end

%hook CCUIModularControlCenterOverlayViewController

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 {
	%orig;
	if (LSWeatherView) [LSWeatherView.condition resume];
}

%end

%end // End of lockscreen group

%group JupiterHomescreen

%hook SBHomeScreenView 
- (void)willMoveToSuperview:(UIView*)newSuperview {
    %orig;
	if (!HSWeatherView) {
		HSWeatherView = [[%c(WUIDynamicWeatherBackground) alloc] initWithFrame:UIScreen.mainScreen.bounds];
		HSWeatherView.gradientLayer = nil;
        [self addSubview:HSWeatherView];
        [self sendSubviewToBack:HSWeatherView];
	}
    if (WeatherWidget.todayModel.forecastModel.city) {
        HSWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	HSWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    if (HSWeatherView) [HSWeatherView.condition resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    if (HSWeatherView) [HSWeatherView.condition pause];
}

-(void)didMoveToWindow {
    %orig;
    if (HSWeatherView) [HSWeatherView.condition resume];
}

-(void)didMoveToSuperview {
    %orig;
    if (!self.superview) {
        if (HSWeatherView) [HSWeatherView.condition pause];
    }
}
%end

%end // End of homescreen group

%group JupiterCC

%hook CCUIModularControlCenterOverlayViewController 
- (void)viewDidLoad {
    %orig;
	if (!CCWeatherView) {
		CCWeatherView = [[%c(WUIDynamicWeatherBackground) alloc] initWithFrame:UIScreen.mainScreen.bounds];
		CCWeatherView.gradientLayer = nil;
        CCWeatherView.alpha = 0;
		if (![CCWeatherView isDescendantOfView:[self view]]) [[self view] insertSubview:CCWeatherView atIndex:1];
    }
    if (WeatherWidget.todayModel.forecastModel.city) {
        CCWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	CCWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    if (CCWeatherView) [CCWeatherView.condition resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    if (CCWeatherView) [CCWeatherView.condition pause];
}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 {
    %orig;
    if (CCWeatherView) [CCWeatherView.condition resume];
    if (CCWeatherView) [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CCWeatherView.alpha = 0;
    } completion:nil];
}

%end

%hook SBControlCenterController
- (void)_willPresent {
	%orig;
    if (CCWeatherView) [CCWeatherView.condition resume];
    if (CCWeatherView) [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CCWeatherView.alpha = 1;
    } completion:nil];
}
%end

%end // End of Control Center group

%hook SpringBoard // Update Jupiter after respring & update Jupiter weather views
- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!timer) timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(UpdateWeather) userInfo:nil repeats:YES];
    [NSThread sleepForTimeInterval:3.0f]; // wait 3 seconds before setting up weather widget
    [self UpdateWeather];
}

%new 
-(void)UpdateWeather {
    if (!WeatherWidget) {
        WeatherWidget = [[%c(WALockscreenWidgetViewController) alloc] init];
        if ([WeatherWidget respondsToSelector:@selector(_setupWeatherModel)]) {
            [WeatherWidget _setupWeatherModel];
        }
        NSLog(@"Jupiter: Successfully set up WeatherWidget");
    }
    if (WeatherWidget) {
        if ([WeatherWidget respondsToSelector:@selector(todayModelWantsUpdate:)] && WeatherWidget.todayModel) {
            [WeatherWidget todayModelWantsUpdate:WeatherWidget.todayModel];
        }
        if ([WeatherWidget respondsToSelector:@selector(updateWeather)]) {
            [WeatherWidget updateWeather];
        }
        if ([WeatherWidget respondsToSelector:@selector(_updateTodayView)]) {
		    [WeatherWidget _updateTodayView];
        }
        if ([WeatherWidget respondsToSelector:@selector(_updateWithReason:)]) {
            [WeatherWidget _updateWithReason:nil];
        }
    }
    if (WeatherWidget.todayModel.forecastModel.city) {
        if (LSWeatherView) {
            LSWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	    LSWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
            NSLog(@"Jupiter: Updated weather for LS.");
        }
        if (HSWeatherView) {
            HSWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	    HSWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
            NSLog(@"Jupiter: Updated weather for HS.");
        }
        if (CCWeatherView) {
            CCWeatherView.city = WeatherWidget.todayModel.forecastModel.city;
    	    CCWeatherView.condition.city = WeatherWidget.todayModel.forecastModel.city;
            NSLog(@"Jupiter: Updated weather for CC.");
        }
	}
}

%end

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 {
	%orig;
    if (LSWeatherView) [LSWeatherView.condition resume];
}

%end

%hook SBLockScreenManager
- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {
	%orig;
    if (LSWeatherView) [LSWeatherView.condition pause];
}
%end

%ctor {
    // Load weather services
    NSBundle *WeatherUI = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/WeatherUI.framework"];
	NSBundle *Weather = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
	if (!WeatherUI.loaded) [WeatherUI load];
	if (!Weather.loaded) [Weather load];

    %init(JupiterLockscreen);
    %init(JupiterHomescreen);
    %init(JupiterCC);
    %init(_ungrouped);
}