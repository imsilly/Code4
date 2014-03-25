package app.utils
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	public class DelayTimer extends Timer
	{
        private var _data:Object;

        public function DelayTimer(delay:Number, repeatCount:int=0) {
            super(delay, repeatCount);
            _data = {};
        }

        public function get data():Object {
            return _data;
        }

        public function set data(value:Object):void {
            _data = value;
        }
	}
}