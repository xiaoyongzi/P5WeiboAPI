/* 
Under GNU Licence
Twitter @ayay412
website http://xiaoyongzi.github.io
github http://github.com/xiaoyongzi
Weibo http://weibo.com/ayay

!!Relace your own APP_ID, APP_secret and callback_url First!!
the package of the Processing-http library is needed (could be found in the folder).
when you run the code at first time or your access_token out of licence, 
you have to enter your Account ID and password mautually, then copy and paste
the CODE after your callback website to processing.
*/
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.KeyEvent;
import com.francisli.processing.http.HttpClient;
import com.francisli.processing.http.HttpRequest;
import com.francisli.processing.http.HttpResponse;
//import com.francisli.processing.http.JSONObject;
import java.util.Map;

HttpClient client;
HttpClient api;

String APP_KEY = "your ID";
String APP_SECRET = "your secret";
String back_url = "your callback_url";
String pastedMessage;
//String username = "email";
//String password = "pw";
String content  = "a";
String [] initial_token;
String Token = "x";
HashMap GetApi_Param = new HashMap(); 
int statucode = 200;
String statudes;
String warning = "OK";
int now;
JSONObject json;
int timer=0;

void setup()
{
 size(500, 500);
 PFont f = createFont("Arial", 12);
 textFont(f);
 initial_token = loadStrings("access_token.txt");
 json = new JSONObject();
 Token = initial_token[0];
 api = new HttpClient(this, "api.weibo.com");
 api.useSSL = true;
 GetApi_Param.put("access_token",Token);
 api.GET("/2/statuses/home_timeline.json",GetApi_Param);
}

void draw(){
 background(255);
 if(statucode != 200 && timer == 0 ){
    warning = json.getString("error");
    println("Error: "+ warning);
    //text(warning,200,200);
    link("https://api.weibo.com/oauth2/authorize?client_id=" + APP_KEY + "&response_type=code&redirect_uri=" + back_url, "_new");
    timer = 1;
  }
  if(json.hasKey("access_token") && timer == 1){
     Token = json.getString("access_token");
     String[] list = split(Token,' ');
     saveStrings("data/access_token.txt", list);
     GetApi_Param.put("access_token",Token);
     api.GET("/2/statuses/home_timeline.json",GetApi_Param);
     timer = 2;
  }
}


void keyPressed(){
 if (key == 0x16 ||key == 0x37){ // Ctrl+v Problem with Command+V under MACOS
   pastedMessage = GetTextFromClipboard();
   client = new HttpClient(this, "api.weibo.com");
   client.useSSL = true;
   //client.useOAuth = true;
   client.oauthConsumerKey = APP_KEY;
   client.oauthConsumerSecret = APP_SECRET;
   HashMap params = new HashMap();
   params.put("client_id",APP_KEY);
   params.put("client_secret",APP_SECRET);
   params.put("grant_type","authorization_code");
   params.put("redirect_uri",back_url);
   params.put("code",pastedMessage);
   client.POST("oauth2/access_token",params);
 }
}

void responseReceived(HttpRequest request, HttpResponse response) {
  println(response.statusCode + ": " + response.statusMessage);
  statucode = response.statusCode;
  statudes = response.statusMessage;
  content = response.getContentAsString();
  json = json.parse(content);
  println(json);
}

String GetTextFromClipboard()
{
 String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
 return text;
}


Object GetFromClipboard(DataFlavor flavor)
{
 Clipboard clipboard = getToolkit().getSystemClipboard();
 Transferable contents = clipboard.getContents(null);
 Object obj = null;
 if (contents != null && contents.isDataFlavorSupported(flavor))
 {
 try
 {
 obj = contents.getTransferData(flavor);
 }
 catch (UnsupportedFlavorException exu) // Unlikely but we must catch it
 {
 println("Unsupported flavor: " + exu);
//~ exu.printStackTrace();
 }
 catch (java.io.IOException exi)
 {
 println("Unavailable data: " + exi);
//~ exi.printStackTrace();
 }
 }
 return obj;
} 
