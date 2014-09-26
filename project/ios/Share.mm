#include <Share.h>
#import <UIKit/UIKit.h>

namespace openflShareExtension {
	
	void doShare(const char *text){
        UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        NSString *sText = [[NSString alloc] initWithUTF8String:text];
        NSArray *itemsToShare = @[sText];
        UIActivityViewController  *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard];
        [root presentViewController:activityVC animated:YES completion:nil];
    }

}
