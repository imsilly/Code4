package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;
	import app.Controller;
	
    dynamic public class IntroBox extends MovieClip
    {
		public var list_mc:MovieClip;
		public function IntroBox()
        {
			for(var i:int=1;i<=3;i++)
			{				
				target = list_mc.getChildByName("c"+i);
				target.id=i;
				AppUtils.makeButton(target, onMouseAction);
			}
        }

        public function onMouseAction(e) : void
        {
            if (e.type == MouseEvent.CLICK)
            {
				
				Controller.getInstance().main.introAction(e.target.id);
            }
            if (e.type == MouseEvent.ROLL_OVER)
            {
                TweenMax.to(e.target, 0.3, {alpha:0.5});
            }
            if (e.type == MouseEvent.ROLL_OUT)
            {
                TweenMax.to(e.target, 0.3, {alpha:1});
            }           
        }
    }
}
