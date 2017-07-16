#include "SETRootListController.h"

@implementation SETRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void) createAlbum {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    UIView *activityHUD = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityView.bounds.size.width+30, activityView.bounds.size.height+30)];
    activityHUD.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
    activityHUD.layer.cornerRadius = activityHUD.frame.size.height/10;
    activityHUD.layer.masksToBounds = TRUE;
    activityHUD.autoresizingMask = activityView.autoresizingMask;
    activityHUD.center = self.view.center;
    activityView.center = self.view.center;
    [self.view addSubview:activityHUD];
    [self.view addSubview:activityView];
    [activityView startAnimating];
    // Fetch all assets, sorted by date created.
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      if (status == PHAuthorizationStatusAuthorized) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        self.imageManager = [[PHCachingImageManager alloc] init];

        [activityView stopAnimating];
        [activityView removeFromSuperview];
        [activityHUD removeFromSuperview];

        NSInteger assetItems = [_assetsFetchResults count];
        __block NSMutableArray *gifs = [NSMutableArray new];
        for (int i = 0; i < assetItems; i++) {
            PHAsset *asset = _assetsFetchResults[i];
          	if ([asset respondsToSelector:@selector(uniformTypeIdentifier)]) { //uniformTypeIdentifier applies only for photo assets, if this code runs for a video, the app will crash.
          	   NSString *typeID = [asset performSelector:@selector(uniformTypeIdentifier)];
               if ([typeID isEqualToString:@"com.compuserve.gif"]) {
                 [gifs addObject:asset];
               }
            }
        }
        __block PHAssetCollection *assetCollection;
        __block id myAlbum;

        //Find the album, if it exists.

        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"GIFs"];
        assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions].firstObject;

        if (!assetCollection) {
          //Create the album
          [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"GIFs"];
            myAlbum = changeRequest.placeholderForCreatedAssetCollection;
          } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                //Why not local Identifier? Check the method below...
                [self completeTheAlbumwithGIFs:gifs];
            }
            else {
              NSLog(@"Error: %@", error);
            }
          }];
        }
        else {
            [self completeTheAlbum:assetCollection withGIFs:gifs];
        }
      }
      else if (status == PHAuthorizationStatusRestricted) {
      }
      else {
        //Denied.
      }
    }];
}

- (void)completeTheAlbum:(id)assetCollection withGIFs:(NSMutableArray *)gifs {
    //Here the album exists so no need to search again.
    NSError *newError;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [changeRequest addAssets:gifs];
    } error:&newError];
}

- (void)completeTheAlbumwithGIFs:(NSMutableArray *)gifs {
    /*
        Why not reference with local Identifier and instead, search again?
        Well, annoyingly, this would always result into a crash. It worked on
        stock iOS apps, but it seems that this issue was limited to the Settings
        app. So, in the end, the only way to avoid the crash was to search again.
    */
    NSError *newError;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"GIFs"];
    id assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions].firstObject;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
    PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
    [changeRequest addAssets:gifs];
    } error:&newError];
}

- (void) follow {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/intent/user?screen_name=isklikas"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void) source {
    NSURL *url = [NSURL URLWithString:@"https://github.com/isklikas/GIFRoll"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void) donate {
    NSURL *url = [NSURL URLWithString:@"https://paypal.me/isklikas/1"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end
