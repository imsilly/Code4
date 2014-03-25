package app.view
{
    import flash.display.*;
    import flash.events.*;
	import mdm.System;
    dynamic public class TopNav extends MovieClip
    {
		public var bg_mc:MovieClip;
        public function TopNav()
        {
        }

		public function onResizeAction()
		{
			var stageWidth = stage.stageWidth;
			var stageHeight = stage.stageHeight;
			bg_mc.right_mc.x = stageWidth-bg_mc.right_mc.width;
			bg_mc.mid_mc.width=stageWidth-bg_mc.right_mc.width-bg_mc.left_mc.width;
			log("onResizeAction:"+stageWidth+":"+stageHeight);
		}
		private function log(value)
		{
			MovieClip(this.parent).log(value);
		}
    }
}
