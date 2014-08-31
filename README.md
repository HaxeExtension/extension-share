openfl-share
============

Native Sharing calls for OpenFL

This is a simple implementation "Share" API. So far it calls the "Share Intent" on Android, a popup on HTML5 and opens sharing URL from Facebook and Twitter on iOS.

Simple use Example:
=======

```haxe
// This example show a simple sharing of a text using the Share Classs.

import extension.share.Share;

class SimpleExample {
	function new(){
		Share.init(Share.TWITTER,'', 'http://www.puralax.com/mobile/');
		// Share.init(Share.FACEBOOK,'12344123', 'http://www.puralax.com/mobile/'); // 12344123 is a random number (you should place your facebook app id here.)
	}

	function shareStuff(){
		Share.share('Hi, I\'m testing the OpenFL-Sharing extension!')
	}
}

```

How to Install:
=======

```bash
haxelib install openfl-share
```

Disclaimer
=======

Twitter is a registered trademark of Twitter Inc.
http://es.unibrander.com/estados-unidos/212050US/twitter.html

Facebook is a registered trademark of Facebook Inc.
http://es.unibrander.com/estados-unidos/221811US/facebook.html

Licence
=======
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
  
Google is a registered trademark of Google Inc.


WebSite: https://github.com/fbricker/openfl-share | Author: Federico Bricker | Copyright (c) 2014 SempaiGames (http://www.sempaigames.com)