package
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Debug;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.core.events.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.loaders.events.TexturesLoaderEvent;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import xuan3D.a3d8.A3DOC;
	
	public class Main extends MovieClip
	{
		
		//10.14更新
		private var F3DPath:String;
		private var ModlePath:String;
		private var MiniModlePath:String;
		private var PublicMaterialPath:String;
		private var SmallImagesPath:String;
		private var mainXml:XML;
		private var houseUrl:String;
		
		private var materialNum:int;
		private var materialNew:int;
		
		private var changeList:Array;
		private var oldChangeNum:int;
		
		public var editTypeBtn:MovieClip;
		public var log_mc:MovieClip;
		
		public var isEdit:Boolean = false; //编辑模式		
		public var layout:Object3D;
		
		private var scene:Object3D = new Object3D();
		private var camera:Camera3D;
		private var cameraDy:Camera3D;
		//private var controller:SimpleObjectController;
		private var cameraController:A3DOC;
		private var meshController:A3DOC;
		
		private var stage3D:Stage3D;
		
		public var meshVec:Vector.<Object3D> = new Vector.<Object3D>;
		public var lightVec:Vector.<Object3D> = new Vector.<Object3D>;
		
		private var loadMeshLength:int;
		private var loadMeshNew:int = 0;
		
		private var timer:Timer = new Timer(100, 0);
		
		public function Main()
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
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeyDown);
			loadXml();
		}
		
		//载入户型配置
		private function loadXml():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			urlLoader.load(new URLRequest("HouseData.xml"))
		}
		
		private function xmlLoadError(e:IOErrorEvent):void
		{
			trace(e);
		}
		
		private function daeLoadError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE, onColladaLoadMod);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, daeLoadError);
			
			log("daeLoadError:"+e.toString());
			loadNext();
		}
		
		private function f3dLoadError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE, xmlLoadedF3D);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, f3dLoadError);
			
			log("f3dLoadError:"+e.toString());
			loadNext();
		}
		
		private function xmlLoaded(e:Event):void
		{
			var urlloader:URLLoader = e.target as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE, xmlLoaded);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			urlloader.close();
			
			//var s:String = String(e.target.data);
			
			mainXml = new XML(e.target.data);
			//log(mainXml.toXMLString());
			
			F3DPath = mainXml.House.HouseInfo.F3DPath;
			ModlePath = mainXml.House.HouseInfo.ModlePath;
			MiniModlePath = mainXml.House.HouseInfo.MiniModlePath;
			PublicMaterialPath = mainXml.House.HouseInfo.PublicMaterialPath;
			SmallImagesPath = mainXml.House.HouseInfo.SmallImagesPath;
			loadMeshLength = mainXml.House.ObjectList[0].Object.length();
			houseUrl = ModlePath + "/" + mainXml.House.HouseInfo.ModelFile + "/" + mainXml.House.HouseInfo.ModelFile + ".dae";
			setUI();
		}
		
		private function setUI():void
		{
			// Camera and view
			camera = new Camera3D(1, 1000);
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera.view.hideLogo();
			camera.view.backgroundAlpha = .5;
			addChildAt(camera.view, 0);
			// Initial position
			camera.rotationX = -130 * Math.PI / 180;
			camera.y = -30;
			camera.z = 85;
			camera.debug = true;
			
			//camera.fov -= 50;
			//controller = new SimpleObjectController(stage, camera, 80);
			cameraController = new A3DOC(stage, camera, 80);
			cameraController.checkCollisions = true;
			cameraController.startMouseLook();
			cameraController.unbindAll();
			cameraController.bindKey(Keyboard.W, A3DOC.ACTION_FORWARD);//w
			cameraController.bindKey(Keyboard.S, A3DOC.ACTION_BACK);//s
			cameraController.bindKey(Keyboard.A, A3DOC.ACTION_LEFT);//a
			cameraController.bindKey(Keyboard.D, A3DOC.ACTION_RIGHT);//d
			
			cameraController.bindKey(Keyboard.R, A3DOC.ACTION_LEFT_ROTATE_X);//r
			cameraController.bindKey(Keyboard.F, A3DOC.ACTION_RIGHT_ROTATE_X);//f
			
			cameraController.bindKey(Keyboard.T, A3DOC.ACTION_UP);//t
			cameraController.bindKey(Keyboard.G, A3DOC.ACTION_DOWN);//g
			
			cameraController.bindKey(Keyboard.Q, A3DOC.ACTION_LEFT_ROTATE_Z);//q
			cameraController.bindKey(Keyboard.E, A3DOC.ACTION_RIGHT_ROTATE_Z);//e
			cameraController.bindKey(Keyboard.SHIFT, A3DOC.ACTION_ACCELERATE);
			
			//controller.controlMode = A3DOC.MODE_ROUND;
			
			meshController = new A3DOC(stage, null, 80);
			//meshController.disable();
			meshController.unbindAll();
			meshController.bindKey(Keyboard.LEFTBRACKET, A3DOC.ACTION_LEFT_ROTATE_X);//r
			meshController.bindKey(Keyboard.RIGHTBRACKET, A3DOC.ACTION_RIGHT_ROTATE_X);//f
			
			meshController.bindKey(Keyboard.UP, A3DOC.ACTION_FORWARD);
			meshController.bindKey(Keyboard.DOWN, A3DOC.ACTION_BACK);
			meshController.bindKey(Keyboard.LEFT, A3DOC.ACTION_LEFT);
			meshController.bindKey(Keyboard.RIGHT, A3DOC.ACTION_RIGHT);
			
			
			scene.addChild(camera);
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
			
			stage.addChild(camera.diagram);
		}
		
		private function changeMouseMode(e:MouseEvent):void
		{
			if (editTypeBtn.currentFrame == 1)
			{
				editTypeBtn.gotoAndStop(2);
				isEdit = true;
			}
			else
			{
				editTypeBtn.gotoAndStop(1);
				isEdit = false;
			}
		}
		
		private function onContextCreate(e:Event):void
		{
			log("onContextCreate");
			
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			
			var loaderCollada:URLLoader = new URLLoader();
			loaderCollada.dataFormat = URLLoaderDataFormat.TEXT;
			loaderCollada.addEventListener(Event.COMPLETE, onHouseColladaLoad);
			loaderCollada.load(new URLRequest(houseUrl));
			
			stage.addEventListener(Event.ENTER_FRAME, onenterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function a3dLoadTest(e:Event):void
		{
			var parser:ParserA3D = new ParserA3D();
			parser.parse((e.target as URLLoader).data);
		}
		
		private function onHouseColladaLoad(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onHouseColladaLoad);
			urlLoader.close();
			
			
			changeList = new Array();
			//loadNext();
			//return;
			
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(urlLoader.data), ModlePath + "/" + mainXml.House.HouseInfo.ModelFile + "/", false);
			
			layout = new Object3D();
			//layout.useShadow = true;
			scene.addChild(layout);
			
			cameraController.checkObject = layout;
			
			//设置环境光
			var len:int = parser.hierarchy.length;
			for (var i:int = 0; i < parser.lights.length; i++)
			{
				if (parser.lights[i] is AmbientLight)
				{
					var ambientLightXml:AmbientLight = parser.lights[i] as AmbientLight;
					var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
					ambientLightXml.color -= 4278190080;
					ambientLight.color = ambientLightXml.color;
					ambientLight.intensity = 1;
					layout.addChild(ambientLight);
				}
			}
			
			setMesh(parser, layout);
			setLight(parser, layout);
			//layout.useShadow = true;
			loadLight();
			
			//上传所有scene的数据给显卡
			for each (var resource:Resource in scene.getResources(true))
			{
				resource.upload(stage3D.context3D);
				//resource.dispose();
			}
		}
		
		private function loadLight():void
		{
			var len:int = mainXml.House.LightList.Light.length()
			for (var i:int = 0; i < len; i++)
			{
				var lightObj:Object3D = new Object3D();
				if (mainXml.House.LightList.Light[i].Type == "DirectionalLight")
				{
					var arrDir:Array = mainXml.House.LightList.Light[i].Parm.split(",");
					var lightDir:DirectionalLight = new DirectionalLight(0xffffff);
					lightDir.x = mainXml.House.LightList.Light[i].X;
					lightDir.y = mainXml.House.LightList.Light[i].Y;
					lightDir.z = mainXml.House.LightList.Light[i].Z;
					lightDir.rotationX = mainXml.House.LightList.Light[i].RX;
					lightDir.rotationY = mainXml.House.LightList.Light[i].RY;
					lightDir.rotationZ = mainXml.House.LightList.Light[i].RZ;
					lightDir.color = arrDir[3];
					lightDir.lookAt(arrDir[0], arrDir[1], arrDir[2]);
					lightObj.addChild(lightDir);
				}
				else if (mainXml.House.LightList.Light[i].Type == "OmniLight")
				{
					var arrOmni:Array = mainXml.House.LightList.Light[i].Parm.split(",");
					var lightOmni:OmniLight = new OmniLight(0xffffff, arrOmni[1], arrOmni[2]);
					lightOmni.x = mainXml.House.LightList.Light[i].X;
					lightOmni.y = mainXml.House.LightList.Light[i].Y;
					lightOmni.z = mainXml.House.LightList.Light[i].Z;
					lightOmni.rotationX = mainXml.House.LightList.Light[i].RX;
					lightOmni.rotationY = mainXml.House.LightList.Light[i].RY;
					lightOmni.rotationZ = mainXml.House.LightList.Light[i].RZ;
					lightOmni.color = arrOmni[0];
					lightOmni.intensity = 1;
					lightObj.addChild(lightOmni);
				}
				else if (mainXml.House.LightList.Light[i].Type == "SpotLight")
				{
					var arrSpot:Array = mainXml.House.LightList.Light[i].Parm.split(",");
					var lightSpot:SpotLight = new SpotLight(arrSpot[0], arrSpot[1], arrSpot[2], arrSpot[3], arrSpot[4]);
					lightSpot.x = mainXml.House.LightList.Light[i].X;
					lightSpot.y = mainXml.House.LightList.Light[i].Y;
					lightSpot.z = mainXml.House.LightList.Light[i].Z;
					lightSpot.rotationX = mainXml.House.LightList.Light[i].RX;
					lightSpot.rotationY = mainXml.House.LightList.Light[i].RY;
					lightSpot.rotationZ = mainXml.House.LightList.Light[i].RZ;
					lightSpot.lookAt(arrSpot[5], arrSpot[6], arrSpot[7])
					//lightOmni.intensity = 10;
					lightObj.addChild(lightSpot);
				}
				scene.addChild(lightObj);
				lightVec.push(lightObj);
			}
		}
		
		private var meshOver:Boolean = false;
		private function setMesh2(parser:ParserA3D, obj3D:Object3D,dir:String):void
		{
			_setMesh(parser.objects, obj3D,dir);
		}
		private function setMesh(parser:ParserCollada, obj3D:Object3D):void
		{
			_setMesh(parser.objects, obj3D);
		}
		private function _setMesh(objects:Vector.<Object3D>, obj3D:Object3D,dir:String=""):void
		{
			var length:int = objects.length;
			materialNum = 0;
			materialNew = 0;
			for (var k:int = 0; i < length; i++ ) {
				if (objects[i] is Mesh)
				{
					materialNum++;
				}
			}
			
			for (var i:int = 0; i < length; i++)
			{
				meshOver = false;
				if (objects[i] is Mesh)
				{
					var mesh:Mesh = objects[i] as Mesh;
					if (mesh.name == null)
					{
						mesh.name = objects[i - 1].name;
					}
					//var diffuse:ExternalTextureResource = mesh.getSurface(0).material["textures"]["diffuse"];
					//if (diffuse != null)
					//{
					//	diffuse.url = dir + diffuse.url;
					//	trace("diffuse.url:",diffuse.url);
					//}
					
					var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
					for (var j:int = 0; j < mesh.numSurfaces; j++)
					{
						var surface:Surface = mesh.getSurface(j);
						var material:ParserMaterial = surface.material as ParserMaterial;
						if (material != null)
						{
							var diffuse:ExternalTextureResource = material.textures["diffuse"];
							var opacity:ExternalTextureResource = material.textures["transparent"];
							if (diffuse != null)
							{
								var a:Array = diffuse.url.split("/");
								if(a.length==1)
								{
									diffuse.url = dir + diffuse.url;
								}
								
								trace("diffuse.url:",diffuse.url);
								
								textures.push(diffuse);
								
								if (opacity != null)
								{
									a = opacity.url.split("/");
									if(a.length==1)
									{
										opacity.url = dir + opacity.url;
									}
									
									trace("opacity.url:",opacity.url);
									textures.push(opacity);
								}
								
								var texureMat:VertexLightTextureMaterial;
								if (mesh.name.search("floor_") != 0)
								{
									texureMat = new VertexLightTextureMaterial(diffuse, opacity, 1);
								}
								else
								{
									texureMat = new VertexLightTextureMaterial(diffuse, opacity, 1);
								}
								surface.material = texureMat;
							}
						}
					}
					
					// Loading of textures
					var texturesLoader:TexturesLoader = new TexturesLoader(stage3D.context3D);
					texturesLoader.addEventListener(TexturesLoaderEvent.COMPLETE, texturesLoaded);
					texturesLoader.loadResources(textures);
					
					mesh.doubleClickEnabled = true;
					mesh.addEventListener("doubleClick",onMeshDoubleClick);
					mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, meshMouseDown);
					obj3D.addChild(mesh);
				}
				meshOver = true;
			}
		}
		
		private function onMeshDoubleClick(e:MouseEvent3D):void
		{
			var target:Object = e.target
			var meshName:String = target.parent.name;
			if (meshName == null)
			{
				meshName=target.name;
			}
			trace("onMeshDoubleClick:",meshName);
		}
		
		//延迟加载
		
		private function texturesLoaded(e:TexturesLoaderEvent):void
		{
			var tloader:TexturesLoader = e.target as TexturesLoader;
			tloader.removeEventListener(TexturesLoaderEvent.COMPLETE, texturesLoaded);
			tloader.cleanAndDispose();
			
			materialNew++;
			trace("materialNum:" + materialNum + ", materialNew:" + materialNew)
			
			if(meshOver){
				if (materialNew == materialNum)
				{
					e.target.removeEventListener(TexturesLoaderEvent.COMPLETE, texturesLoaded);
					timer.addEventListener(TimerEvent.TIMER, loadOver);
					timer.start();
				}
			}
		}
		
		private function loadOver(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, loadOver);
			timer.stop();
			loadNext();
		}
		
		private var daePath:String;
		private var daeName:String;
		private var daeObjId:String;
		
		private function loadNext():void
		{
			log("\rloadNext:"+loadMeshNew);
			log("\r\n");
			
			if(loadMeshNew>69){
				//return;
			}
			
			if (loadMeshNew < loadMeshLength)
			{
				if (mainXml.House.ObjectList.Object[loadMeshNew].Z != "-100")
				{				
					//trace(F3DPath + "/" + mainXml.House.ObjectList.Object[loadMeshNew].File + ".F3D")
					var str:String = F3DPath + "/" + mainXml.House.ObjectList.Object[loadMeshNew].File + ".F3D";
					oldChangeNum = 0;
					
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, xmlLoadedF3D);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, f3dLoadError);
					urlLoader.load(new URLRequest(str));
					
					loadMeshNew++;
					
					log("start load f3d:"+str);
				}
				else
				{
					loadMeshNew++;
					loadNext();
				}
			}
		}
		
		private function xmlLoadedF3D(e:Event):void
		{
			log("f3d loaded!\r");
			e.target.removeEventListener(Event.COMPLETE, xmlLoadedF3D);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, f3dLoadError);
			
			var xml:XML = new XML(e.target.data);
			//trace(xml.Object.Info.ModelFile);
			daePath = xml.Object.Info.Material;
			
			if (daePath == "")
			{
				daePath = ModlePath + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + "/";
			}
			
			daeName = xml.Object.Info.ProductName;
			daeObjId = xml.Object.Info.ProductID;
			
			var url:String = ModlePath + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + ".dae";
			//var url:String = ModlePath + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + ".A3D";
			
			var loaderCollada:URLLoader = new URLLoader();
			loaderCollada.dataFormat = URLLoaderDataFormat.TEXT;
			//loaderCollada.dataFormat = URLLoaderDataFormat.BINARY;
			loaderCollada.addEventListener(Event.COMPLETE, onColladaLoadMod);
			loaderCollada.addEventListener(IOErrorEvent.IO_ERROR,daeLoadError);
			loaderCollada.load(new URLRequest(url));
			log("start load dae:"+url);
		}
		
		private function onColladaLoadMod(e:Event):void
		{
			log("dae loaded!\r");
			var urlloader:URLLoader = e.target as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE, onColladaLoadMod);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR, daeLoadError);
			urlloader.close();
			
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(urlloader.data), daePath, false);
			
			//var parser:ParserA3D = new ParserA3D();
			//parser.parse(urlloader.data);
			
			var mod:Object3D = new Object3D();
			mod.name = mainXml.House.ObjectList.Object[loadMeshNew - 1].File + "&^" + oldChangeNum + "&^" + daeName + "&^" + daeObjId;
			mod.x = mainXml.House.ObjectList.Object[loadMeshNew - 1].X / 20;
			mod.y = mainXml.House.ObjectList.Object[loadMeshNew - 1].Y / 20;
			mod.z = mainXml.House.ObjectList.Object[loadMeshNew - 1].Z / 20;
			mod.rotationX = mainXml.House.ObjectList.Object[loadMeshNew - 1].RX * Math.PI / 180;
			mod.rotationY = mainXml.House.ObjectList.Object[loadMeshNew - 1].RY * Math.PI / 180;
			mod.rotationZ = mainXml.House.ObjectList.Object[loadMeshNew - 1].RZ * Math.PI / 180;
			if (mainXml.House.ObjectList.Object[loadMeshNew - 1].EditEnable)
			{
				changeList.push(mod.name);
			}
			scene.addChild(mod);
			var dir:String = ModlePath + "/" + mainXml.House.ObjectList.Object[loadMeshNew - 1].File + "/" + "images/";
			//setMesh2(parser, mod,dir);
			setMesh(parser, mod);
			
			meshVec.push(mod);
			
			for each (var resource:Resource in scene.getResources(true))
			{
				resource.upload(stage3D.context3D);
				//resource.dispose();
			}
		}
		
		private function setLight(parser:ParserCollada, obj3D:Object3D):void
		{
			var len:int = parser.hierarchy.length;
			for (var i:int = 0; i < parser.lights.length; i++)
			{
				if (parser.lights[i] is SpotLight)
				{
					var light:SpotLight = parser.lights[i] as SpotLight;
					light.color -= 4278190080;
					light.intensity = 0.4;
					for (var j:int = 0; j < len; j++)
					{
						if (parser.hierarchy[j] == parser.lights[i])
						{
							light.lookAt(parser.hierarchy[j + 1].x, parser.hierarchy[j + 1].y, parser.hierarchy[j + 1].z);
						}
					}
					obj3D.addChild(light);
				}
				if (parser.lights[i] is OmniLight)
				{
					var lightOmn:OmniLight = parser.lights[i] as OmniLight;
					lightOmn.color -= 4278190080;
					lightOmn.intensity = 0.4;
					obj3D.addChild(lightOmn);
				}
				if (parser.lights[i] is DirectionalLight)
				{
					var lightDir:DirectionalLight = parser.lights[i] as DirectionalLight;
					lightDir.color -= 4278190080;
					lightDir.intensity = 0.4;
					for (j = 0; j < len; j++)
					{
						if (parser.hierarchy[j] == parser.lights[i])
						{
							lightDir.lookAt(parser.hierarchy[j + 1].x, parser.hierarchy[j + 1].y, parser.hierarchy[j + 1].z);
						}
					}
					obj3D.addChild(lightDir);
				}
			}
		}
		
		private var box:Box;
		private var currentObj3D:Object3D;
		private var changeTypeName:String;
		private var changeTypeNum:int;
		private var debugObject:Object3D;
		private var debugMode:int = Debug.BOUNDS;
		
		private function meshMouseDown(e:MouseEvent3D):void
		{
			//trace(e.target.parent.name)
			var target:Object = e.target
			var meshName:String = target.parent.name;
			if (meshName == null) {
				meshName=target.name;
			}
			else
			{
				//target = target.parent;
			}
			
			editTypeBtn.daeName.text = meshName;
			
			if(target is Object3D)
			{
				//trace("meshMouseDown target:",target);
				if(debugObject)
				{
					this.camera.removeFromDebug(debugMode,debugObject);
				}
				var o3d:Object3D = target as Object3D;
				this.camera.addToDebug(debugMode,o3d);
				debugObject = o3d;
				meshController.object = o3d;
			}
			
			/*
			if (changeList.indexOf(e.target.parent.name) != -1)
			{
				scene.removeChild(e.target.parent)
				changeTypeName = e.target.parent.name.split("&^")[0];
				var editArr:Array = mainXml.House.ObjectList.Object.(File == changeTypeName).EditList.split(",");
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, xmlLoadedF3DCh);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
				changeTypeNum = int(e.target.parent.name.split("&^")[1]) + 1;
				var str:String = F3DPath + "/" + editArr[changeTypeNum] + ".F3D";
				if (changeTypeNum < editArr.length)
				{
					urlLoader.load(new URLRequest(str));
				}
			}
			//*/
		}
		
		private function xmlLoadedF3DCh(e:Event):void
		{
			var urlloader:URLLoader = e.target as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE, xmlLoadedF3DCh);
			urlloader.close();
			
			
			var xml:XML = new XML(e.target.data);
			//trace(xml.Object.Info.ModelFile);
			daePath = xml.Object.Info.Material;
			
			var editArr:Array = mainXml.House.ObjectList.Object.(File == changeTypeName).EditList.split(",");
			var fileName:String = editArr[changeTypeNum];
			if (daePath == "")
			{
				daePath = ModlePath + "/" + fileName + "/";
			}
			daeName = xml.Object.Info.ProductName;
			daeObjId = xml.Object.Info.ProductID;
			
			var loaderCollada:URLLoader = new URLLoader();
			loaderCollada.dataFormat = URLLoaderDataFormat.TEXT;
			loaderCollada.addEventListener(Event.COMPLETE, onColladaLoadModCh);
			loaderCollada.load(new URLRequest(ModlePath + "/" + fileName + "/" + fileName + ".dae"));
		}
		
		private function onColladaLoadModCh(e:Event):void
		{
			var urlloader:URLLoader = e.target as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE, onColladaLoadModCh);
			urlloader.close();
			
			var editArr:Array = mainXml.House.ObjectList.Object.(File == changeTypeName).EditList.split(",");
			var fileName:String = editArr[changeTypeNum];
			
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(urlloader.data), daePath, false);
			
			var mod:Object3D = new Object3D();
			//mod.receiveShadow = true;
			mod.name = changeTypeName + "&^" + changeTypeNum + "&^" + daeName + "&^" + daeObjId;
			mod.x = mainXml.House.ObjectList.Object[loadMeshNew - 1].X / 20;
			mod.y = mainXml.House.ObjectList.Object[loadMeshNew - 1].Y / 20;
			mod.z = mainXml.House.ObjectList.Object[loadMeshNew - 1].Z / 20;
			mod.rotationX = mainXml.House.ObjectList.Object[loadMeshNew - 1].RX * Math.PI / 180;
			mod.rotationY = mainXml.House.ObjectList.Object[loadMeshNew - 1].RY * Math.PI / 180;
			mod.rotationZ = mainXml.House.ObjectList.Object[loadMeshNew - 1].RZ * Math.PI / 180;
			
			if (mainXml.House.ObjectList.Object[loadMeshNew - 1].EditEnable)
			{
				changeList.push(mod.name);
			}
			
			scene.addChild(mod);
			setMesh(parser, mod);
			meshVec.push(mod);
			
			for each (var resource:Resource in scene.getResources(true))
			{
				resource.upload(stage3D.context3D);
			}
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			scene.removeEventListener(MouseEvent3D.MOUSE_MOVE, onSceneMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function onSceneMouseMove(e:MouseEvent3D):void
		{
			currentObj3D.x = e.localX;
			currentObj3D.y = e.localY;
		}
		
		//上传给显卡的方法
		private function uploadResources(resources:Vector.<Resource>):void
		{
			for each (var resource:Resource in resources)
			{
				resource.upload(stage3D.context3D);
			}
		}
		
		private function onenterFrame(e:Event):void
		{
			cameraController.update();
			meshController.update();
			camera.render(stage3D);
		}
		
		private function onResize(e:Event = null):void
		{
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
			editTypeBtn.x = 3;
			editTypeBtn.y = stage.stageHeight - 30;
		}
		
		//===============================================================================================
		private function onkeyDown(e:KeyboardEvent):void
		{
			//if(e.keyCode==Keyboard.SPACE)
			//trace(e.ctrlKey);
			if(e.ctrlKey == false || e.altKey == false)
			{
				return;
			}
			
			if(e.keyCode==53)//ctrl + 5
			{
				log_mc.visible = !log_mc.visible;
			}
				//else if(e.keyCode==Keyboard.C)
			else if(e.keyCode==54)//ctrl + 6
			{
				clearLog();
			}
		}
		
		private function log(s:String):void
		{
			log_mc.log(s);
			trace(s);
		}
		
		private function clearLog():void
		{
			log_mc.clearLog();
		}
	}
}
