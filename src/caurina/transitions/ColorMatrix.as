package caurina.transitions
{
    import flash.filters.*;

    public class ColorMatrix extends Object
    {
        public var matrix:Array;
        private static const STANDARD_CONTRAST:Number = 0;
        private static const IDENTITY:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
        private static const STANDARD_BRIGHTNESS:Number = 0;
        private static const STANDARD_SATURATION:Number = 100;
        private static const MAX_CONTRAST:Number = 500;
        private static const B_LUM:Number = 0.072169;
        private static const G_LUM:Number = 0.71516;
        private static const MAX_SATURATION:Number = 300;
        private static const MIN_CONTRAST:Number = -200;
        private static const MAX_BRIGHTNESS:Number = 100;
        private static const R_LUM:Number = 0.212671;
        private static const MIN_BRIGHTNESS:Number = -100;
        private static const MIN_SATURATION:Number = -300;

        public function ColorMatrix(param1:Object = null)
        {
            if (param1 is ColorMatrix)
            {
                matrix = param1.matrix.concat();
            }
            else if (param1 is Array)
            {
                matrix = param1.concat();
            }
            else
            {
                reset();
            }// end else if
            return;
        }// end function

        public function setContrast(param1:Number) : void
        {
            var _loc_2:* = checkValue(MIN_CONTRAST, MAX_CONTRAST, param1);
            _loc_2 = _loc_2 / 100;
            var _loc_3:* = _loc_2 + 1;
            var _loc_4:* = 128 * (1 - _loc_3);
            var _loc_5:Array;
            concat(_loc_5);
            return;
        }// end function

        public function getBrightness() : Number
        {
            var _loc_1:* = (matrix[4] + matrix[9] + matrix[14]) / 3;
            if (_loc_1 != 0)
            {
                _loc_1 = _loc_1 * 100 / 255;
            }// end if
            return Math.round(_loc_1);
        }// end function

        public function getSaturation() : Number
        {
            var _loc_4:Number;
            var _loc_1:* = 1 - matrix[1] / G_LUM;
            var _loc_2:* = 1 - matrix[2] / B_LUM;
            var _loc_3:* = 1 - matrix[5] / R_LUM;
            _loc_4 = Math.round((_loc_1 + _loc_2 + _loc_3) / 3);
            _loc_4 = _loc_4 * 100;
            return _loc_4;
        }// end function

        private function checkValue(param1:Number, param2:Number, param3:Number) : Number
        {
            return Math.min(param2, Math.max(param1, param3));
        }// end function

        public function setBrightness(param1:Number) : void
        {
            var _loc_2:* = checkValue(MIN_BRIGHTNESS, MAX_BRIGHTNESS, param1);
            _loc_2 = 255 * _loc_2 / 100;
            var _loc_3:Array;
            concat(_loc_3);
            return;
        }// end function

        public function reset() : void
        {
            matrix = IDENTITY.concat();
            return;
        }// end function

        public function setSaturation(param1:Number) : void
        {
            var _loc_2:* = checkValue(MIN_SATURATION, MAX_SATURATION, param1);
            _loc_2 = _loc_2 / 100;
            var _loc_3:* = 1 - _loc_2;
            var _loc_4:* = _loc_3 * R_LUM;
            var _loc_5:* = _loc_3 * G_LUM;
            var _loc_6:* = _loc_3 * B_LUM;
            var _loc_7:Array;
            concat(_loc_7);
            return;
        }// end function

        public function getContrast() : Number
        {
            var _loc_1:* = (matrix[0] + matrix[6] + matrix[12]) / 3;
            _loc_1 = _loc_1-- * 100;
            return _loc_1;
        }// end function

        public function concat(param1:Array) : void
        {
            var _loc_5:Number;
            var _loc_2:* = new Array();
            var _loc_3:Number;
            var _loc_4:Number;
            while (_loc_4++ < 4)
            {
                // label
                _loc_5 = 0;
                while (_loc_5++ < 5)
                {
                    // label
                    _loc_2[_loc_3 + _loc_5] = param1[_loc_3] * matrix[_loc_5] + param1[_loc_3 + 1] * matrix[_loc_5 + 5] + param1[_loc_3 + 2] * matrix[_loc_5 + 10] + param1[_loc_3 + 3] * matrix[_loc_5 + 15] + (_loc_5 == 4 ? (param1[_loc_3 + 4]) : (0));
                }// end while
                _loc_3 = _loc_3 + 5;
            }// end while
            matrix = _loc_2;
            return;
        }// end function

        public function clone() : ColorMatrix
        {
            return new ColorMatrix(matrix);
        }// end function

        public function get filter() : ColorMatrixFilter
        {
            return new ColorMatrixFilter(matrix);
        }// end function

    }
}
