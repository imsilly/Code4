package app.png
{
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.SWFData;
	import com.codeazur.as3swf.tags.ITag;
	import com.codeazur.as3swf.tags.TagDefineBitsJPEG3;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class Png2Swf
	{
		[Embed(source="pngSwf.swf",mimeType="application/octet-stream")]
		public var PngSwf:Class;
		
		private var swf:SWF;
		
		private var pngTag:TagDefineBitsJPEG3;
		
		private var pngEn:JPEG3Encoder = new JPEG3Encoder();
		
		public function Png2Swf()
		{
			trace("new Png2Swf");
			swf = new SWF(new PngSwf());
			pngTag = getPngTag(swf.tags);
			if(pngTag==null)
			{
				throw new Error("Png2Swf 嵌入的模板文件不含PNG图片")
			}
		}
		
		public function encode(bmpData:BitmapData,quality:int=90):ByteArray
		{
			pngEn.encode(bmpData,quality);
			
			swf.frameSize.xmax = bmpData.width * 20;
			swf.frameSize.ymax = bmpData.height * 20;
			
			pngTag.bitmapData.length = 0;
			pngTag.bitmapData.writeBytes(pngEn.bitmapData);
			
			pngTag.bitmapAlphaData.length = 0;
			pngTag.bitmapAlphaData.writeBytes(pngEn.bitmapAlphaData);

			var swfData:SWFData = new SWFData();
			swf.publish(swfData);
			
			return swfData;
		}
		
		private function getPngTag(tags:Vector.<ITag>):TagDefineBitsJPEG3
		{
			var len:int = tags.length;
			for(var i:int=0;i<len;i++){
				var tag:ITag = tags[i];
				
				if(tag is TagDefineBitsJPEG3){
					return tag as TagDefineBitsJPEG3;
				}
			}
			return null;
		}
		//=========================================================================================
		private static var _own:Png2Swf;
		//--------------------------------------------------------------------------
		public static function own():Png2Swf
		{
			if(!_own)
			{
				_own = new Png2Swf();
			}
			return _own;
		}
		
		//=========================================================================================
	}
}