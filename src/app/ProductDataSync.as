package app
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import app.utils.DataParser;
	
	public class ProductDataSync extends Sprite
	{
		private var serverURL:String = "http://solarwind.watcher3d.com/gateway.php";
		private var haierProductLoader:URLLoader;
		private var txt:TextField;
		private var localProducts:Array;
		
		private var haierPageIndex:int = 0;
		private var haierPageSize:int = 10;
		private var haierTotalPage:int = 1;
		
		private var haierProductList:XMLList;
		private var haierProductIndex:int;
		
		public function ProductDataSync()
		{
			super();
			init();
			//getHaierProductList(5090000,10);
			//getCity();
			getLocalProductList();
		}
		
		private function init():void
		{
			txt = new TextField();
			this.addChild(txt);
			txt.width = stage.stageWidth;
			txt.height = stage.stageHeight;
			
			haierProductLoader = new URLLoader(); 
			
			haierProductLoader.addEventListener(Event.COMPLETE, onHaierProductLoaded); 
			haierProductLoader.addEventListener(IOErrorEvent.IO_ERROR,onLoadHaierProductError);
		}
		
		private function onLoadHaierProductError(e:IOErrorEvent):void
		{
			log("onLoadHaierProductError:"+e);
		}
		
		private function getHaierProductList(pageIndex:int,pageSize:int=100):void
		{
			log("");
			log("获取海尔服务器产品列表第"+pageIndex+"页 每页"+pageSize+"条");
			var urlRequest:URLRequest = new URLRequest("http://58.247.53.219:8088/GetProductWs.asmx/GetProductList");
			var param:URLVariables = new URLVariables(); 
			param.PageIndex = String(pageIndex);
			param.PageSize = String(pageSize);	
			
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded"));
			//urlRequest.data = param;
			urlRequest.data = param;
			
			haierProductLoader.load(urlRequest);
		}
		
		private function onHaierProductLoaded(ev:Event):void
		{
			log("海尔服务器产品列表获取完成");
			var s:String = haierProductLoader.data;
			//return;
			var xml:XML = new XML(s);
			s = xml;
			xml = new XML(s);
			//log(xml.child("*"));
			//log(xml.children()); 
			//log(xml.ProductDataList); 
			//log(xml.DataInfo); 
			//log(xml); 
			
			var n:int = xml.DataInfo.TotalCount;
			haierTotalPage = Math.ceil(n/haierPageSize);
			
			log("海尔服务器产品列表共计"+n+"条,分"+haierTotalPage+"页");
			log("");
			log("当前处理第"+haierPageIndex+"页");
			
			haierProductIndex = 0;
			haierProductList = xml.ProductDataList.DesignOnLineProduct;
			log("当前页有"+haierProductList.length()+"条数据");
			
			dealHaierProduct();
		}
		
		//--------------------------------------------------------------------------------
		private var currHaierProduct:XML;
		
		private function dealHaierProduct():void
		{
			if(haierProductIndex < haierProductList.length())
			{
				log("开始处理第"+haierProductIndex+"条数据");
				var haierProduct:XML = haierProductList[haierProductIndex++];
				currHaierProduct = haierProduct;
				_dealHaierProduct(haierProduct);
			}
			else if(haierPageIndex < haierTotalPage)
			{
				clearLog();
				getHaierProductList(++haierPageIndex,haierPageSize);
			}
			else
			{
				log("全部处理完成");
			}
		}
		
		/**
		<DesignOnLineProduct>
			<SysNo>21599</SysNo>
			<ID>A0A-003-0H8</ID>
			<EditDate>2013-10-08T15:14:12.45</EditDate>
			<BrandName_Ch>台电</BrandName_Ch>
			<BrandName_En>Teclast</BrandName_En>
			<Name>台电 TECLAST 酷闪32GB 晶彩 U盘&lt;font color='red'&gt;&lt;/font&gt;</Name>
			<ProductTag>台电 TECLAST 酷闪 32 GB 晶彩</ProductTag>
			<Type>CF32GBNCU-B2</Type>
			<CateName>U盘--Flash disk</CateName>
			<Price>0.000000</Price>
			<ShopPrice>225.000000</ShopPrice>
			<SmallPrice>222.000000</SmallPrice>
			<Discount>-3.000000</Discount>
			<SmallPic>http://images01.rrs.com/neg/P80/S0V-20G-19C.jpg</SmallPic>
			<ProductURL>http://www.rrs.com/Product/A0A-003-0H8</ProductURL>
			<SellerID>153</SellerID>
			<SellerName>上海鹿鸠家具有限公司</SellerName>
		</DesignOnLineProduct>
		 */
		private function _dealHaierProduct(haierProduct:XML):void
		{
			//var s:String = "#"+(new Date()).toTimeString();
			var s:String = "";
			
			var SysNo:String = haierProduct.SysNo + s;
			var sku_id:String = haierProduct.ID;
			var EditDate:String = haierProduct.EditDate;
			var BrandName_Ch:String = haierProduct.BrandName_Ch + s;
			var BrandName_En:String = haierProduct.BrandName_En + s;
			var Name:String = haierProduct.Name + s;
			Name = replace(Name,/&lt;/g,"<");
			Name = replace(Name,/&gt;/g,">");
			Name = replace(Name,/<(.*)>/g,"");						
			//log(Name);
			
			var ProductTag:String = haierProduct.ProductTag + s;
			var Type:String = haierProduct.Type + s;
			var CateName:String = haierProduct.CateName + s;
			var Price:String = haierProduct.Price + s;
			var ShopPrice:String = haierProduct.ShopPrice + s;
			var SmallPrice:String = haierProduct.SmallPrice + s;
			var Discount:String = haierProduct.Discount + s;
			var SmallPic:String = haierProduct.SmallPic + s;
			var ProductURL:String = haierProduct.ProductURL + s;
			var SellerID:String = haierProduct.SellerID + s;
			var SellerName:String = haierProduct.SellerName + s;
			
			var localID:String=null;
			
			var localProduct:Object = searchLocalProductBySKU(sku_id);
			if(localProduct!=null)
			{
				var localDate:String = localProduct.p_edit_date;
				//EditDate = "#"+EditDate;
				//EditDate = s;
				if(localDate!=EditDate)
				{
					localID = localProduct.id;
					log("编辑本地产品 id:"+localID+" 上次更新时间："+localDate);
					log("海尔产品SKU_ID："+sku_id+" 海尔产品编辑时间："+EditDate);
					
					updateMallProductInfo(localID,SysNo,sku_id,EditDate,BrandName_Ch,BrandName_En,Name,ProductTag,Type,CateName,Price,ShopPrice,SmallPrice,Discount,SmallPic,ProductURL,SellerID,SellerName);
				}
				else
				{
					dealHaierProduct();
				}
			}
			else
			{
				log("添加产品到本地");
				log("海尔产品SKU_ID："+sku_id+" 海尔产品编辑时间："+EditDate);
				updateMallProductInfo(localID,SysNo,sku_id,EditDate,BrandName_Ch,BrandName_En,Name,ProductTag,Type,CateName,Price,ShopPrice,SmallPrice,Discount,SmallPic,ProductURL,SellerID,SellerName);
				
			}
		}
		
		//--------------------------------------------------------------------------------------------
		private function updateMallProductInfo(localID,SysNo,sku_id,EditDate,BrandName_Ch,BrandName_En,Name,ProductTag,Type,CateName,Price,ShopPrice,SmallPrice,Discount,SmallPic,ProductURL,SellerID,SellerName):void
		{
			try
			{
				var gateway:RemotingConnection = new RemotingConnection(serverURL);
				var res:Responder = new Responder(onUpdateMallProductInfoOK,onUpdateMallProductInfoError);
				if(localID!=null)
				{
					gateway.call("product.updateMallProductInfo",res,localID,sku_id,SysNo,EditDate,BrandName_Ch,BrandName_En,Name,ProductTag,Type,CateName,Price,ShopPrice,SmallPrice,Discount,SmallPic,ProductURL,SellerID,SellerName);
				}
				else
				{
					gateway.call("product.createNewMallProduct",res,SysNo,sku_id,EditDate,BrandName_Ch,BrandName_En,Name,ProductTag,Type,CateName,Price,ShopPrice,SmallPrice,Discount,SmallPic,ProductURL,SellerID,SellerName);
				}			
			}catch(e:*)
			{
				dealHaierProduct();
			}
		}
		
		private function onUpdateMallProductInfoOK(result:Object):void
		{
			var s:String = String(result);
			log("添加或编辑产品完成:"+s);
			if(s=="0")
			{
				log(currHaierProduct);
			}
			dealHaierProduct();
		} 
		
		private function onUpdateMallProductInfoError(result:Object):void
		{
			var s:String = String(result);
			log("添加或编辑产品失败:"+s);
			dealHaierProduct();
		}
		
		//--------------------------------------------------------------------------------------------
		private function getLocalProductList():void
		{
			log("获取本地服务器产品列表");
			var gateway:RemotingConnection = new RemotingConnection(serverURL);
			gateway.call("product.listAllProduct",new Responder(onGetLocalProductList,onError));
		}
		
		private function onGetLocalProductList(result:Object):void
		{
			log("本地服务器产品列表获取完成");
			
			localProducts = DataParser.resultToArray(result,false);
			log("本地服务器产品列表长度："+localProducts.length);
			
			getHaierProductList(++haierPageIndex,haierPageSize);
		} 
		
		private function onError(result:Object):void
		{
			log("获取本地服务器产品列表出错");
		}
		
		//--------------------------------------------------------------------------------------------
		private function searchLocalProductBySKU(sku:String):Object
		{
			var a:Array = localProducts;
			for each(var o:Object in a)
			{
				var s:String = o.p_sku_id;
				if(s==sku)
				{
					return o;
				}
			}
			return null;
		}
		
		private function log(s:String):void
		{
			trace(s);
			txt.appendText(s+"\n");
			txt.scrollV = txt.maxScrollV;
		}
		
		private function clearLog():void
		{
			txt.text = "";
		}
		
		private function replace(s:String,r:RegExp,s2):String
		{
			s = s.replace(r,s2);
			return s;
		}
	}
}












