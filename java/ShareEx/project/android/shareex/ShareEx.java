
package shareex;

import android.content.Intent;
import org.haxe.lime.GameActivity;

public class ShareEx {
    
	public static void share(String text, String subject, String html, String email) {
		Intent sendIntent = new Intent(android.content.Intent.ACTION_SEND);
		sendIntent.setType("text/plain");
        if(subject!=null && subject!="")	sendIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
        if(text!=null && text!="")	sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, text);
        if(html!=null && html!="")	sendIntent.putExtra(android.content.Intent.EXTRA_HTML_TEXT, html);
		if(email!=null && email!="") sendIntent.putExtra(android.content.Intent.EXTRA_EMAIL, email);
        GameActivity.getInstance().getContext().startActivity(sendIntent);
	}

}
