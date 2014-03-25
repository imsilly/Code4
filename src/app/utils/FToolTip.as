/** 
  * 提示框 
  * ibio的配色：0x58A6D7, 0xD8E4F4, 0x004080 
  * ibio-develop 
  * 2009-1-18 15:45 
  */ 
 package  app.utils{ 
         import flash.display.DisplayObject; 
         import flash.display.Stage; 
         import flash.events.MouseEvent; 
         import flash.text.TextField; 
         import flash.utils.Dictionary; 
         import flash.utils.Timer; 
         import flash.events.TimerEvent; 
          
         public class FToolTip { 
                 //与鼠标之间的间隔(px) 
                 public static var MARGIN_NUM:Number = 10; 
                 //延迟显示时间(ms) 
                 public static var TIME_DELAY_NUM:uint = 50; 
                 //中间文字与边框的间隔(px) 
                 public static var  PADDING_NUM:Number = 4; 
                 protected const SINGLETON_MSG:String = "单件模式的 ToolTip 已经创建！"; 
                 protected static var m_instance:ToolTip; 
                 protected var m_stage:Stage; 
                 protected var m_tipPanel:TextField; 
                 protected var m_currTarget:DisplayObject; 
                 protected var m_borderColor:uint = 0x000000; 
                 protected var m_bgColor:uint = 0xFFFFE1; 
                 protected var m_fontColor:uint = 0x000000; 
                 protected var m_timer:Timer; 
                 protected var m_maxWidth:Number = 400; 
                 protected var m_tipList:Dictionary; 
                  
                 function FToolTip() { 
                         if (m_instance != null) { 
                                 throw new Error(SINGLETON_MSG); 
                         } 
                         m_timer = new Timer(TIME_DELAY_NUM, 1); 
                         m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer_handler); 
                         m_tipList = new Dictionary(); 
                 } 
                  
                 public static function getInstance():ToolTip { 
                         if(m_instance == null){ 
                                 m_instance = new ToolTip(); 
                         } 
                         return m_instance; 
                 } 
                  
                 public function set stage(value:Stage):void { 
                         if (value) { 
                                 m_stage = value; 
                         } 
                 } 
                  
                 /** 
                  * 设置某个 MC 的提示框 
                  * @param       target<DisplayObject>： 当前添加提示对象 
                  * @param       content<String>：                需要提示的内容 
                  */ 
                 public function addTip(target:DisplayObject, content:String):void { 
                         //如果传递进来的 MC 已经在显示列表内，则自动获取当前的 stage 
                         //若没有，则需要手动获取当前的 stage 
                         if (m_stage == null) { 
                                 m_stage = target.stage; 
                         } 
                         //把当前的str保存起来 
                         m_tipList[target] = content; 
                         //把要显示的信息指向到这个按钮的事件上去 
                         target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver_handler); 
                         target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_handler); 
                 } 
                  
                 /** 
                  * 删除某 MC 的提示框 
                  * @param       target<DisplayObject>：  当前要删除的对象 
                  */ 
                 public function removeTip(target:DisplayObject):void { 
                         if (m_tipList[target]) { 
                                 target.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver_handler); 
                                 target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut_handler); 
                                 delete m_tipList[target]; 
                         } 
                 } 
                  
                 //设置边框，背景，字体颜色 
                 public function setColor(borderColor:uint, bgColor:uint, fontColor:uint):void { 
                         m_borderColor = borderColor; 
                         m_bgColor = bgColor; 
                         m_fontColor = fontColor; 
                 } 
                  
                 /** 
                  * 设置最大宽度，若超过此宽度，则自动换行 
                  */ 
                 public function set maxWidth(value:Number):void { 
                         m_maxWidth = uint(value); 
                 } 
                  
                 protected function onMouseOver_handler(e:MouseEvent):void { 
                         m_currTarget = e.currentTarget as DisplayObject; 
                         clearTip(); 
                         showTip(); 
                 } 
                  
                 protected function onMouseOut_handler(e:MouseEvent):void { 
                         clearTip(); 
                 } 
                  
                 protected function showTip():void{ 
                         m_timer.start(); 
                 } 
                  
                 protected function clearTip():void { 
                         try { 
                                 m_timer.reset(); 
                         }catch (e:Error) { 
                                 trace("ToolTip::clearTip.m_timer->", e.message); 
                         } 
                         //删除文本框实例 
                         if (m_tipPanel && m_stage) { 
                                 try { 
                                         m_stage.removeChild(m_tipPanel); 
                                 }catch (e:Error) { 
                                         trace("ToolTip::clearTip.removeChild->", e.message); 
                                 } 
                                 m_tipPanel = null; 
                         } 
                 } 
                  
                 protected function onTimer_handler(e:TimerEvent):void { 
                         if (m_tipPanel || (m_tipList[m_currTarget] == undefined) || (m_tipList[m_currTarget] == "")) { 
                                 return; 
                         } 
                         m_tipPanel = new TextField(); 
                         //显示多行 
                         m_tipPanel.multiline = true; 
                         //设置文本 
                         m_tipPanel.htmlText = m_tipList[m_currTarget]; 
                         //设置文本颜色 
                         m_tipPanel.textColor = m_fontColor; 
                         //文本不可选　 
                         m_tipPanel.selectable = false; 
                         //允许使用边框颜色 
                         m_tipPanel.border = true; 
                         //设置边框颜色 
                         m_tipPanel.borderColor = m_borderColor; 
                         //允许使用背景色 
                         m_tipPanel.background = true; 
                         //设置背景颜色 
                         m_tipPanel.backgroundColor = m_bgColor; 
                         //设置宽度和高度 
                         if (m_tipPanel.textWidth < m_maxWidth) { 
                                 m_tipPanel.width = m_tipPanel.textWidth + PADDING_NUM; 
                         }else { 
                                 //自动换行 
                                 m_tipPanel.wordWrap = true; 
                                 m_tipPanel.width = m_maxWidth; 
                         } 
                         m_tipPanel.height = m_tipPanel.textHeight + PADDING_NUM; 
                         if (m_stage) { 
                                 setTipLocation(); 
                                 m_stage.addChild(m_tipPanel); 
                         } 
                 } 
                  
                 protected function setTipLocation():void { 
                         m_tipPanel.x = m_stage.mouseX + MARGIN_NUM; 
                         m_tipPanel.y = m_stage.mouseY + MARGIN_NUM; 
                         //如果tip超出右边界 
                         if ((m_tipPanel.x + m_tipPanel.width) > m_stage.stageWidth) { 
                                 //设置tip在鼠标的左边 
                                 m_tipPanel.x = m_stage.mouseX - m_tipPanel.width - MARGIN_NUM; 
                                 //如果tip超出下边界 
                         }else if((m_tipPanel.y + m_tipPanel.height) > m_stage.stageHeight) { 
                                 //设置tip在鼠标的上边 
                                 m_tipPanel.y = m_stage.mouseY - m_tipPanel.height - MARGIN_NUM; 
                         } 
                 } 
         }        
 } 
 