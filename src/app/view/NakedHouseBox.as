package app.view
{
	import flash.display.MovieClip;

    dynamic public class NakedHouseBox extends MovieClip
    {
		public var main_mc:MovieClip;
		public function NakedHouseBox()
        {

        }

        public function callMe(value) : void
        {
           main_mc.log(value);
        }
    }
}
