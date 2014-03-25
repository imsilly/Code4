package app.event
{
    import flash.events.*;

    public class SystemEvent extends Event
    {
        private var _data:*;
        public static const CHANGE_VIEW_STATUS:String = "change_view_status";
        public static const CHANGE_3DOBJ_STATUS:String = "change_3DObj_status";
        public static const OBJ_SELECTED:String = "obj_selected";

        public function SystemEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
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
            return new SystemEvent(this.type, this.data, this.bubbles, this.cancelable);
        }

        override public function toString() : String
        {
            return "[ SiteEvent " + this.type + " ]";
        }

    }
}
