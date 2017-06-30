#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"

@interface PHASset: NSObject{}

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

- (id)image;
- (PHASset *)asset;

@end

@interface PLPhotoTileViewController : NSObject {}

- (id)image;
- (PHASset *)photo;
-(void)setFullSizeImage:(id)arg1 ;

@end

%hook PUImageTileViewController

- (id) image {
	PHASset *imageAsset = [self asset];
	NSString *typeID = imageAsset.uniformTypeIdentifier;
	if ([typeID isEqualToString:@"com.compuserve.gif"]) {
		NSURL *fURL = [imageAsset mainFileURL];
		UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:fURL];
		return mygif;
	}
	else {
		return %orig;
	}
}

%end

%hook PLPhotoTileViewController

- (id) image {
	PHASset *imageAsset = [self photo];
	NSString *typeID = imageAsset.uniformTypeIdentifier;
	if ([typeID isEqualToString:@"com.compuserve.gif"]) {
		NSURL *fURL = [imageAsset mainFileURL];
		UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:fURL];
		return mygif;
	}
	else {
		return %orig;
	}
}


-(void)setFullSizeImage:(id)arg1 {
	UIImage *img = [self image];
	%orig(img);
}

%end
