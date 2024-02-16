#import <YouTubeHeader/YTIIcon.h>
#import <YouTubeHeader/YTSettingsGroupData.h>
#import <rootless.h>

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]

@interface YTSettingsGroupData (YouGroupSettings)
+ (NSMutableArray <NSNumber *> *)tweaks;
@end

static const NSUInteger GROUP_TYPE = 'psyt';

NSBundle *TweakBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YouGroupSettings" ofType:@"bundle"];
        if (tweakBundlePath)
            bundle = [NSBundle bundleWithPath:tweakBundlePath];
        else
            bundle = [NSBundle bundleWithPath:ROOT_PATH_NS(@"/Library/Application Support/YouGroupSettings.bundle")];
    });
    return bundle;
}

%hook YTAppSettingsGroupPresentationData

+ (NSArray <YTSettingsGroupData *> *)orderedGroups {
    NSArray <YTSettingsGroupData *> *groups = %orig;
    NSMutableArray <YTSettingsGroupData *> *mutableGroups = [groups mutableCopy];
    YTSettingsGroupData *tweakGroup = [[%c(YTSettingsGroupData) alloc] initWithGroupType:GROUP_TYPE];
    [mutableGroups insertObject:tweakGroup atIndex:0];
    return mutableGroups;
}

%end

%hook YTSettingsGroupData

%new(@@:)
+ (NSMutableArray <NSNumber *> *)tweaks {
    static NSMutableArray <NSNumber *> *tweaks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tweaks = [NSMutableArray new];
        [tweaks addObjectsFromArray:@[
            @(404), // YTABConfig
            @(517), // DontEatMyContent
            @(1080), // Return YouTube Dislike
            @(200), // YouPiP
            @(2168), // YTHoldForSpeed
            @(1222), // YTVideoOverlay
            @(500), // uYou+
        ]];
    });
    return tweaks;
}

- (NSString *)titleForSettingGroupType:(NSUInteger)type {
    if (type == GROUP_TYPE) {
        NSBundle *tweakBundle = TweakBundle();
        return LOC(@"TWEAKS");
    }
    return %orig;
}

- (NSArray <NSNumber *> *)orderedCategoriesForGroupType:(NSUInteger)type {
    if (type == GROUP_TYPE)
        return [[self class] tweaks];
    return %orig;
}

%end

%hook YTSettingsViewController

- (void)setSectionItems:(NSMutableArray *)sectionItems forCategory:(NSInteger)category title:(NSString *)title icon:(YTIIcon *)icon titleDescription:(NSString *)titleDescription headerHidden:(BOOL)headerHidden {
    if (icon == nil && [[%c(YTSettingsGroupData) tweaks] containsObject:@(category)]) {
        icon = [%c(YTIIcon) new];
        icon.iconType = 44;
    }
    %orig;
}

%end
