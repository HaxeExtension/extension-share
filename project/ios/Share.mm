#include <Share.h>
#import <UIKit/UIKit.h>

namespace openflShareExtension {
	
	void doShare(const char *text, const char *url){
        UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        NSString *sText = [[NSString alloc] initWithUTF8String:text];
        NSArray *itemsToShare;
        if(url != nil){
	        NSURL *sURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:url]];
	        itemsToShare = @[sText,sURL];
        }else{
	        itemsToShare = @[sText];        	
        }
        UIActivityViewController  *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList]; //UIActivityTypeMail];
        [root presentViewController:activityVC animated:YES completion:nil];
    }

}
