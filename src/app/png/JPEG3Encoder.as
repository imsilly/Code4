package app.png
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class JPEG3Encoder
	{
		public var bitmapData:ByteArray;
		public var bitmapAlphaData:ByteArray;
		
		public function JPEG3Encoder()
		{
		}
		
		public function encode(pngBitmapData:BitmapData,quality:int=80):ByteArray
		{
			bitmapAlphaData = getAlphaData(pngBitmapData);
			bitmapAlphaData.compress();
			
			var w:int = pngBitmapData.width;
			var h:int = pngBitmapData.height;
			var r:Rectangle = new Rectangle(0,0,w,h);
			var p:Point = new Point(0,0);
			
			var jpgData:BitmapData = new BitmapData(w,h,false,0);
			/*
			jpgData.copyChannel(pngBitmapData,r,p,BitmapDataChannel.RED,BitmapDataChannel.RED);
			jpgData.copyChannel(pngBitmapData,r,p,BitmapDataChannel.GREEN,BitmapDataChannel.GREEN);
			jpgData.copyChannel(pngBitmapData,r,p,BitmapDataChannel.BLUE,BitmapDataChannel.BLUE);
			//*/
			jpgData.copyPixels(pngBitmapData,r,p);
			
			var jpgEn:JPGEncoder = new JPGEncoder(quality);
			bitmapData = jpgEn.encode(jpgData);
			//bitmapData = jpgEn.encode(pngBitmapData);
			
			//var alphaData:BitmapData = new BitmapData(w,h,true,0);
			//alphaData.copyChannel(pngBitmapData,r,p,BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			
			//bitmapAlphaData = PNGEncoder.encode(alphaData);
			//bitmapAlphaData = jpgEn.encode(alphaData);
			
			return bitmapData;
		}
		
		private function getAlphaData(bmpData:BitmapData):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			
			var w:int = bmpData.width;
			var h:int = bmpData.height;
			for(var i:int=0;i<h;i++)
			{
				for(var j:int=0;j<w;j++)
				{
					var n:uint = bmpData.getPixel32(j,i) >> 24 & 0xFF;
					ba.writeByte(n);
				}
			}
			
			return ba;
		}
	}
}












