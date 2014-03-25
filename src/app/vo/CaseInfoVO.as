package app.vo{	
	import app.Controller;
	import app.utils.DataParser;
	
	import com.adobe.utils.ArrayUtil;

	public class CaseInfoVO{
		public var caseName:String="";
		public var content:String="";
		public var memo:String="";
		public var imageURL:String="";
		public var type:String="";	
		public var motionValue:Number=0.5;	
		public var screenList:Array=new Array();
		public var productList:Array=new Array();
		public function CaseInfoVO() {
			
		}
		public function getProductInfo(id:String):Object
		{
			for(var i=0;i<productList.length;i++)
			{
				//trace(productList[i].ID,id);
				if(String(productList[i].ID)==String(id))
				{
					return productList[i];
				}
			}
			trace("fuck");
			return null;
		}
		public function traceMe():void
		{
			log("---CaseInfo");
			log("\tCaseName:"+caseName);
			log("\tContent:"+content);
			log("---ScreenList:");
			for each(var im in this.screenList)
			{
				var screenVO:ScreenVO = im as ScreenVO;
				screenVO.traceMe();
			}
			log("---ProductList:");
			for each(var p in this.productList)
			{
				log(p.ID+"-"+p.Name+"-"+p.Type+"-"+p.Price);
			}
		}
		public function set data(value):void
		{
			var caseData:* = DataParser.parseXML2Array(XML(value))[0];
			caseName =caseData.CaseInfo.Name;
			content = caseData.CaseInfo.Content;
			memo = caseData.CaseInfo.Memo;
			type = caseData.CaseInfo.Type;
			imageURL = caseData.CaseInfo.ImageURL;
			motionValue = Number(caseData.CaseInfo.MotionValue);
						
			var screenListArray:Array = DataParser.parseXML2Array(XML(caseData.ScreenList[0]));
			for(var i=0;i<screenListArray.length;i++)
			{
				var screenVO:ScreenVO = new ScreenVO();
				screenVO.id = i;
				screenVO.screenName = screenListArray[i].ScreenInfo.ScreenName;
				screenVO.image = screenListArray[i].ScreenInfo.Image;
				screenVO.smallImage = screenListArray[i].ScreenInfo.SmallImage;
				screenVO.content = screenListArray[i].ScreenInfo.Content;
				screenVO.memo = screenListArray[i].ScreenInfo.Memo;
				screenVO.hotPointList = DataParser.parseXML2Array(XML(screenListArray[i].PointList[0]));
				screenList.push(screenVO);
			}
			productList= DataParser.parseXML2Array(XML(caseData.ProductList[0]));			
		}		
		private function log(value):void
		{
			app.Controller.getInstance().main.log(value);	
		}		
	}
}
