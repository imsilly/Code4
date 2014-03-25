package com.Silly.Model
{
	import com.LightMVC.model.ModelLocator;
	import com.Silly.vo.Message;
	import com.Silly.vo.VideoList;
	import com.Silly.vo.VideoPlayer;
	import com.Silly.vo.ScreenInfo;
	
	public class ModelLocator implements com.LightMVC.model.ModelLocator
	{
		public var ServerURL:String = "";
		public var SmallPicPath:String = ServerURL+"SmallPic/";
		public var VideoPath:String = "Video/";
		public var videoList:VideoList = new VideoList();	//当前视频列表
		public var videoPlayer:VideoPlayer = new VideoPlayer("缺省动画.flv");
		public var screenInfo:ScreenInfo = new ScreenInfo();
		
		private static var instance:com.Silly.Model.ModelLocator;
		
		public static function getInstance():com.Silly.Model.ModelLocator
		{
			if(null==instance)
			{
				instance = new com.Silly.Model.ModelLocator();
			}
			return instance;
		}
		public function ModelLocator()
		{
		}
		
	}
}