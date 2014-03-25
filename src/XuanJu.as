package
{
	import alternativa.engine3d.core.events.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.materials.*;
	
	import app.Controller;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import xuanju.core.Engine3D;
	import xuanju.utils.Log;
	
	
	
	
	
	[SWF(backgroundColor="#313F60", frameRate="60", width="800", height="600")]
	
	public class XuanJu extends Sprite
	{
		public var editTypeBtn:MovieClip;
		public var log_mc:MovieClip;
		
		private var engine3D:Engine3D;
		private var modelReplaceList:Array;
		
		private var modelView:Sprite;
		//===============================================================================================
		public function XuanJu()
		{
			addEventListener(Event.ADDED_TO_STAGE, addStage);
		}
		private function addStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addStage);
			init();
		}
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Log.isLog = true;
			
			var s1:Sprite = new Sprite();
			this.addChild(s1);
			//s1.x = 200;
			
			engine3D = new Engine3D(s1,stage.stageWidth,stage.stageHeight,0,Controller.getInstance().autoStart);
			engine3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			engine3D.addEventListener("ChangeProduct",onEngineModelDown);
			engine3D.addEventListener("unSelectProduct",onEngineUnSelectProduct);
			//engine3D.addEventListener("modelLoaded",onModelLoaded);
			engine3D.addEventListener("texturesLoaded",onModelLoaded);
			
			modelView = new Sprite();
			//modelView.y = 300;
			//modelView.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			//modelView.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.addChild(modelView);
			engine3D.modelViewContainer = modelView;
			modelView.visible = false;
			//engine3D.addEventListener(MouseEvent3D.MOUSE_DOWN,onEngineModelDown);
		}
		//===============================================================================================
		private function onMouseDown(e:MouseEvent):void
		{
			var s:Sprite = e.currentTarget as Sprite;
			s.startDrag();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			var s:Sprite = e.currentTarget as Sprite;
			s.stopDrag();
		}
		
		//===============================================================================================
		private function onContextCreate(e:Event):void
		{
			log("onContextCreate");
			
			engine3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			engine3D.startRendering();
			engine3D.showObjectInfo = false;
			//engine3D.setCamera(new Vector3D(0,-50,600),new Vector3D(-170,0,-180));
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeyDown);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function radian(n:Number):Number
		{
			return n*Math.PI/180;
		}
		//===============================================================================================
		private function onEngineModelDown(e:Event):void
		{
			modelReplaceList = engine3D.modelReplaceList;
		}
		private function onEngineUnSelectProduct(e:Event):void
		{
			modelReplaceList = null;
		}
		//===============================================================================================
		private var isloaded:Boolean = false;
		private function onModelLoaded(e:Event):void
		{
			log("onModelLoaded:",this.engine3D.numLoadedModel,this.engine3D.numTotalModel);
			
			if(this.engine3D.numLoadedModel==this.engine3D.numTotalModel && !this.isloaded)
			{
				this.engine3D.loadModelToPreview("ServiceableChest_c-7-10");
				this.engine3D.startPreviewModel();
				this.isloaded = true;
/*
				engine3D.moveCamera2(
//					"11,-129,59,-90,0,-45" 
//					+",11,-129,59,-90,0,0" 
//					+",11,-129,59,-90,0,45" 
//					+",11,-129,59,-90,0,90" 
//					+",11,-129,59,-90,0,135" 
//					+",11,-129,59,-90,0,180" 
//					+",11,-129,59,-90,0,225" 
//					+",11,-129,59,-90,0,270" 
				  "135,-129,59,-90,0,-90" 
				//+",135,-129,59,-90,0,-180" 
				+",135,-260,59,-90,0,-180" 
				//+",135,-260,59,-90,0,-270" 
				//+",135,-260,59,-90,0,0" 
				//+",135,-129,59,-90,0,0" 
				+",135,-129,59,-90,0,-270" 
				//+",135,-129,59,-90,0,-180" 
				//+",11,-129,59,-90,0,-180" 
				+",11,-129,59,-90,0,-90"
				//+",11,-129,59,-90,0,-90"
				+",135,-129,59,-90,0,-90" 
				);
				//135,-129,59,-90,0,-90,135,-260,59,-90,0,-180,135,-129,59,-90,0,-270,11,-129,59,-90,0,-90,135,-129,59,-90,0,-90

//*/
			}			
		}
		//===============================================================================================
		//===============================================================================================
		private function onResize(e:Event = null):void
		{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			engine3D.setViewSize(w,h);
			//editTypeBtn.x = 3;
			//editTypeBtn.y = h - 30;
		}
		
		//===============================================================================================
		private function onkeyDown(e:KeyboardEvent):void
		{
			//log("onkeyDown:",e.keyCode);
			if(e.keyCode==Keyboard.SPACE)
			{
				if(modelReplaceList)
				{
					var index:int = Math.random()*modelReplaceList.length;
					var modelName:String = modelReplaceList[index];
					engine3D.replaceModel(modelName);
				}
			}
			else if(e.keyCode==Keyboard.DELETE)
			{
				engine3D.deleteModel();
			}
			
			if(e.ctrlKey == false || e.altKey == false)
			{
				return;
			}
			//log("onkeyDown2:",e.keyCode);
			if(e.keyCode==53)//ctrl + 5
			{
				//log_mc.visible = !log_mc.visible;
			}
				//else if(e.keyCode==Keyboard.C)
			else if(e.keyCode==54)//ctrl + 6
			{
				clearLog();
			}
			else if(e.keyCode==55)//ctrl + alt + 7：切换物体信息窗口显示
			{
				engine3D.showObjectInfo = !engine3D.showObjectInfo;
				engine3D.modelMoveEnable = engine3D.showObjectInfo;
			}
			else if(e.keyCode==51)
			{
				engine3D.stopPreviewModel();
				engine3D.startRendering();
			}
			else if(e.keyCode==52)
			{
				engine3D.stopRendering();
				engine3D.startPreviewModel();
				//trace("modelView:",modelView.width,modelView.height);
				//var bmpData:BitmapData = new BitmapData(modelView.width,modelView.height,true,0);
				//bmpData.draw(modelView);
				//var bmp:Bitmap=new Bitmap(this.engine3D.getModelViewBitmapData());
				//this.addChild(bmp);
			}
		}
		
		private function log(... args):void
		{
			Log.log(args);
			//log_mc.log(s);
		}
		
		private function clearLog():void
		{
			//log_mc.clearLog();
		}
		//===============================================================================================
	}
}