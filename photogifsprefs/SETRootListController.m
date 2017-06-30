#include "SETRootListController.h"

@implementation SETRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)follow {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/intent/user?screen_name=isklikas"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

-(void)source {
    system("killall -9 Springboard");
}

-(void)donate {
    NSURL *url = [NSURL URLWithString:@"https://paypal.me/isklikas/1"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end
