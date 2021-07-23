#import "substrate.h"

#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>

#include <Weather/City.h>
#include <Weather/TWCCityUpdater.h>
#include <Weather/WeatherPreferences.h>
#include <Weather/WeatherImageLoader.h>
#include <SpringBoardFoundation/SBFStaticWallpaperView.h>
#include <SpringBoard/SBCoverSheetPanelBackgroundContainerView.h>
#include <SpringBoard/SBWallpaperEffectView.h>
#include <SpringBoard/SBApplication.h>
#include <SpringBoard/SBLockScreenManager.h>

// Weather stuff

@interface WUIWeatherCondition : NSObject <CALayerDelegate>
@property (assign,nonatomic) City *city;
@property (nonatomic,readonly) CALayer *layer;
-(void)setCity:(id)arg1 animationDuration:(double)arg2 ;
-(void)setAlpha:(double)arg1 animationDuration:(double)arg2;
-(void)resume;
-(void)pause;
@end

@interface WUIGradientLayer : CAGradientLayer {
	BOOL _allowsActions;
}
@property (assign,nonatomic) BOOL allowsActions;
-(id)actionForKey:(id)arg1 ;
-(BOOL)allowsActions;
-(void)setAllowsActions:(BOOL)arg1 ;
@end

@interface WACurrentForecast
@property (assign,nonatomic) long long conditionCode;
@property (nonatomic, retain) WFTemperature *temperature;
@end

@interface WAForecastModel : NSObject
@property (nonatomic,retain) City *city;
@property (nonatomic,retain) WACurrentForecast *currentConditions;
-(WFTemperature *)temperature;
@end

@interface WATodayModel
@property (nonatomic,retain) WAForecastModel *forecastModel;
+(id)autoupdatingLocationModelWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2 ;
-(BOOL)executeModelUpdateWithCompletion:(/*^block*/id)arg1 ;
-(id)location;
@end

@interface WATodayAutoupdatingLocationModel:WATodayModel
-(void)setIsLocationTrackingEnabled:(BOOL)arg1;
-(void)setLocationServicesActive:(BOOL)arg1;
@end

@interface WFTemperature : NSObject 
@property (assign,nonatomic) CGFloat celsius; 
@property (assign,nonatomic) CGFloat fahrenheit; 
@property (assign,nonatomic) CGFloat kelvin; 
-(CGFloat)temperatureForUnit:(int)arg1 ;
@end

@interface WUIDynamicWeatherBackground : UIView 
@property (nonatomic,retain) WUIWeatherCondition *condition; 
@property (nonatomic,retain) WUIGradientLayer *gradientLayer; 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setCity:(id)arg1 animate:(BOOL)arg2 ;
-(void)setCity:(id)arg1 ;
-(void)setCity:(id)arg1 animationDuration:(double)arg2 ;
-(CALayer *)rootLayer;
@end

@interface WALockscreenWidgetViewController : UIViewController
@property (nonatomic, strong) WATodayModel *todayModel;
+(WALockscreenWidgetViewController *)sharedInstanceIfExists;
-(id)_temperature;
-(id)_locationName;
-(void)updateWeather;
-(void)_updateTodayView;
-(void)_updateWithReason:(id)reason;
-(void)_setupWeatherModel;
-(void)todayModelWantsUpdate:(WATodayModel *)todayModel;
@end

// Views

WUIDynamicWeatherBackground *LSWeatherView;
WUIDynamicWeatherBackground *HSWeatherView;
WUIDynamicWeatherBackground *CCWeatherView;
WALockscreenWidgetViewController *WeatherWidget;
NSTimer *timer = nil;

@interface CSFixedFooterViewController : UIViewController
@end

@interface SBHomeScreenView : UIView
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end

@interface SpringBoard : UIApplication
-(void)UpdateWeather;
@end