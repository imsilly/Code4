package app.utils
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class CustomScroller2 extends Sprite
	{
		public var _content:Sprite;
		private var _mask:Shape;
		private var _dragger:Sprite;
		private var _draggerBg:Shape;
		private var bgShp:Shape;
		
		private var _draggerWidth:int;
		private var dragDist:int;
		
		private var contentWidth:int;
		private var contentHeight:int;
		
		public function CustomScroller2(w:int, h:int, draggerWidth:int=8, dist:int=5)
		{
			super();
			
			_draggerWidth = draggerWidth;
			dragDist = dist;
			
			bgShp = new Shape();
			this.addChild(bgShp);
			bgShp.alpha = 0;
			
			_draggerBg = new Shape();
			this.addChild(_draggerBg);
			
			_dragger = new Sprite();
			this.addChild(_dragger);
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN,onDragStart);
			_dragger.buttonMode = true;
			
			_mask = new Shape();
			this.addChild(_mask);
			
			_content = new Sprite();
			this.addChild(_content);
			_content.mask = _mask;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			
			updateView(w,h);
		}
		
		//**************************
		public function addItem(item:DisplayObject, x:Number = 0, y:Number = 0):void
		{
			_content.addChild(item);
			item.x = x;
			item.y = y;
			
			updateDrager();
		}
		
		public function removeItem(item:DisplayObject):void
		{
			_content.removeChild(item);
			
			updateDrager();
		}
		
		public function updateView(w:int,h:int):void
		{
			if(contentWidth == w && contentHeight == h)return;
			//trace("updateView:"+w+"x"+h);
			contentWidth = w;
			contentHeight = h;
			
			drawGra(_mask.graphics,w,h,0);
			drawGra(bgShp.graphics,w,h,0);
			
			drawGra(_draggerBg.graphics,_draggerWidth,h,0x333333);
			
			_draggerBg.x = w + dragDist;
			_dragger.x = _draggerBg.x;
			
			updateDrager();
		}
		
		public function updateDrager():void
		{
			//trace("updateDrager");
			//trace("_content.height："+_content.height);
			//trace("_mask.height："+_mask.height);
			//trace("_draggerBg.height："+_draggerBg.height);
			if(_content.height>_mask.height)
			{
				_dragger.visible = true;
				_draggerBg.visible = true;
				
				var n:Number = _mask.height/_content.height;
				var th:int = _mask.height * n;
				
				if(th<_draggerWidth)th=_draggerWidth;
				
				drawGra(_dragger.graphics,_draggerWidth,th,0x999999);
				update();
			}
			else
			{
				_dragger.visible = false;
				_draggerBg.visible = false;
				_content.y = 0;
			}
		}
		
		private function update():void
		{
			var n:Number = _dragger.y / (_draggerBg.height - _dragger.height);
			var ty:Number = (_content.height - _mask.height) * n;
			_content.y = _mask.y - ty;
		}
		
		private function onDragStart(e:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			
			//_dragger.startDrag(false,new Rectangle(_draggerBg.x,_draggerBg.y,_draggerBg.x,_draggerBg.y+_draggerBg.height));
			_dragger.startDrag(false,new Rectangle(_draggerBg.x,_draggerBg.y,0,_draggerBg.height-_dragger.height));
		}
		
		private function onStageMouseMove(e:MouseEvent):void
		{
			update();
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			_dragger.stopDrag();
			
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			var n:int = _dragger.y - e.delta*5;
			if(n<0){
				n=0;
			}
			else if(n>_draggerBg.height-_dragger.height){
				n=_draggerBg.height-_dragger.height;
			}
			_dragger.y = n;
			update();
		}
		
		private function drawGra(gra:Graphics,w:int,h:int,color:uint):void
		{
			gra.clear();
			gra.beginFill(color);
			gra.drawRect(0,0,w,h);
			gra.endFill();
		}
	}
}