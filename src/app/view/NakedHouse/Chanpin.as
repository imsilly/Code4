package app.view.NakedHouse {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public dynamic class Chanpin extends MovieClip {
		private var picLoader:Loader=new Loader();
		private var hasBitmap:Boolean = false;//是否已经有了图片
		private var newUrl:String = "";
		private var _data:Object;
		public var totName:TextField;
		public var house_id:String;
		public var loadBox:MovieClip;
		public var tip_txt:TextField;
		private var baseURL:String = "http://image.72xuan.com/house";

		public function Chanpin() {
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(e) {
			// constructor code
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			init();
		}
		private function init() {
			tip_txt.visible = false;
			loadBox.addChild(picLoader);
		}
		private function resetMyself() {
			totName.text = _data.house_name;
			house_id = _data.house_id;
			setPic( _data.house_pic);
		}

		private function setPic(url:String) {
			picLoader.unload();
			if (url != null && url != "") {
				//tip_txt.visible = true;
				var strArr = _data.house_pic.split("|");
				var picInt:int = int(int(strArr[0]) / 1000);
				newUrl= baseURL + "/" + picInt + "/160_120/" + strArr[1];
				try {
					picLoader.load(new URLRequest(newUrl));
					picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completePic);
				}catch (e) {
					trace(e.message);
				}
			}else {
				tip_txt.visible = true;
			}
		}
		private function completePic(e:Event) {
			tip_txt.visible = false;
		}

		public function set data(obj:Object):void {
			_data = obj;
			resetMyself();
			//trace(_data.house_id);
		}
		public function get data():Object {
			return _data;
		}

	}

}

