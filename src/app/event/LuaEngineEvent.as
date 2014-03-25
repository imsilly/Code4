package app.event
{
    import flash.events.*;

    public class LuaEngineEvent extends Event
    {
        private var _data:*;
        public static const EXEC_RESULT:String = "exec_result";
		public static const TRACE_RESULT:String = "trace";
		
        public function LuaEngineEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this._data = param2;
            return;
        }

        public function get data():*
        {
            return this._data;
        }
        public function set data(value:*):void
        {
            this._data=value;
        }

        override public function clone() : Event
        {
            return new LuaEngineEvent(this.type, this.data, this.bubbles, this.cancelable);
        }

        override public function toString() : String
        {
            return "[ LuaEngineEvent " + this.type + " ]";
        }

    }
}
