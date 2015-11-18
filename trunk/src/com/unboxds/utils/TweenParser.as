package com.unboxds.utils
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015 © 2009-2013
	 */

	public class TweenParser
	{
		static public const TWEEN_TO:String = "to";
		static public const TWEEN_FROM:String = "from";
		static public const TWEEN_ALLFROM:String = "allFrom";
		static public const TWEEN_ALLTO:String = "allTo";

		//-- position based motion
		static public const POSITION_LEFT:String = "left";
		static public const POSITION_RIGHT:String = "right";
		static public const POSITION_TOP:String = "top";
		static public const POSITION_BOTTOM:String = "bottom";

		private var _target:DisplayObjectContainer
		private var _tweenXML:XML;

		/**
		 * Tween Class Parser.
		 *
		 * This class read XML tween instructions to perfom a TweenMax action.
		 *
		 * Example XML:
		 * <tween>
		 <tween type="allFrom"
		 target="img,textBox_2"
		 duration="2"
		 ease="Back.easeIn">

		 <vars>
		 <x>#-300</x>

		 <bevelFilter>
		 <blurX>30</blurX>
		 <blurY>30</blurY>
		 <strength>5</strength>
		 <distance>12</distance>
		 <angle>45</angle>
		 </bevelFilter>

		 <glowFilter>
		 <color>0xFFCC00</color>
		 <alpha>1</alpha>
		 <blurX>50</blurX>
		 <blurY>50</blurY>
		 <strength>3</strength>
		 </glowFilter>

		 <yoyo>true</yoyo>
		 <repeat>-1</repeat>
		 </vars>
		 </tween>
		 </tween>
		 *
		 * Initialization example:
		 *
		 * var tweenXML:XML = XML(XMLList(_contentXML.tween).toXMLString());
		 if (tweenXML != null && tweenXML.hasComplexContent())
		 {
		 var tweener:TweenParser = new TweenParser(this, tweenXML);
		 tweener.parse();
		 }
		 *
		 * @param    target the root object
		 * @param    tweenXML The XML object containing the parameters to tween
		 */
		public function TweenParser(target:DisplayObjectContainer, tweenXML:XML)
		{
			TweenPlugin.activate([RemoveTintPlugin, GlowFilterPlugin, AutoAlphaPlugin, TransformAroundPointPlugin, ColorTransformPlugin, FramePlugin, ShortRotationPlugin, BlurFilterPlugin, FrameLabelPlugin, EndArrayPlugin, ColorMatrixFilterPlugin, TransformAroundCenterPlugin, MotionBlurPlugin, DropShadowFilterPlugin, TintPlugin]);

			var easeClasses:Array = [Back, Bounce, Circ, Cubic, Elastic, Expo, Linear, Quad, Quint, Sine, Strong];

			_target = target;
			_tweenXML = tweenXML;

			init();
		}

		private function init():void
		{
			Logger.log("TweenParser.init");
		}

		public function parse():void
		{
			var tweenList:Object = {};
			var tweenCount:int = _tweenXML.tween.length();

			for (var i:int = 0; i < tweenCount; i++)
			{
				var tweenObj:TweenMax;
				var tweenID:String = ("id" in _tweenXML.tween[i]) ? _tweenXML.tween[i].@id : "";
				var tweenType:String = _tweenXML.tween[i].@type;
				var duration:Number = isNaN(parseFloat(_tweenXML.tween[i].@duration)) ? 0 : parseFloat(_tweenXML.tween[i].@duration);
				var stagger:Number = isNaN(parseFloat(_tweenXML.tween[i].@stagger)) ? 0 : parseFloat(_tweenXML.tween[i].@stagger);

				var varsXML:XML = XML(XMLList(_tweenXML.tween[i].vars).toXMLString());
				var vars:Object = ObjectUtils.xmlVarsToObject(varsXML);

				// check for align vars and delete.
				var alignVars:Object = "align" in vars ? vars["align"] : null;
				delete vars["align"];

				vars["ease"] = getEaseFromName(String(_tweenXML.tween[i].@ease));

				var instanceNames:Array = String(_tweenXML.tween[i].@target).split(",");
				for (var j:int = 0; j < instanceNames.length; j++)
				{
					var dispObj:DisplayObject = ObjectUtils.getChildByPath(_target, instanceNames[j]);
					if (dispObj)
					{
						if (alignVars != null)
						{
							var pt:Point = Align.getPoint(dispObj, null, alignVars);
							vars["x"] = pt.x;
							vars["y"] = pt.y;
						}

						if (!("delay" in vars))
							vars["delay"] = 0;
						vars["delay"] += (stagger * j);

						if (tweenType == TWEEN_FROM)
							TweenMax.from(dispObj, duration, vars);
						else
							TweenMax.to(dispObj, duration, vars);
					}
				}
			}
		}

		public static function getEaseFromName(ease:String):Ease
		{
			var easeFunction:Ease;
			var easeParams:Array = ease.split(".");

			var hasClassDefinition:Boolean = ApplicationDomain.currentDomain.hasDefinition("com.greensock.easing." + easeParams[0]);
			if (hasClassDefinition)
			{
				var easeClass:Object = getDefinitionByName("com.greensock.easing." + easeParams[0]) as Object;
				easeFunction = easeClass[easeParams[1]] as Ease;
			}
			else
			{
				Logger.log("TweenParser error >> Ease Class definition '" + ease + "' not found.");
			}

			return easeFunction;
		}

		private function getDisplayObjects(instanceNames:Array):Array
		{
			var dispObjects:Array = [];

			for (var i:int = 0; i < instanceNames.length; i++)
			{
				var dispObj:DisplayObject = ObjectUtils.getChildByPath(_target, instanceNames[i]);
				if (dispObj != null)
					dispObjects.push(dispObj);
				else
					Logger.log("TweenParser error >> INSTANCE '" + instanceNames[i] + "' not found.");
			}

			return dispObjects;
		}

		/**
		 * Static function to create a Tweenmax instance from a XML node containing tween data
		 * @param    target The object to aply the tween
		 * @param    tweenXML The XML Node containg tween data to ween 1 objet only
		 * @return    Tweemax instance in paused state
		 */
		public static function getTweenFromXML(target:DisplayObjectContainer, data:XML):TweenMax
		{
			var tweenType:String = data.@type;
			var duration:Number = isNaN(parseFloat(data.@duration)) ? 0 : parseFloat(data.@duration);
			var stagger:Number = isNaN(parseFloat(data.@stagger)) ? 0 : parseFloat(data.@stagger);
			var varsXML:XML = XML(XMLList(data.vars).toXMLString());

			var vars:Object = ObjectUtils.xmlVarsToObject(varsXML);
			vars["ease"] = getEaseFromName(String(data.@ease));

			var dispObj:DisplayObject = (data.@target == "" || data.@target == "this") ? target as DisplayObject : ObjectUtils.getChildByPath(target, data.@target);
			if (tweenType == TWEEN_FROM)
				return TweenMax.from(dispObj, duration, vars);
			else
				return TweenMax.to(dispObj, duration, vars);
		}

		public function get target():DisplayObjectContainer
		{
			return _target;
		}

		public function set target(value:DisplayObjectContainer):void
		{
			_target = value;
		}

		public function get tweenXML():XML
		{
			return _tweenXML;
		}

		public function set tweenXML(value:XML):void
		{
			_tweenXML = value;
		}
	}

}
