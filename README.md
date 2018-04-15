# extension-share

Native Sharing calls for OpenFL

This is a simple "Share" API implementation. So far it calls the "Share Intent" on Android, iOS and BlackBerry, a popup on HTML5 and opens sharing URL from Facebook and Twitter on other platforms.

### Simple use Example

```haxe
// This example show a simple sharing of a text using the Share Classs.

import extension.share.Share;

class SimpleExample {
	function new(){
		Share.init(Share.TWITTER); // for non supported targets, we share on Twitter (you can also use Share.FACEBOOK)
		Share.defaultURL='http://www.puralax.com/'; // url to add at the end of each share (optional).
		Share.defaultSubject='Try puralax!'; // in case the user choose to share by email, set the subject.
		
		// Other things you may want to init for non-supported targets
		/*
		Share.facebookAppID='1239833828932'; // your facebook APP ID
		Share.defaultFallback=function(url:String){ ... }; // callback function (in case you want to open the share URL yourself).
		Share.facebookRedirectURI='http://www.puralax.com/share'; // URL to go after sharing on facebook.
		*/
	}

	function shareStuff(){
		Share.share('Hi, I\'m testing the OpenFL-Sharing extension!');
		// check the share paremeters to see what you can share using this extension:
		// public static function share(
		//	text:String, // text to share
		//	subject:String=null, // subject in case your user chooses "email"
		//	image:String='', // path to an image you want to share in case you have one
		//	html:String='', // html version of your shared text (android only)
		//	email:String='', // preset email address in case your user chooses "email"
		//	url:String=null, // url to append to the shared text
		//	socialNetwork:String=null, // default social network (for everything but android, ios & blackberry)
		//	fallback:String->Void=null, // function to call when we don't know how to share
		//	bdm:BitmapData = null); // bitmap data object: Will be saved as JPG and shared (ios & android only)
	}
}

```

### How to Install

```bash
haxelib install extension-share
```

### Disclaimer

Twitter is a registered trademark of Twitter Inc.
http://unibrander.com/united-states/212050US/twitter.html

Facebook is a registered trademark of Facebook Inc.
http://unibrander.com/united-states/221811US/facebook.html

### License

The MIT License (MIT) - [LICENSE.md](LICENSE.md)

Copyright &copy; 2014 SempaiGames (http://www.sempaigames.com)

Author: Federico Bricker
