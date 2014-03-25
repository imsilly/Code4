package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;
	import flash.text.TextField;
	import mdm.Forms;
	
    dynamic public class CtrlBoxA extends MovieClip
    {
        public var a1:MovieClip;
        public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
        public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		private var parentMC:MovieClip;
		public var caption_txt:TextField;
		private var listA:Array = new Array("","场景的显示与隐藏","界面上各种按钮的显示与隐藏","下载户型(毛坯房)","下载样板间","更换视角-正交俯视","更换视角-普通漫游","更换视角-第一视角");
		private var listB:Array = new Array("","新建","保存","导出","撤销","恢复","画墙","建房","分割","挖空");
		private var listC:Array = new Array("","","","","","","","");
		public function CtrlBoxA()
        {
			parentMC = MovieClip(this.parent);
			for(var i:int=1;i<=9;i++)
			{				
				var target = list_mc.getChildByName("c"+i);
				trace(target);
				target.captionName = listB[i];
				AppUtils.makeButton(target, onMouseAction);
			}
        }
		private function tipsMe(value)
		{
			//caption_txt.text = "快捷方式:"+value;
		}

        public function onMouseAction(e) : void
        {
            if (e.type == MouseEvent.CLICK)
            {
                var targetName:String =e.target.name.toString();
				
				switch(targetName)
				{
					case "c1":
						//新建
						break;
					case "c2":
						//保存
						break;						
					case "c3":
						//导出
						sendMsg("UI_MSG_108");
						break;
					case "c4":
						//撤销
						sendMsg("UI_MSG_201");
						break;
					case "c5":
						//恢复
						sendMsg("UI_MSG_202");
						break;
					case "c6":
						//画墙
						sendMsg("UI_MSG_302");
						break;
					case "c7":
						//建房
						sendMsg("UI_MSG_303");
						break;
					case "c8":
						//分割
						sendMsg("UI_MSG_304");
						break;
					case "c9":
						//挖空
						sendMsg("UI_MSG_305");
						break;						
						
					default:break;
				}
            }
            if (e.type == MouseEvent.ROLL_OVER)
            {
				trace(1);
                TweenMax.to(e.target, 0.3, {alpha:0.5});
				tipsMe(e.currentTarget.captionName);
            }
            if (e.type == MouseEvent.ROLL_OUT)
            {
                TweenMax.to(e.target, 0.3, {alpha:1});
				tipsMe("");
            }           
        }

		function sendMsg(msg:String)
		{
			var myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
			log("callDLL return:"+myReturn);
		}
		
        public function showMe()
        {
			this.parent.setChildIndex(this, this.parent.numChildren - 1); 
            if (list_mc.visible)
            {
                list_mc.visible = false;
            }
            else
            {
                list_mc.visible = true;
            }           
        }
		
		private function log(value:String)
		{
			parentMC.log(value);
		}
    }
}
