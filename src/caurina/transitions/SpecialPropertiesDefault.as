package caurina.transitions
{
    import flash.display.*;
    import flash.filters.*;

    public class SpecialPropertiesDefault extends Object
    {

        public function SpecialPropertiesDefault()
        {
            trace("SpecialProperties is a static class and should not be instantiated.");
            return;
        }// end function

        public static function _sound_volume_get(param1:Object) : Number
        {
            return param1.soundTransform.volume;
        }// end function

        public static function _color_splitter(param1) : Array
        {
            var _loc_2:* = new Array();
            if (param1 == null)
            {
                _loc_2.push({name:"_color_ra", value:1});
                _loc_2.push({name:"_color_rb", value:0});
                _loc_2.push({name:"_color_ga", value:1});
                _loc_2.push({name:"_color_gb", value:0});
                _loc_2.push({name:"_color_ba", value:1});
                _loc_2.push({name:"_color_bb", value:0});
            }
            else
            {
                _loc_2.push({name:"_color_ra", value:0});
                _loc_2.push({name:"_color_rb", value:AuxFunctions.numberToR(param1)});
                _loc_2.push({name:"_color_ga", value:0});
                _loc_2.push({name:"_color_gb", value:AuxFunctions.numberToG(param1)});
                _loc_2.push({name:"_color_ba", value:0});
                _loc_2.push({name:"_color_bb", value:AuxFunctions.numberToB(param1)});
            }// end else if
            return _loc_2;
        }// end function

        public static function frame_get(param1:Object) : Number
        {
            return param1.currentFrame;
        }// end function

        public static function _sound_pan_get(param1:Object) : Number
        {
            return param1.soundTransform.pan;
        }// end function

        public static function _autoAlpha_get(param1:Object) : Number
        {
            return param1.alpha;
        }// end function

        public static function __brightness_get(param1:DisplayObject) : Number
        {
            return getColorMatrix(param1).getBrightness();
        }// end function

        public static function __saturation_get(param1:DisplayObject) : Number
        {
            return getColorMatrix(param1).getSaturation();
        }// end function

        public static function _sound_volume_set(param1:Object, param2:Number) : void
        {
            var _loc_3:* = param1.soundTransform;
            _loc_3.volume = param2;
            param1.soundTransform = _loc_3;
            return;
        }// end function

        private static function getColorMatrix(param1:DisplayObject) : ColorMatrix
        {
            var _loc_2:* = param1.filters;
            var _loc_3:* = new ColorMatrix();
            var _loc_4:* = _loc_2.length;
            while (--_loc_4 > -1)
            {
                // label
                if (_loc_2[_loc_4] is ColorMatrixFilter)
                {
                    _loc_3.matrix = _loc_2[_loc_4].matrix.concat();
                    break;
                }// end if
            }// end while
            return _loc_3;
        }// end function

        public static function init() : void
        {
            Tweener.registerSpecialProperty("_frame", frame_get, frame_set);
            Tweener.registerSpecialProperty("_sound_volume", _sound_volume_get, _sound_volume_set);
            Tweener.registerSpecialProperty("_sound_pan", _sound_pan_get, _sound_pan_set);
            Tweener.registerSpecialProperty("_color_ra", _color_property_get, _color_property_set, ["redMultiplier"]);
            Tweener.registerSpecialProperty("_color_rb", _color_property_get, _color_property_set, ["redOffset"]);
            Tweener.registerSpecialProperty("_color_ga", _color_property_get, _color_property_set, ["greenMultiplier"]);
            Tweener.registerSpecialProperty("_color_gb", _color_property_get, _color_property_set, ["greenOffset"]);
            Tweener.registerSpecialProperty("_color_ba", _color_property_get, _color_property_set, ["blueMultiplier"]);
            Tweener.registerSpecialProperty("_color_bb", _color_property_get, _color_property_set, ["blueOffset"]);
            Tweener.registerSpecialProperty("_color_aa", _color_property_get, _color_property_set, ["alphaMultiplier"]);
            Tweener.registerSpecialProperty("_color_ab", _color_property_get, _color_property_set, ["alphaOffset"]);
            Tweener.registerSpecialProperty("_autoAlpha", _autoAlpha_get, _autoAlpha_set);
            Tweener.registerSpecialPropertySplitter("_color", _color_splitter);
            Tweener.registerSpecialPropertySplitter("_colorTransform", _colorTransform_splitter);
            Tweener.registerSpecialPropertySplitter("_scale", _scale_splitter);
            Tweener.registerSpecialProperty("_blur_blurX", _filter_property_get, _filter_property_set, [BlurFilter, "blurX"]);
            Tweener.registerSpecialProperty("_blur_blurY", _filter_property_get, _filter_property_set, [BlurFilter, "blurY"]);
            Tweener.registerSpecialProperty("_blur_quality", _filter_property_get, _filter_property_set, [BlurFilter, "quality"]);
            Tweener.registerSpecialPropertySplitter("_filter", _filter_splitter);
            Tweener.registerSpecialPropertyModifier("_bezier", _bezier_modifier, _bezier_get);
            Tweener.registerSpecialProperty("_brightness", __brightness_get, __brightness_set);
            Tweener.registerSpecialProperty("_contrast", __contrast_get, __contrast_set);
            Tweener.registerSpecialProperty("_saturation", __saturation_get, __saturation_set);
            return;
        }// end function

        public static function _sound_pan_set(param1:Object, param2:Number) : void
        {
            var _loc_3:* = param1.soundTransform;
            _loc_3.pan = param2;
            param1.soundTransform = _loc_3;
            return;
        }// end function

        public static function _autoAlpha_set(param1:Object, param2:Number) : void
        {
            param1.alpha = param2;
            param1.visible = param2 > 0;
            return;
        }// end function

        public static function __brightness_set(param1:DisplayObject, param2:Number) : void
        {
            var _loc_3:* = new ColorMatrix();
            _loc_3.setBrightness(param2);
            setColorMatrix(param1, _loc_3);
            return;
        }// end function

        public static function __saturation_set(param1:DisplayObject, param2:Number) : void
        {
            var _loc_3:* = new ColorMatrix();
            _loc_3.setSaturation(param2);
            setColorMatrix(param1, _loc_3);
            return;
        }// end function

        public static function frame_set(param1:Object, param2:Number) : void
        {
            param1.gotoAndStop(Math.round(param2));
            return;
        }// end function

        private static function setColorMatrix(param1:DisplayObject, param2:ColorMatrix) : void
        {
            var _loc_3:* = param1.filters;
            var _loc_4:* = new Array();
            var _loc_5:* = param2;
            var _loc_6:* = _loc_3.length;
            while (--_loc_6 > -1)
            {
                // label
                if (!(_loc_3[_loc_6] is ColorMatrixFilter))
                {
                    _loc_4.push(_loc_3[_loc_6]);
                }// end if
            }// end while
            _loc_4.push(_loc_5.filter);
            param1.filters = _loc_4;
            return;
        }// end function

        public static function _filter_property_get(param1:Object, param2:Array) : Number
        {
            var _loc_4:uint;
            var _loc_7:Object;
            var _loc_3:* = param1.filters;
            var _loc_5:* = param2[0];
            var _loc_6:* = param2[1];
            _loc_4 = 0;
            while (_loc_4++ < _loc_3.length)
            {
                // label
                if (_loc_3[_loc_4] is BlurFilter && _loc_5 == BlurFilter)
                {
                    return _loc_3[_loc_4][_loc_6];
                }// end if
            }// end while
            switch(_loc_5)
            {
                case BlurFilter:
                {
                    _loc_7 = {blurX:0, blurY:0, quality:NaN};
                    break;
                }// end case
                default:
                {
                    break;
                }// end default
            }// end switch
            return _loc_7[_loc_6];
        }// end function

        public static function _bezier_get(param1:Number, param2:Number, param3:Number, param4:Array) : Number
        {
            var _loc_5:uint;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:Number;
            if (param4.length == 1)
            {
                return param1 + param3 * (2 * (1 - param3) * (param4[0] - param1) + param3 * (param2 - param1));
            }// end if
            _loc_5 = Math.floor(param3 * param4.length);
            _loc_6 = (param3 - _loc_5 * (1 / param4.length)) * param4.length;
            if (_loc_5 == 0)
            {
                _loc_7 = param1;
                _loc_8 = (param4[0] + param4[1]) / 2;
            }
            else if (_loc_5 == param4.length--)
            {
                _loc_7 = (param4[_loc_5--] + param4[_loc_5]) / 2;
                _loc_8 = param2;
            }
            else
            {
                _loc_7 = (param4[_loc_5--] + param4[_loc_5]) / 2;
                _loc_8 = (param4[_loc_5] + param4[_loc_5 + 1]) / 2;
            }// end else if
            return _loc_7 + _loc_6 * (2 * (1 - _loc_6) * (param4[_loc_5] - _loc_7) + _loc_6 * (_loc_8 - _loc_7));
        }// end function

        public static function __contrast_set(param1:DisplayObject, param2:Number) : void
        {
            var _loc_3:* = new ColorMatrix();
            _loc_3.setContrast(param2);
            setColorMatrix(param1, _loc_3);
            return;
        }// end function

        public static function _filter_property_set(param1:Object, param2:Number, param3:Array) : void
        {
            var _loc_5:uint;
            var _loc_8:BitmapFilter;
            var _loc_4:* = param1.filters;
            var _loc_6:* = param3[0];
            var _loc_7:* = param3[1];
            _loc_5 = 0;
            while (_loc_5++ < _loc_4.length)
            {
                // label
                if (_loc_4[_loc_5] is BlurFilter && _loc_6 == BlurFilter)
                {
                    _loc_4[_loc_5][_loc_7] = param2;
                    param1.filters = _loc_4;
                    return;
                }// end if
            }// end while
            if (_loc_4 == null)
            {
                _loc_4 = new Array();
            }// end if
            switch(_loc_6)
            {
                case BlurFilter:
                {
                    _loc_8 = new BlurFilter(0, 0);
                    break;
                }// end case
                default:
                {
                    break;
                }// end default
            }// end switch
            _loc_8[_loc_7] = param2;
            _loc_4.push(_loc_8);
            param1.filters = _loc_4;
            return;
        }// end function

        public static function _color_property_get(param1:Object, param2:Array) : Number
        {
            return param1.transform.colorTransform[param2[0]];
        }// end function

        public static function _filter_splitter(param1:BitmapFilter) : Array
        {
            var _loc_2:* = new Array();
            if (param1 is BlurFilter)
            {
                _loc_2.push({name:"_blur_blurX", value:BlurFilter(param1).blurX});
                _loc_2.push({name:"_blur_blurY", value:BlurFilter(param1).blurY});
                _loc_2.push({name:"_blur_quality", value:BlurFilter(param1).quality});
            }
            else
            {
                trace("??");
            }// end else if
            return _loc_2;
        }// end function

        public static function _color_property_set(param1:Object, param2:Number, param3:Array) : void
        {
            var _loc_4:* = param1.transform.colorTransform;
            param1.transform.colorTransform[param3[0]] = param2;
            param1.transform.colorTransform = _loc_4;
            return;
        }// end function

        public static function _bezier_modifier(param1) : Array
        {
            var _loc_3:Array;
            var _loc_4:uint;
            var _loc_5:String;
            var _loc_2:Array;
            if (param1 is Array)
            {
                _loc_3 = param1;
            }
            else
            {
                _loc_3 = [param1];
            }// end else if
            var _loc_6:Object;
            _loc_4 = 0;
            while (_loc_4++ < _loc_3.length)
            {
                // label
                for (_loc_5 in _loc_3[_loc_4])
                {
                    // label
                    if (_loc_6[_loc_5] == undefined)
                    {
                        _loc_6[_loc_5] = [];
                    }// end if
                    _loc_6[_loc_5].push(_loc_3[_loc_4][_loc_5]);
                }// end of for ... in
            }// end while
            for (_loc_5 in _loc_6)
            {
                // label
                _loc_2.push({name:_loc_5, parameters:_loc_6[_loc_5]});
            }// end of for ... in
            return _loc_2;
        }// end function

        public static function __contrast_get(param1:DisplayObject) : Number
        {
            return getColorMatrix(param1).getContrast();
        }// end function

        public static function _scale_splitter(param1:Number) : Array
        {
            var _loc_2:* = new Array();
            _loc_2.push({name:"scaleX", value:param1});
            _loc_2.push({name:"scaleY", value:param1});
            return _loc_2;
        }// end function

        public static function _colorTransform_splitter(param1) : Array
        {
            var _loc_2:* = new Array();
            if (param1 == null)
            {
                _loc_2.push({name:"_color_ra", value:1});
                _loc_2.push({name:"_color_rb", value:0});
                _loc_2.push({name:"_color_ga", value:1});
                _loc_2.push({name:"_color_gb", value:0});
                _loc_2.push({name:"_color_ba", value:1});
                _loc_2.push({name:"_color_bb", value:0});
            }
            else
            {
                if (param1.ra != undefined)
                {
                    _loc_2.push({name:"_color_ra", value:param1.ra});
                }// end if
                if (param1.rb != undefined)
                {
                    _loc_2.push({name:"_color_rb", value:param1.rb});
                }// end if
                if (param1.ga != undefined)
                {
                    _loc_2.push({name:"_color_ba", value:param1.ba});
                }// end if
                if (param1.gb != undefined)
                {
                    _loc_2.push({name:"_color_bb", value:param1.bb});
                }// end if
                if (param1.ba != undefined)
                {
                    _loc_2.push({name:"_color_ga", value:param1.ga});
                }// end if
                if (param1.bb != undefined)
                {
                    _loc_2.push({name:"_color_gb", value:param1.gb});
                }// end if
                if (param1.aa != undefined)
                {
                    _loc_2.push({name:"_color_aa", value:param1.aa});
                }// end if
                if (param1.ab != undefined)
                {
                    _loc_2.push({name:"_color_ab", value:param1.ab});
                }// end if
            }// end else if
            return _loc_2;
        }// end function

    }
}
