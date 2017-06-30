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
