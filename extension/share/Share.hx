package extension.share;

//#if blackberry
typedef ShareQueryResult = {
	key : String,
	icon : String,
	label : String
}
//#end

class Share {

	#if android
	private static var __share : String->String->String->String->Void=openfl.utils.JNI.createStaticMethod("shareex/ShareEx", "share", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	#elseif ios
	private static var __share : String->String->String->Void=cpp.Lib.load("openflShareExtension","share_do",3);
	#elseif blackberry
	private static var __share : String->String->Void=cpp.Lib.load("openflShareExtension","share_do",2);
	private static var __query : Void->Array<ShareQueryResult>=cpp.Lib.load("openflShareExtension","share_query",0);
	#end

	public static var defaultSocialNetwork:String='twitter';
	public static var facebookAppID:String='';
	public static var defaultURL:String='';
	public static var defaultFallback:String->Void=null;
	public static var facebookRedirectURI:String=null;
	public static var defaultSubject:String='';

	public static inline var FACEBOOK:String='facebook';
	public static inline var TWITTER:String='twitter';

	public static function init(defaultSocialNetwork:String, facebookAppID:String='', defaultURL:String='', defaultFallback:String->Void=null, facebookRedirectURI:String=null, defaultSubject='') {
		Share.defaultSocialNetwork=defaultSocialNetwork;
		Share.facebookAppID=facebookAppID;
		Share.defaultURL=defaultURL;
		Share.defaultFallback=defaultFallback;
		Share.facebookRedirectURI=facebookRedirectURI;
		Share.defaultSubject=defaultSubject;
	}

	public static function bbShare(method : String, text : String) {
		#if blackberry
		__share(method, text);
		#end
	}

	static function query() {

		#if blackberry

		return __query();

		#else

		return [
			{ label : "BBM Channel", icon : "", key : "sys.bbm.channels.sharehandler" },
			{ label : "BBM Group", icon : "", key : "sys.bbgroups.sharehandler" },
			{ label : "Facebook", icon : "", key : "Facebook" }
		];

		#end

	}

	public static function share(text:String, subject:String=null, image:String='', html:String='', email:String='', url:String=null, socialNetwork:String=null, fallback:String->Void=null){
		if(url==null) url=defaultURL;
		if(subject==null) subject=defaultSubject;
		if(socialNetwork==null) socialNetwork=defaultSocialNetwork;
		if(fallback==null) fallback=defaultFallback;
		var cleanUrl:String=StringTools.replace(StringTools.replace(url,'http://',''),'https://','');
		try{
		#if android
			__share(text+(cleanUrl!=''?' '+cleanUrl:''),subject,html,email);
		#elseif ios
			__share(text,url==''?null:url,subject==''?null:subject);
		#elseif blackberry
		flash.Lib.current.stage.addChild(new BBShareDialog(query(), text));
		#else
			text=StringTools.urlEncode(text);
			subject=StringTools.urlEncode(subject);
			url=StringTools.urlEncode(url);
			cleanUrl=StringTools.urlEncode(cleanUrl);
			var redirectURI:String='';
			if(facebookRedirectURI!=null) redirectURI='&redirect_uri='+StringTools.urlEncode(facebookRedirectURI);
			image=StringTools.urlEncode(image);
			var shareUrl=switch(socialNetwork){
				case Share.TWITTER: 'https://twitter.com/intent/tweet?original_referer='+url+'&text='+text+'%20'+cleanUrl;
				default: 'https://www.facebook.com/dialog/feed?app_id='+Share.facebookAppID+'&description='+text+'&display=popup&caption='+subject+'&link='+url+redirectURI+'&images[]='+image;
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
