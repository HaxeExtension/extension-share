package extension.share;

//#if blackberry
import String;
import sys.io.File;
import openfl.utils.ByteArray;
import openfl.display.JPEGEncoderOptions;
import sys.FileSystem;
import openfl.display.BitmapData;
typedef ShareQueryResult = {
	key : String,
	icon : String,
	label : String
}
//#end

class Share {

	#if android
	private static var __share : String->String->String->String->String->Void=openfl.utils.JNI.createStaticMethod("shareex/ShareEx", "share", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	#elseif ios
	private static var __share : String->String->String->String->Void=cpp.Lib.load("openflShareExtension","share_do",4);
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
    private static var sharedImagePath:String = "";

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

	public static var onBBShareDialogExit : Void -> Void;

	static function __onBBShareDialogExit() {

		if (onBBShareDialogExit!=null) {
			onBBShareDialogExit();
		}

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
    private static function prepareBitmapData(bdm:BitmapData):Void
    {
        var imagePath:String = "";
        sharedImagePath = "";
        #if !lime_legacy
            imagePath = lime.system.System.documentsDirectory + "/shareimage.jpg";
        #else
            imagePath = openfl.utils.SystemPath.documentsDirectory + "/shareimage.jpg";
        #end
        if (FileSystem.exists(imagePath))
        {
            try
            {
                FileSystem.deleteFile(imagePath);
            }
            catch(e:Dynamic)
            {
                trace("deleting image failed");
                return;
            }
        }
        var bytes:ByteArray = bdm.encode(bdm.rect, new JPEGEncoderOptions());
        try
        {
            File.saveBytes(imagePath, bytes);
        }
        catch(e:Dynamic)
        {
            trace("saving image failed");
            return;
        }
        sharedImagePath = imagePath;
    }
	public static function share(text:String, subject:String=null, image:String='', html:String='', email:String='', url:String=null, socialNetwork:String=null, fallback:String->Void=null, bdm:BitmapData = null){
		if(url==null) url=defaultURL;
		if(subject==null) subject=defaultSubject;
		if(socialNetwork==null) socialNetwork=defaultSocialNetwork;
		if(fallback==null) fallback=defaultFallback;
		var cleanUrl:String=StringTools.replace(StringTools.replace(url,'http://',''),'https://','');
		try{

        #if (android || ios)

            if(bdm != null)
                prepareBitmapData(bdm);
            else
                sharedImagePath = "";
        #end
		#if android
			__share(text+(cleanUrl!='' ? ' '+cleanUrl : ''),subject,html,email,sharedImagePath);
		#elseif ios
			__share(text,url==''?null:url,subject==''?null:subject, sharedImagePath);
		#elseif blackberry
		flash.Lib.current.stage.addChild(new BBShareDialog(query(), text+(cleanUrl!='' ? ' '+cleanUrl : '')));
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
				//default: 'https://www.facebook.com/dialog/feed?app_id='+Share.facebookAppID+'&description='+text+'&display=popup&caption='+subject+'&link='+url+redirectURI+'&images[]='+image;
				default: 'https://www.facebook.com/sharer/sharer.php?u='+url+redirectURI+'&description='+text+'&display=popup&caption='+subject;
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
