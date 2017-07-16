#import <Preferences/PSListController.h>
#import <Photos/Photos.h>

@interface SETRootListController : PSListController

@property(nonatomic, strong) PHFetchResult *assetsFetchResults;
@property(nonatomic, strong) PHCachingImageManager *imageManager;

@end
