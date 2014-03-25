/*
 * 
 * 	zh-cn//简体中文
	zh//繁體中文   
	English
	French
	German
	Japanese
	Korean
	Spanish
	Swedish
*/
package app.utils{	
	import app.utils.DataParser;
	public class Language {
		public static  var _wordObj:Object = new Object();
		public static  var _language:String="";	
		public static  var _languageXMLList:XML;			
		public static  var _langObj:Object = new Object();
		public static  var _oldLangObj:Object = new Object();
		public function Language() {
			
		}
		public static function set languageXMLList(value:*)
		{
			_languageXMLList = XML(value);
			var langArray:Array = DataParser.parseXML2Array(_languageXMLList);
			for(var im in langArray[0])
			{
				_langObj[im] = langArray[0][im];
			}
		}
		public static function get languageXMLList():XML
		{
			return _languageXMLList;
		}		
		public static function getWord(value:String):String
		{
			return _wordObj[value];
		}		
		public static function set language(value:String)
		{
			_language = value;
			var xml = XML(_langObj[_language]);
			var obj:Object = DataParser.parseXML2Array(xml)[0];
			for(var im in obj)
			{
				_wordObj[im] = obj[im];
			}
		}
		public static function get language():String
		{
			return String(_language);
		}
	}
}
