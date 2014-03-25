package app.utils
{
    import com.adobe.images.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class Upload extends EventDispatcher
    {
        public var serverPath:String = "http://192.168.1.6/snake/";
		public var progress:int = 0;
		public var targetMC:MovieClip=null;
		public var compress:int = 90;
		public var fileName:String="default";
		private var loader:URLLoader = new URLLoader();
		public static const UPLOAD_COMPLETE:String = "upload_complete";
		public static const UPLOAD_PROGRESS:String = "upload_progress";
		public static const UPLOAD_ERROR:String = "upload_error";
        public function Upload()
        {
			
        }
		
        public function createJPG()
        {
			if(null==targetMC)
			{
				dispatchEvent(new Event(UPLOAD_ERROR));
				return;
			}
            var bitmapData:BitmapData = null;
            var jpgEncoder:JPGEncoder = null;
            var byteArray:ByteArray = null;
            var urlRequestHeader:URLRequestHeader = null;
            var urlRequest:URLRequest = null;
            var urlLoader:URLLoader = null;
            bitmapData = new BitmapData(targetMC.width, targetMC.height);
            bitmapData.draw(targetMC);
            jpgEncoder = new JPGEncoder(compress);
            byteArray = jpgEncoder.encode(bitmapData);
            urlRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
            urlRequest = new URLRequest(serverPath + "upload-test.php?name=" + fileName + ".jpg");
            urlRequest.requestHeaders.push(urlRequestHeader);
            urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = byteArray;
            
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			loader.load(urlRequest);
        }
		private function loader_complete (e:Event):void {
			dispatchEvent(new Event(UPLOAD_COMPLETE));			
		}
		private function loader_progress(e:ProgressEvent):void {
			this.progress = int(loader.bytesLoaded/loader.bytesTotal*100);
			dispatchEvent(new Event(UPLOAD_PROGRESS));
		}
		private function loader_ioError(e:IOErrorEvent):void
		{
			dispatchEvent(new Event(UPLOAD_ERROR));
		}
    }
}
