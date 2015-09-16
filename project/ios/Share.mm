#include <Share.h>
#import <UIKit/UIKit.h>

namespace openflShareExtension {
	
	void doShare(const char *text, const char *url, const char *subject){
        UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        NSString *sText = [[NSString alloc] initWithUTF8String:text];
        NSArray *itemsToShare;
        if(url != nil){
	        NSURL *sURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:url]];
	        itemsToShare = @[sText,sURL];
        }else{
	        itemsToShare = @[sText];        	
        }
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        if(subject != nil){
            [activityVC setValue:[[NSString alloc] initWithUTF8String:subject] forKey:@"subject"];
        }

        // Required for iPad on iOS >=8
        if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
            if(NULL != [activityVC valueForKey: @"popoverPresentationController"]) {
                [[activityVC valueForKey: @"popoverPresentationController"] setValue:[[UIApplication sharedApplication] keyWindow] forKey:@"sourceView"];
                [[activityVC valueForKey: @"popoverPresentationController"] setPermittedArrowDirections:0]; // Remove arrow from action sheet.
                [[activityVC valueForKey: @"popoverPresentationController"] setValue:[NSValue valueWithCGRect:[[UIApplication sharedApplication] keyWindow].frame] forKey:@"sourceRect"]; // Set action sheet to middle of view.
            }
        }

        activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypePrint,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             //UIActivityTypeMail,
                                             UIActivityTypeAirDrop];
        [root presentViewController:activityVC animated:YES completion:nil];
    }

}
