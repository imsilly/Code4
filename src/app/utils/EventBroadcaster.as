package app.utils
{
    import flash.events.*;

    public class EventBroadcaster extends EventDispatcher
    {
        private static var _instance:EventBroadcaster;

        public function EventBroadcaster(param1:Singleton)
        {
            return;
        }

        private function repeat(param1:Event) : void
        {
            this.dispatchEvent(param1);
            return;
        }

        public function registerEvents(param1:EventDispatcher, param2:Array) : void
        {
            var _loc_3:String;
            for each (_loc_3 in param2)
            {
                
                param1.addEventListener(_loc_3, this.repeat, false, 0, true);
            }
            return;
        }

        public function deregisterEvents(param1:EventDispatcher, param2:Array) : void
        {
            var _loc_3:String;
            for each (_loc_3 in param2)
            {
                
                param1.removeEventListener(_loc_3, this.repeat, false);
            }
            return;
        }

        public static function getInstance() : EventBroadcaster
        {
            if (EventBroadcaster._instance == null)
            {
                EventBroadcaster._instance = new EventBroadcaster(new Singleton());
            }
            return EventBroadcaster._instance;
        }
    }
}
