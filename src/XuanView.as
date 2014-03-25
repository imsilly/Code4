package  {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.loaders.events.TexturesLoaderEvent;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.events.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.geom.Vector3D;
	import flash.net.LocalConnection;

	import flash.net.*;
	
	public class XuanView extends Sprite {
		private var camera:Camera3D;
		private var camera2:Camera3D;
		public var inputTxt:TextField;
		public var loadBtn:MovieClip;
		private var controller:SimpleObjectController;
		private var scene:Object3D = new Object3D();
		private var stage3D:Stage3D;
		
		private var objBase:Object3D;
		private var urlString:String;
		private var urlMatel:String="";
		private var server:LocalConnection=new LocalConnection();
		private var objBaseArr:Object3D;
		
		public function XuanView() {
			setStage();
		}
		private function setStage():void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			camera = new Camera3D(1, 100000);
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera.calculateRay(new Vector3D(600, 500, 0), new Vector3D(0, 0, 0), 100, 100);
			camera.view.hideLogo();
			camera.view.backgroundAlpha = .5;
			camera.view.backgroundColor = 0xffffff;
			addChildAt(camera.view, 0);
			
			camera2 = new Camera3D(1, 500);
			camera2.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera2.calculateRay(new Vector3D(600, 500, 0), new Vector3D(0, 0, 0), 100, 100);
			camera2.view.hideLogo();
			camera2.view.backgroundAlpha = .5;
			camera2.view.backgroundColor = 0xffffff;
			addChildAt(camera2.view, 0);
			// Initial position
			camera.rotationX = -130*Math.PI/180;
			camera.y = -30;
			camera.z = 85;
			//camera.fov -= 50;
			controller = new SimpleObjectController(stage, camera, 80);
			scene.addChild(camera);
			scene.addChild(camera2);
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
			
			
		}
		private function onContextCreate(e:Event):void {
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			loadBtn.addEventListener(MouseEvent.CLICK, isClick);
			inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, isKeyPress);
			inputTxt.addEventListener(MouseEvent.MOUSE_DOWN,setselAll);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame3D);
			stage.addEventListener(Event.RESIZE, onResize);
			try{
				server.connect("MessageFromDAE-Caller");
				server.client = this;
			}catch(e){
			}
			loadDAEforBase("z.DAE");
		}
		
		private function loadDAEforBase(urlString:String):void 
		{
			var loaderCollada:URLLoader = new URLLoader();
			loaderCollada.dataFormat = URLLoaderDataFormat.TEXT;
			loaderCollada.load(new URLRequest(urlString));
			loaderCollada.addEventListener(Event.COMPLETE, onA3DLoadBase);
			
		}
		private function onA3DLoadBase(e:Event):void 
		{
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML((e.target as URLLoader).data), "/", false);
			objBaseArr = new Object3D();
			scene.addChild(objBaseArr);

			var ambientLight2:AmbientLight = new AmbientLight(0xFFFFFF);
			ambientLight2.intensity = 1;
			scene.addChild(ambientLight2);
			
			_setMesh(parser.objects, objBaseArr);
			for each (var resource:Resource in scene.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
		}
		
		
		
		public function MsgReceiveAction(value:String)
		{
			logMsg(value);
		}
		private function logMsg(value:String)
		{
			inputTxt.text = value;
			loadBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		private function setselAll(e:MouseEvent):void 
		{
			inputTxt.setSelection(0,inputTxt.text.length)
		}
		
		private function isKeyPress(e:KeyboardEvent):void 
		{
			if(e.charCode==13){
				if ( inputTxt.text != "") {
					loadBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}else {
					inputTxt.text="您没有填入任何地址"
				}
			}
		}
		private function isClick(e:MouseEvent):void 
		{
			urlString = inputTxt.text;
			urlMatel = urlString.slice(0,urlString.lastIndexOf("\\")+1)+"\images";
			if ((urlString.indexOf(".dae") != -1)||(urlString.indexOf(".DAE") != -1)) {
				loadDAE(urlString);
			}else if ((urlString.indexOf(".a3d") != -1) || (urlString.indexOf(".A3D") != -1)) {
				loadA3D(urlString);
			}else {
				inputTxt.text="您没有输入正确的模型文件，请重新输入"
			}
		}
		
		private function loadDAE(urlStr:String):void 
		{
			if(objBase!=null){
				if (scene.contains(objBase)) {
					scene.removeChild(objBase);
				}
			}
			var loaderCollada:URLLoader = new URLLoader();
			loaderCollada.dataFormat = URLLoaderDataFormat.TEXT;
			loaderCollada.load(new URLRequest(urlString));
			loaderCollada.addEventListener(Event.COMPLETE, onColladaLoad);
		}
		private function onColladaLoad(e:Event):void 
		{
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML((e.target as URLLoader).data), urlMatel, false);
			objBase = new Object3D();
			scene.addChild(objBase);
			
			_setMesh(parser.objects, objBase);
			setLight(parser, objBase);
			for each (var resource:Resource in scene.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
		}
		
		
		private function loadA3D(urlStr:String):void 
		{
			if(objBase!=null){
				if (scene.contains(objBase)) {
					scene.removeChild(objBase);
				}
			}
			var loaderA3D:URLLoader = new URLLoader();
			loaderA3D.dataFormat = URLLoaderDataFormat.BINARY;
			loaderA3D.load(new URLRequest(urlString));
			loaderA3D.addEventListener(Event.COMPLETE, onA3DLoad);
		}
		private function onA3DLoad(e:Event) {
			var parser:ParserA3D = new ParserA3D();
			parser.parse((e.target as URLLoader).data);
			objBase = new Object3D();
			scene.addChild(objBase);
			
			_setMesh(parser.objects, objBase,urlMatel);
			for each (var resource:Resource in scene.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
		}
		
		private function _setMesh(objects:Vector.<Object3D>, obj3D:Object3D, dir:String = ""):void {
			
			var length:int = objects.length;
			
			for (var i:int = 0; i < length; i++)
			{
				if (objects[i] is Mesh) {
					
					var mesh:Mesh = objects[i] as Mesh;
					if (mesh.name == null)
					{
						mesh.name = objects[i - 1].name;
					}
					var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
					for (var j:int = 0; j < mesh.numSurfaces; j++) {
						var surface:Surface = mesh.getSurface(j);
						var material:ParserMaterial = surface.material as ParserMaterial;
					
						if (material != null){
							var diffuse:ExternalTextureResource = material.textures["diffuse"];
							var opacity:ExternalTextureResource = material.textures["transparent"];
							if (diffuse != null){
								var a:Array = diffuse.url.split("/");
								if(a.length==1){
									diffuse.url = dir +"/"+ diffuse.url;
								}
								textures.push(diffuse);
								if (opacity != null){
									a = opacity.url.split("/");
									if(a.length==1){
										opacity.url = dir +"/"+ opacity.url;
									}
									textures.push(opacity);
								}
								var texureMat:VertexLightTextureMaterial;
								if (mesh.name.search("floor_") != 0){
									texureMat = new VertexLightTextureMaterial(diffuse, opacity, 1);
								}
								else{
									texureMat = new VertexLightTextureMaterial(diffuse, opacity, 1);
								}
								surface.material = texureMat;
							}
						}
					}
					var texturesLoader:TexturesLoader = new TexturesLoader(stage3D.context3D);
					texturesLoader.addEventListener(TexturesLoaderEvent.COMPLETE, texturesLoaded);
					texturesLoader.loadResources(textures,true,false);
					obj3D.addChild(mesh);
				}
			}
		}
		
		//延迟加载
		private function texturesLoaded(e:TexturesLoaderEvent):void
		{
			var tloader:TexturesLoader = e.target as TexturesLoader;
			tloader.removeEventListener(TexturesLoaderEvent.COMPLETE, texturesLoaded);
			tloader.cleanAndDispose();
		}
		
		
		public function setLight(parser:ParserCollada,obj3D:Object3D) {
			var len:int = parser.hierarchy.length;
			for (var i:int = 0; i < parser.lights.length; i++ ) {
				if (parser.lights[i] is SpotLight) {
					var light:SpotLight = parser.lights[i] as SpotLight;
					light.color -= 4278190080;
					light.intensity = 0.5;
					for (var j:int = 0; j < len; j++ ) {
						if (parser.hierarchy[j] == parser.lights[i]) {
							light.lookAt(parser.hierarchy[j + 1].x, parser.hierarchy[j + 1].y, parser.hierarchy[j + 1].z);
						}
					}
					obj3D.addChild(light);
				}
				if (parser.lights[i] is OmniLight) {
					var lightOmn:OmniLight = parser.lights[i] as OmniLight;
					lightOmn.color -= 4278190080;
					lightOmn.intensity = 0.5;
					obj3D.addChild(lightOmn);
				}
				if (parser.lights[i] is DirectionalLight ) {
					var lightDir:DirectionalLight  = parser.lights[i] as DirectionalLight ;
					lightDir.color -= 4278190080;
					lightDir.intensity = 0.5;
					for (j = 0; j < len; j++ ) {
						if (parser.hierarchy[j] == parser.lights[i]) {
							lightDir.lookAt(parser.hierarchy[j + 1].x, parser.hierarchy[j + 1].y, parser.hierarchy[j + 1].z);
						}
					}
					obj3D.addChild(lightDir);
				}
			}
		}
		private function onEnterFrame3D(e:Event):void {
			controller.update();
			camera.render(stage3D);
			camera2.render(stage3D);
		}
		private function onResize(e:Event = null):void {
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
		
		
	}
}
