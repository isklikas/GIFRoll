#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"

@interface PHASset: NSObject {}

@property (nonatomic, readonly) NSURL *ALAssetURL;
@property (nonatomic, readonly) NSString *uniformTypeIdentifier;

- (id)pathForOriginalFile;
- (id)directory;
- (id)assetsLibraryURL;
- (id)pathForOriginalImageFile;
- (id)uniformTypeIdentifier;
- (id)mainFileURL;
- (id)filename;

@end

@interface PUImageTileViewController : NSObject {}

@property id layoutInfo;
@property (nonatomic, readonly) UIImageView *_imageView;

- (id)image;
- (void)setImage:(id)arg1;
- (PHASset *)asset;
- (void)_setNeedsUpdate;
- (void)_setNeedsUpdateImage:(BOOL)arg1;
- (void)_setNeedsUpdateImageView:(BOOL)arg1;
- (void)_updateIfNeeded;
- (void)_updateImageIfNeeded;
- (void)_updateImageViewIfNeeded;
- (void)_invalidateImage;
- (void)_invalidateImageView;

@end

@interface PLPhotoTileViewController : NSObject {}

- (id)image;
- (PHASset *)photo;
- (void)setFullSizeImage:(id)arg1 ;

@end

%hook PUImageTileViewController

- (PHASset *)asset {
	PHASset *imageAsset = %orig;
	//First, let's check if it's a picture displayed, or a thumbnail.
	id layoutInfo = self.layoutInfo;
	BOOL isMainPic = [layoutInfo isKindOfClass:NSClassFromString(@"PUParallaxedTileLayoutInfo")]; //This is the picture displayed class.
	if ([imageAsset respondsToSelector:@selector(uniformTypeIdentifier)] && isMainPic) { //uniformTypeIdentifier applies only for photo assets, if this code runs for a video, the app will crash.
		NSString *typeID = imageAsset.uniformTypeIdentifier;
		if ([typeID isEqualToString:@"com.compuserve.gif"]) { //If it's a GIF.
			NSURL *fURL = [imageAsset mainFileURL];
			dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //Runs asynchronously, to avoid lag.
				UIImage *myGIF = [UIImage animatedImageWithAnimatedGIFURL:fURL]; //The category class imported
    		dispatch_async(dispatch_get_main_queue(), ^(void){ //UI Updates on the main thread.
					[self setImage:myGIF];
					self._imageView.image = myGIF;
				});
			});
		}
	}
	return imageAsset;

}

%end

%hook PLPhotoTileViewController

- (id) image {
	PHASset *imageAsset = [self photo];
	if ([imageAsset respondsToSelector:@selector(uniformTypeIdentifier)]) {
		NSString *typeID = imageAsset.uniformTypeIdentifier;
		if ([typeID isEqualToString:@"com.compuserve.gif"]) {
			NSURL *fURL = [imageAsset mainFileURL];
			UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:fURL];
			return mygif;
		}
	}
	return %orig;
}


-(void)setFullSizeImage:(id)arg1 {
	UIImage *img = [self image];
	%orig(img);
}

%end
