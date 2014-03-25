package app.utils
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.*;

	public class AppUtils
	{
		
		public static var levelInfoArray:Array = new Array( { levelID:0, needExp:0, plusCoinB:0, plusPopu:0 },
															{ levelID:1, needExp:50, plusCoinB:500, plusPopu:1 },
															{ levelID:2, needExp:220, plusCoinB:110, plusPopu:1 },
															{ levelID:3, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:4, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:5, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:6, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:7, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:8, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:9, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:10, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:11, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:12, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:13, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:14, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:15, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:16, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:17, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:18, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:19, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:20, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:21, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:22, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:23, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:24, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:25, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:26, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:27, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:28, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:29, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:30, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:31, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:32, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:33, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:34, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:35, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:36, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:37, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:38, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:39, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:40, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:41, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:42, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:43, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:44, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:45, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:46, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:47, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:48, needExp:1, plusCoinB:500, plusPopu:1 },
															{ levelID:49, needExp:1, plusCoinB:500, plusPopu:0 },
															{ levelID:50, needExp:1, plusCoinB:500, plusPopu:0 } );
															
		public static var resInfoArray:Array = new Array({id:1,resID:7,name:"奴仆",minX:50,maxX:1800,minY:130,maxY:450,content:"21,22",fileName:"1001",price:600,createTime:20,resContent:"无家可归的小僵尸，只需支付他少量的佣金，就会很努力的为你工作。"},
												{id:2,resID:52,name:"女妖",minX:50,maxX:1800,minY:130,maxY:450,content:"21,24,30",fileName:"1011",price:600,createTime:50,resContent:"游荡于荒山野岭的小女妖。可爱，笨拙。"},
												{id:3,resID:12,name:"工人",minX:50,maxX:1800,minY:130,maxY:450,content:"21,24,30",fileName:"1002",price:1200,createTime:60,resContent:"这些僵尸比普通僵尸要多掌握一些生产的技能，他们生前也许就是工人。"},
												{id:4,resID:13,name:"小偷",minX:50,maxX:1800,minY:130,maxY:450,content:"25,26",fileName:"1003",price:600,createTime:20,resContent:"身体瘦弱，好吃懒做。那么当盗贼也许对于他们来说是最佳的职业。当你有了盗贼的时候，就可以去好友家偷东西了。"},
												{id:5,resID:14,name:"强盗",minX:50,maxX:1800,minY:130,maxY:450,content:"22,26,28",fileName:"1004",price:600,createTime:60,resContent:"身体强壮，喜欢欺凌弱小。雇佣他们去抢夺吧！"},
												{id:6,resID:15,name:"管家",minX:50,maxX:1800,minY:130,maxY:450,content:"30,31,35,36",fileName:"1005",price:1200,createTime:300,resContent:"城堡的管理者，尽职尽责的忠实管家。想尽快提高家族的收入，选他是最正确的。"},
												{id:7,resID:16,name:"主教",minX:50,maxX:1800,minY:130,maxY:450,content:"23,27,30,32,37",fileName:"1006",price:1500,createTime:300,resContent:"高级圣职人员，权利和地位的象征。家族成员的精神领袖。"},
												{id:8,resID:17,name:"城防士兵",minX:50,maxX:1800,minY:130,maxY:450,content:"23,31,32,35,35,37",fileName:"1007",price:600,createTime:1800,resContent:"城堡的守护者，具有严格的纪律性，训练有素的战士。城防士兵的职责就是守护城堡的安全。"},
												{id:9,resID:18,name:"女战士",minX:50,maxX:1800,minY:130,maxY:450,content:"30,33,34,40,37,39",fileName:"1008",price:800,createTime:20,resContent:"勇猛无比，智慧过人的女战士，是经验丰富的斗士，是坚韧的战争机器。"},
												{id:10,resID:19,name:"骑士",minX:50,maxX:1800,minY:130,maxY:450,content:"25,27,32,34,35,43",fileName:"1009",price:1200,createTime:60,resContent:"忠诚的象征，每一个骑士都以骑士精神作为守则，是英雄的化身。"},
												{id:11,resID:20,name:"圣殿武士",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1010",price:1500,createTime:480,resContent:"家族荣誉的维护者，离神最近的战士。为了维护家族的荣誉，不惜牺牲一切。"},
												{id:12,resID:59,name:"狼人",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1012",price:1400,createTime:600,resContent:"背负着被诅咒的命运，在月圆之夜，展露自己真实，狂野的一面。"},
												{id:13,resID:58,name:"吸血鬼",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1013",price:1700,createTime:2700,resContent:"既不是神，也不是魔鬼，更不是人。他们对红颜色的饮料有着极大的偏好。"},
												{id:14,resID:60,name:"狼王",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1014",price:2100,createTime:3600,resContent:"创说中狼人的领袖，比普通狼人强壮，巨大，也比普通的狼人饭量大。"},
												{id:15,resID:47,name:"城防士官长",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1015",price:2300,createTime:3600,resContent:"城防士兵的直接管理者，负责家族城堡的防御工作。"},
												{id:16,resID:48,name:"魔鬼公主",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1016",price:2500,createTime:4500,resContent:"地域魔鬼的女儿，总认为自己是最美的女人，但是却一直找不到男朋友。因为见过她的人，都不想再见到她。"},
												{id:17,resID:49,name:"魔鬼执政官",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1017",price:2400,createTime:900,resContent:"魔鬼世界的最高统领，执掌生杀大权。也成为鬼王。"},
												{id:18,resID:50,name:"地狱男爵",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1018",price:2600,createTime:7200,resContent:"传说中从地狱来到人间的魔鬼，喜欢抽烟喝酒，喜欢搞破坏。"},
												{id:19,resID:51,name:"德古拉伯爵",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1019",price:3000,createTime:10800,resContent:"昼伏夜出，长生不老，他阴险的面色永远苍白，美丽的嘴角永远藏着獠牙和牺牲者的鲜血。可是他又衣着考究，彬彬有礼，散发出女人无法抗拒的魅力。"},
												{id:20,resID:61,name:"吸血女伯爵",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1020",price:3200,createTime:18000,resContent:"喜欢同性，喜欢红色的饮料的一个怪女人。总是喜欢到处惹是非，却乐此不疲。"},
												{id:21,resID:62,name:"威廉公爵",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1021",price:7000,createTime:86400,resContent:"威廉古堡的精神领袖。你无法知道哪座城堡是真正的威廉古堡，你也无法了解威廉公爵是怎样的一个人。"},
												{id:50,resID:46,name:"饰品1",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"46",price:200},
												{id:51,resID:64,name:"饰品2",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:52,resID:65,name:"饰品3",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:53,resID:66,name:"饰品4",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:54,resID:67,name:"饰品5",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:55,resID:68,name:"饰品6",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:56,resID:69,name:"饰品7",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:50,resID:70,name:"饰品8",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:51,resID:71,name:"饰品9",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:52,resID:112,name:"饰品10",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:53,resID:113,name:"饰品11",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:54,resID:114,name:"饰品12",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:55,resID:115,name:"饰品13",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:56,resID:116,name:"饰品14",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:50,resID:117,name:"饰品15",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:51,resID:118,name:"饰品16",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:52,resID:119,name:"饰品17",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:53,resID:120,name:"饰品18",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:54,resID:121,name:"饰品19",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:55,resID:122,name:"饰品20",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:56,resID:123,name:"饰品21",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:50,resID:124,name:"饰品22",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:51,resID:125,name:"饰品23",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:52,resID:126,name:"饰品24",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"",price:200},
												{id:53,resID:127,name:"饰品25",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1004",price:200},
												{id:54,resID:128,name:"饰品26",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1005",price:200},
												{id:55,resID:129,name:"饰品27",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1006",price:200},
												{id:50,resID:130,name:"饰品28",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1001",price:200},
												{id:51,resID:131,name:"饰品29",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1002",price:200},
												{id:52,resID:132,name:"饰品30",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1003",price:200},
												{id:53,resID:133,name:"饰品31",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1004",price:200},
												{id:54,resID:134,name:"饰品32",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1005",price:200},
												{id:55,resID:135,name:"饰品33",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1006",price:200},
												{id:56,resID:136,name:"饰品34",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1007",price:200},
												{id:50,resID:137,name:"饰品35",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1001",price:200},
												{id:51,resID:138,name:"饰品36",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1002",price:200},
												{id:52,resID:139,name:"饰品37",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1003",price:200},
												{id:53,resID:140,name:"饰品38",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1004",price:200},
												{id:54,resID:141,name:"饰品39",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1005",price:200},
												{id:55,resID:142,name:"饰品40",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1006",price:200},
												{id:56,resID:143,name:"饰品41",minX:50,maxX:1800,minY:130,maxY:450,content:"28,30,37,36,39,40",fileName:"1007",price:200},
												{id:50,resID:144,name:"饰品42",minX:50,maxX:1800,minY:-50,maxY:500,content:"28,30,37,36,39,40",fileName:"1001",price:200},
												{id:51,resID:145,name:"饰品43",minX:50,maxX:1800,minY:-50,maxY:500,content:"28,30,37,36,39,40",fileName:"1002",price:200},
												{id:52,resID:146,name:"饰品44",minX:50,maxX:1800,minY:-50,maxY:500,content:"28,30,37,36,39,40",fileName:"1003",price:200});
		
												
		public function AppUtils()
		{
			
		}
		public static function getLevelInfoArray():Array
		{
			for (var i = 3; i <levelInfoArray.length; i++)
			{				
				var levelID = int(levelInfoArray[i].levelID);
				levelInfoArray[i].needExp = 100 + 60 * (levelID - 1) + 10 * levelID * (levelID + 1) * (levelID - 1);
				levelInfoArray[i].plusCoinB = int(levelInfoArray[i - 1].plusCoinB) + levelID * 5;
			}
			return levelInfoArray;
		}
		public static function makeButton(which_mc:MovieClip,mouseFunction:Function,isMouseChildren:Boolean=false):void
		{
			which_mc.buttonMode = true;
			which_mc.useHandCursor = true;
			which_mc.mouseEnabled = true;
			which_mc.enabled = true;
			which_mc.mouseChildren = isMouseChildren;
			which_mc.addEventListener(MouseEvent.ROLL_OVER,mouseFunction);
			which_mc.addEventListener(MouseEvent.ROLL_OUT, mouseFunction);
			which_mc.addEventListener(MouseEvent.MOUSE_OUT,mouseFunction);
			which_mc.addEventListener(MouseEvent.MOUSE_DOWN,mouseFunction);
			which_mc.addEventListener(MouseEvent.MOUSE_UP,mouseFunction);
			which_mc.addEventListener(MouseEvent.MOUSE_OUT,mouseFunction);
			which_mc.addEventListener(MouseEvent.CLICK,mouseFunction);
			which_mc.addEventListener(MouseEvent.MOUSE_MOVE,mouseFunction);
		}
		public static function gcButton(which_mc:MovieClip,mouseFunction:Function):void
		{
			which_mc.buttonMode = false;
			which_mc.useHandCursor = false;
			which_mc.mouseEnabled = false;
			which_mc.mouseChildren = false;
			which_mc.enabled = false;
			which_mc.removeEventListener(MouseEvent.ROLL_OVER,mouseFunction);
			which_mc.removeEventListener(MouseEvent.ROLL_OUT, mouseFunction);
			which_mc.removeEventListener(MouseEvent.MOUSE_OUT,mouseFunction);
			which_mc.removeEventListener(MouseEvent.MOUSE_DOWN,mouseFunction);
			which_mc.removeEventListener(MouseEvent.MOUSE_UP,mouseFunction);
			which_mc.removeEventListener(MouseEvent.MOUSE_OUT,mouseFunction);
			which_mc.removeEventListener(MouseEvent.CLICK,mouseFunction);
			which_mc.removeEventListener(MouseEvent.MOUSE_MOVE,mouseFunction);
		}		
		public static function gc():void
		{
			try
			{
				var local = new LocalConnection();
				local.connect("foo");
				local.connect("foo");
			}
			catch (e: * )
			{
				//trace("");
			}
		}
		public static function getDataByID(resID:String):Object
		{
			for (var i:int=0; i<resInfoArray.length; i++)
			{
				if (resInfoArray[i].resID  == int(resID))
				{
					return resInfoArray[i];
				}
			}
			return null;
		}
		public static function getResInfoArray():Array
		{
			return resInfoArray;
		}
		public static function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		public static function getURL(url):void {
			var urlRequest:URLRequest=new URLRequest(url);
			var mode:String="_blank";			
			navigateToURL(urlRequest,mode);
		}

	}
}