package app.view
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class HotPointList extends Sprite
	{
		public var _content:Sprite;
		private var _mask:Sprite;
		private var _dragger:Sprite;
		private var _draggerBg:Sprite;
		
		private var _easeRate:Number;
		private var _direction:String;
		private var _bounds:Rectangle;
		private var _setSize:Boolean;
		private var _scrollValue:Number;
		private var _orgY:Number;
		private var _orgX:Number;
		private var _ratio:Number;
		private var _ty:Number;
		private var _Width:Number;
		private var _Height:Number;
		/**  *   
		* @param content    Sprite which will be scrolled by ContentScroller  
		* @param mask    Sprite which will mask the scrolling content (mask should be set in another class)  
		* @param scrollbar   Sprite which will be used to do the scrolling  
		* @param ease    Number which controls amount of ease in scrolling. Higher the number, the more ease. 0 or 1 will have no ease.  
		* @param direction   String specifying the direction of the scroll. Can either be "vertical" or "horizontal".     
		* @param setDraggerSize  Boolean which decides whether to stretch the width or height of the scrollbar in proportion to the amount of content.  
		*   */
		public function HotPointList (ease:Number = 1, direction:String = "vertical", setDraggerSize:Boolean = false, Width:Number = 530, Height:Number = 450, content:MovieClip = null)
		{
			_setSize=setDraggerSize;
			_easeRate = ease;
			_Width = Width;
			_Height = Height;
			//content.x = 0;
			//content.y = 0;
			setScrollBarUI(content);
			
			if (_easeRate<1)
			{
				_easeRate=1;
			}
			_direction=direction;
			switch (_direction)
			{
				case "horizontal" :
					initHorizontal ();
					break;
				case "vertical" :
					initVertical ();
					break;
				default :
					initVertical ();
					//trace("CONTENT SCROLLER ERROR: direction argument should be either \"vertical\" or \"horizontal\".");
					break;
			}
			//stage.addChild(this);
		}
		private function setMCLoader():void
		{
			_content = new Sprite();
			addChild(_content);
		}
		private function setMCMask(tWidth:Number = 530, tHeight:Number = 450):void
		{
			_mask=drawRect(tWidth,tHeight,0x000000);
			addChild(_mask);
		}
		private function setScrollBar(sbWidth:Number = 5, tWidth:Number = 530, tHeigth:Number = 450):void
		{
			
			_dragger=drawRect(sbWidth,sbWidth,0x999999);
			_draggerBg = drawRect(sbWidth,tHeigth,0x333333);
			_dragger.x = _draggerBg.x =tWidth - 20;
			_orgY=_dragger.y;
			_dragger.buttonMode = true;
			this.addChild(_draggerBg);
			this.addChild(_dragger);
			//addEventListener(MouseEvent.MOUSE_UP, onDragger, false, 0, true);
		}
		private function setScrollBarUI(c:MovieClip):void
		{
			setMCLoader();
			setMCMask(_Width, _Height);
			setScrollBar(5, _Width, _Height);
			_content.mask = _mask;
			if (c)
			{
				_content.addChild(c);
				c.x = 0,
				c.y = 0;
			}
			
		}
		private function drawRect (w:Number, h:Number, col:uint):Sprite
		{
			var s:Sprite=new Sprite();
			s.graphics.beginFill (col);
			s.graphics.drawRect (0, 0, w, h);
			s.graphics.endFill ();
			return s;
		}
		private function drawRoundRect(w:Number, h:Number, col:uint):Sprite
		{
			var s:Sprite=new Sprite();
			s.graphics.beginFill(col);
			//s.graphics.lineStyle(1, 0x333333);
			s.graphics.drawRoundRect(0, 0, w, h, 5, 5);
			s.graphics.endFill();
			return s;
		}
		private function onDragger(e:MouseEvent):void
		{
			trace("I am here.");
		}
		//水平方向，如果遮罩宽度小于内容宽度，按照二者的百分比来设置拖动条的宽度，设置滑动拖拽的区域。
		private function initHorizontal ():void
		{
			if (_mask.width < (_content.width - 1))
			{
				_dragger.visible = true;
				_draggerBg.visible = true;
				if (_setSize)
				{
					_dragger.width = Math.ceil((_mask.width / _content.width) * _mask.width);
				}
				_scrollValue=_mask.width-_dragger.width;
				_orgX=_dragger.x;
				_bounds=new Rectangle(_orgX,_dragger.y,_scrollValue,0);
				addListeners ();
			}
			else
			{
				//不显示拖动条。
				_dragger.visible = false;
				_draggerBg.visible = false;
			}
		}
		private function initVertical ():void
		{
			if (_mask.height < (_content.height - 1))
			{
				_dragger.visible = true;
				_draggerBg.visible = true;
				if (_setSize)
				{
					_dragger.height = Math.ceil((_mask.height / _content.height) * _draggerBg.height);
				}
				_scrollValue=_draggerBg.height-_dragger.height;
				//trace(_scrollValue);
				//_orgY=_dragger.y;
				_bounds=new Rectangle(_dragger.x,_orgY,0,_scrollValue);
				addListeners ();
			}
			else
			{
				//不显示拖动条。
				_dragger.visible = false;
				_draggerBg.visible = false;
			}
		}
		private function addListeners ():void
		{
			_dragger.addEventListener (MouseEvent.MOUSE_DOWN, onDraggerPress, false, 0, true);
			_dragger.addEventListener (MouseEvent.MOUSE_UP, onDraggerUp, false, 0, true);
		}
		private function onDraggerPress (me:MouseEvent):void
		{
			_ratio = (_dragger.y - _orgY) / _scrollValue;
			_ty = _orgY - (_content.height - _mask.height) * _ratio;
			_dragger.startDrag (false, _bounds);
			if (_direction=="vertical")
			{
				_dragger.addEventListener (MouseEvent.MOUSE_MOVE, onVerticalScroll, false, 0, true);
				_dragger.stage.addEventListener (MouseEvent.MOUSE_MOVE, onVerticalScroll, false, 0, true);
			}
			else if (_direction == "horizontal")
			{
				_dragger.addEventListener (MouseEvent.MOUSE_MOVE, onHorizontalScroll, false, 0, true);
				_dragger.stage.addEventListener (MouseEvent.MOUSE_MOVE, onHorizontalScroll, false, 0, true);
			}
			_dragger.stage.addEventListener (MouseEvent.MOUSE_UP, onDraggerUp, false, 0, true);
		}
		private function onDraggerUp (me:MouseEvent):void
		{
			_dragger.stopDrag ();
			_dragger.removeEventListener (MouseEvent.MOUSE_MOVE, onVerticalScroll);
			_dragger.stage.removeEventListener (MouseEvent.MOUSE_MOVE, onVerticalScroll);
			_dragger.removeEventListener (MouseEvent.MOUSE_MOVE, onHorizontalScroll);
			_dragger.stage.removeEventListener (MouseEvent.MOUSE_MOVE, onHorizontalScroll);
			_dragger.stage.removeEventListener (MouseEvent.MOUSE_UP, onDraggerUp);
		}
		private function onVerticalScroll (me:MouseEvent):void
		{
			me.updateAfterEvent ();
			if (! _content.willTrigger(Event.ENTER_FRAME))
			{
				_content.addEventListener (Event.ENTER_FRAME, moveVertical, false, 0, true);
			}
		}
		private function onHorizontalScroll (me:MouseEvent):void
		{
			me.updateAfterEvent ();
			if (! _content.willTrigger(Event.ENTER_FRAME))
			{
				_content.addEventListener (Event.ENTER_FRAME, moveHorizontal, false, 0, true);
			}
		}
		private function moveVertical (e:Event):void
		{
			var ratio:Number = (_dragger.y - _orgY) / _scrollValue;
			var ty:Number = _orgY - (_content.height - _mask.height) * ratio;
			var dist:Number=ty-_content.y;
			var moveAmount:Number=dist/_easeRate;
			_content.y+=moveAmount;
			if (Math.abs(_content.y-ty)<1)
			{
				_content.removeEventListener (Event.ENTER_FRAME, moveVertical);
				_content.y=ty;
			}
		}
		private function moveHorizontal (e:Event):void
		{
			var ratio:Number = (_dragger.x - _orgX) / _scrollValue;
			var tx:Number = _orgX - (_content.width - _mask.width) * ratio;
			var dist:Number=tx-_content.x;
			var moveAmount:Number=dist/_easeRate;
			_content.x+=moveAmount;
			if (Math.abs(_content.x-tx)<1)
			{
				_content.removeEventListener (Event.ENTER_FRAME, moveHorizontal);
				_content.x=tx;
			}
		}
		
		//**************************
		public function addItem(item:MovieClip, x:Number = 0, y:Number = 0):void
		{
			//trace();
			_content.addChild(item);
			item.x = x;
			item.y = y;
			//trace(_content.height);
			initVertical ();
			
		}
		public function removeItem(item:MovieClip):void
		{
			var mc:MovieClip = this.parent as MovieClip;
			trace(mc.layerItemArr.length);
			
			_content.removeChild(item);
			//调整layerItem的位置
			for (var i:uint = 0; i < 0; i++)
			{
				
			}
			
			initVertical ();
			if (_dragger.y > _draggerBg.height - _dragger.height)
			{
				_dragger.y = _draggerBg.height - _dragger.height + _orgY;
			}
		}
	}
}