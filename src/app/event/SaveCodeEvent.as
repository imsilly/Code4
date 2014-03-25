package app.event
{
    import flash.events.*;

    public class SaveCodeEvent extends Event
    {
        public var data:*;
		public var success:Boolean=false;
        public static const ON_RESULT:String = "save_code_result";
		public static const ON_ERROR:String = "save_code_error";
		
        public function SaveCodeEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this.data = param2;
            return;
        }

        override public function clone() : Event
        {
            return new SaveCodeEvent(this.type, this.data, this.bubbles, this.cancelable);
        }

        override public function toString() : String
        {
            return "[ SaveCodeEvent " + this.type + " ]";
        }

    }
}
