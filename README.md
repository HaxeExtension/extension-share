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

http://www.gnu.org/licenses/lgpl.html

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License (LGPL) as published by the Free Software Foundation; either
version 3 of the License, or (at your option) any later version.
  
This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
  
You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.


WebSite: https://github.com/fbricker/openfl-share | Author: Federico Bricker | Copyright (c) 2014 SempaiGames (http://www.sempaigames.com)
