package app.event
{
    import flash.events.*;

    public class GetCodeEvent extends Event
    {
        public var data:*;
		public var success:Boolean=false;
        public static const ON_RESULT:String = "get_code_result";
		public static const ON_ERROR:String = "get_code_error";
		
        public function GetCodeEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this.data = param2;
            return;
        }

        override public function clone() : Event
        {
            return new GetCodeEvent(this.type, this.data, this.bubbles, this.cancelable);
        }

        override public function toString() : String
        {
            return "[ GetCodeEvent " + this.type + " ]";
        }

    }
}
