package app.vo{	
	public class  ProductVO{
		public var ID:String;	
		public var Name:String;
		public var Type:String;
		public var Price:String;
		public var Link:String;
		public var Image:String;
		public var Content:String;
		public var Memo:String;
		public function ProductVO() {
			
		}
		public function traceMe()
		{
			for each(im in this)
			{
				trace(im);
			}
		}
	}
}
