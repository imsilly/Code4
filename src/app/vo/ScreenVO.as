package app.vo{
	import app.Controller;
	import app.utils.DataParser;

	public class  ScreenVO{
		public var id:int;
		public var screenName:String;
		public var image:String;
		public var smallImage:String;
		public var content:String;	
		public var memo:String;	
		public var hotPointList:Array;
		public function ScreenVO() {
			
		}
		public function traceMe():void
		{
			log("ScreenName:"+screenName);
			log("\tImage:"+image);
			log("\tContent:"+content);
			for each(var pt in hotPointList)
			{
				log("\tPoint:"+pt.PointTitle);
			}
		}
		private function log(value):void
		{
			app.Controller.getInstance().main.log(value);	
		}
		/*public function set data(value):void
		{
			var screenData:* = DataParser.parseXML2Array(XML(value))[0];
			screenName =screenData.ScreenInfo.ScreenName;
			image = screenData.ScreenInfo.Image;
			content = screenData.ScreenInfo.Content;
			memo = screenData.ScreenInfo.Memo;
			
			var hotPointListArray = DataParser.parseXML2Array(XML(screenData.ScreenList[0]));
			for(var i=0;i<hotPointListArray.length;i++)
			{
				var hotPointVO:HotPointVO = new HotPointVO();
				hotPointVO.data = hotPointListArray[i];
				hotPointList.push(hotPointVO);
			}				
		}		
		*/
	}
}
