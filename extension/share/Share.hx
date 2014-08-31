package extension.share;

class Share {

	#if android
	private static var __share : String->String->String->String->Void=null;
	#end

	private static var defaultSocialNetwork:String='twitter';
	private static var facebookAppID:String='';
	private static var defaultURL:String='';
	private static var defaultFallback:String->Void=null;

	public static inline var FACEBOOK:String='facebook';
	public static inline var TWITTER:String='twitter';

	public static function init(defaultSocialNetwork:String, facebookAppID:String='', defaultURL:String='', defaultFallback:String->Void=null) {
		Share.defaultSocialNetwork=defaultSocialNetwork;
		Share.facebookAppID=facebookAppID;
		Share.defaultURL=defaultURL;
		Share.defaultFallback=defaultFallback;
		#if android
		if(__share!=null) return;
		try{
			__share    = openfl.utils.JNI.createStaticMethod("shareex/ShareEx", "share", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
		}catch(e:Dynamic){
			trace("Share New -> Exception: "+e);
		}
		#end
	}
	
	public static function share(text:String, subject:String='', image:String='', html:String='', email:String='', url:String=null, socialNetwork:String=null, fallback:String->Void=null){
		if(url==null) url=defaultURL;
		if(socialNetwork==null) socialNetwork=defaultSocialNetwork;
		if(fallback==null) fallback=defaultFallback;
		var cleanUrl:String=StringTools.replace(url,'http://','');
		try{
		#if android
			__share(text+(cleanUrl!=''?' '+cleanUrl:''),subject,html,email);
		#else
			text=StringTools.urlEncode(text);
			subject=StringTools.urlEncode(subject);
			url=StringTools.urlEncode(url);
			cleanUrl=StringTools.urlEncode(cleanUrl);
			image=StringTools.urlEncode(image);
			var shareUrl=switch(socialNetwork){
				case Share.TWITTER: 'https://twitter.com/intent/tweet?original_referer='+url+'&text='+text+'%20'+cleanUrl;
				default: 'https://www.facebook.com/dialog/feed?app_id='+Share.facebookAppID+'&description='+text+'&display=popup&caption='+subject+'&link='+url+'&redirect_uri=http://www.puralax.com/shared/&images[]='+image;
			}
			#if html5
				var pWidth:Int=550;
				var pHeight:Int=(socialNetwork==Share.TWITTER)?250:350;
				var pTop = 150;
		        var pLeft = (js.Browser.window.screen.width - pWidth -10);
				js.Browser.window.open(shareUrl,'_blank','top='+pTop+',left='+pLeft+',status=0,toolnar=0,width='+pWidth+',height='+pHeight);
			#else
				if(fallback!=null) {
					fallback(shareUrl);
				} else {
					flash.Lib.getURL(new flash.net.URLRequest(shareUrl),'_blank');
				}
			#end
		#end
		}catch(e:Dynamic){
			trace("Share SHARE Exception: "+e);
		}
	}
	
}
