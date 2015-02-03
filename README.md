#openfl-share

Native Sharing calls for OpenFL

This is a simple "Share" API implementation. So far it calls the "Share Intent" on Android and iOS, a popup on HTML5 and opens sharing URL from Facebook and Twitter on other platforms.

###Simple use Example

```haxe
// This example show a simple sharing of a text using the Share Classs.

import extension.share.Share;

class SimpleExample {
	function new(){
		Share.init(Share.TWITTER); // for non supported targets, we share on Twitter (you can also use Share.FACEBOOK)
		Share.defaultURL='http://www.puralax.com/mobile/'; // url to add at the end of each share (optional).
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
	}
}

```

###How to Install

```bash
haxelib install openfl-share
```

###Disclaimer

Twitter is a registered trademark of Twitter Inc.
http://es.unibrander.com/estados-unidos/212050US/twitter.html

Facebook is a registered trademark of Facebook Inc.
http://es.unibrander.com/estados-unidos/221811US/facebook.html

###License

The MIT License (MIT) - [LICENSE.md](LICENSE.md)

Copyright &copy; 2014 SempaiGames (http://www.sempaigames.com)

Author: Federico Bricker
