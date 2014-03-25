package app.utils
{   
	//import com.greensock.OverwriteManager;

    /**  
     * 数据处理，返回Object内容的Array   
     * @author Jack.Hu  
     *   
     */    
    public class DataParser   
    {   
           
        public function DataParser()   
        {   
        }   
        /**  
         * 根据XML转换成对象，并填充对应的值   
         * @param xml:描述对应数值的XML对象  
         * @return 返回成功填充数据的对象  
         *   
         */
        public static function resultToArray(result:Object,traceMe:Boolean=false):Array
        {   
            var list:Array = new Array();
			for (var i:int = 0; i < result["serverInfo"]["totalCount"]; i++)
			{
				var itemInfo:Object = new Object  ;
				for (var j:String in result["serverInfo"]["columnNames"])
				{
					var nodeName:String = result["serverInfo"]["columnNames"][j];
					var nodeValue:String = result["serverInfo"]["initialData"][i][j];
					itemInfo[nodeName] = nodeValue;
					if (traceMe)
					{
						trace(nodeName, nodeValue);
					}
				}
				list.push(itemInfo);
			}
			return list;
        }
		public static function parseXML2Array(value:*):Array
		{
			var _xmlList:XMLList = XMLList(value.children());
			var _itemArray:Array = new Array();
			for (var i:int = 0; i < _xmlList.length(); i++)
			{
				var itemChildren:XMLList = _xmlList[i].children();
				var itemInfo:* = new Object();
				for each (var item:XML in itemChildren)
				{
					itemInfo[item.localName()] = item;
				}
				_itemArray.push(itemInfo);
			}
			return _itemArray;
		}
		public static function parseXML2Obj(value:*):Object
		{			
			var xmlList = XML(value);
			var array:Array = parseXML2Array(xmlList);
			var obj:Object=new Object();
			for(var im in array[0])
			{
				obj[im] = array[0][im];
			}
			return obj;
		}
		public static function parseXML2Array2(value:XMLList):Array
		{
			var _xmlList:XMLList = XMLList(value);
			var _itemArray:Array = new Array();
			for (var i:int = 0; i < _xmlList.length(); i++)
			{
				var itemChildren:XMLList = _xmlList[i].children();
				var itemInfo:* = new Object();
				for each (var item:XML in itemChildren)
				{
					itemInfo[item.localName()] = item;
				}
				_itemArray.push(itemInfo);
			}
			return _itemArray;
		}
		//去除重复项
		public static var keys:Object = {};
		public static function removedDuplicates(item:Object, idx:uint, arr:Array):Boolean
		{
			if (keys.hasOwnProperty(item.data))
			{
				return false;
			}
			else
			{
				keys[item.data] = item;
				return true;
			}
		}

		public static function parseArray(value:Array):Array
		{
			keys = {};
			var newArray:Array = value.filter(removedDuplicates);
			return newArray;
		}		
    }   
}  