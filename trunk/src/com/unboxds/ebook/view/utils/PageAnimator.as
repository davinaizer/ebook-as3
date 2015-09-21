package com.unboxds.ebook.view.utils
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.StaticText;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class PageAnimator
	{
		static public const MOVE_UP:String = "moveUp";
		static public const MOVE_DOWN:String = "moveDown";
		static public const MOVE_LEFT:String = "moveLeft";
		static public const MOVE_RIGHT:String = "moveRight";
		
		static public const SLIDE_XIN:String = "slideXIn";
		static public const SLIDE_XOUT:String = "slideXOut";
		static public const SLIDE_YIN:String = "slideYIn";
		static public const SLIDE_YOUT:String = "slideYOut";
		
		static public const FADE_IN:String = "fadeIn";
		static public const FADE_OUT:String = "fadeOut";
		
		public function PageAnimator()
		{
		}
		
		//-- SLIDE X
		public static function slideXIn(target:DisplayObject, duration:Number = 1, direction:int = 1, callback:Function = null):void
		{
			if (target)
			{
				target.alpha = 1;
				target.x = direction * target.stage.stageWidth;
				TweenLite.to(target, duration, {x: 0, ease: Expo.easeInOut, onComplete: callback});
			}
		}
		
		public static function slideXOut(target:DisplayObject, duration:Number = 1, direction:int = -1, callback:Function = null):void
		{
			if (target)
			{
				target.x = 0;
				TweenLite.to(target, duration, {x: direction * -target.stage.stageWidth, ease: Expo.easeInOut, onComplete: callback});
			}
		}
		
		//-- SLIDE Y
		public static function slideYIn(target:DisplayObject, duration:Number = 1, direction:int = 1, callback:Function = null):void
		{
			if (target)
			{
				target.alpha = 1;
				target.y = -direction * target.stage.stageHeight;
				TweenLite.to(target, duration, {y: 0, ease: Expo.easeInOut, onComplete: callback});
			}
		}
		
		public static function slideYOut(target:DisplayObject, duration:Number = 1, direction:int = -1, callback:Function = null):void
		{
			if (target)
			{
				target.y = 0;
				TweenLite.to(target, duration, {y: -direction * -target.stage.stageHeight, ease: Expo.easeInOut, onComplete: callback});
			}
		}
		
		public static function fadeIn(target:DisplayObject, duration:Number = .3, direction:int = 1, callback:Function = null):void
		{
			if (target)
			{
				target.alpha = 0;
				TweenLite.to(target, duration, {alpha: 1, onComplete: callback});
			}
		}
		
		public static function fadeOut(target:DisplayObject, duration:Number = .3, direction:int = -1, callback:Function = null):void
		{
			if (target)
			{
				TweenLite.to(target, duration, {alpha: 0, onComplete: callback});
			}
		}
		
		//-- CONTENT ANIMATOR
		public static function contentFadeIn(target:DisplayObjectContainer, duration:Number = .5, delay:Number = 0):void
		{
			if (target)
			{
				var itemCount:int, i:uint = 0;
				for (i = 0; i < target.numChildren; i++)
				{
					var displayitem:DisplayObject = target.getChildAt(i);
					if (displayitem is StaticText || displayitem is TextField)
					{
						var myFieldLabel:DisplayObject = displayitem as DisplayObject;
						TweenLite.from(myFieldLabel, duration, {delay: delay + (itemCount * .1), alpha: 0, x: myFieldLabel.x - 20, ease: Expo.easeOut});
						
						itemCount++;
					}
				}
			}
		}
		
		public static function contentFadeOut(target:DisplayObjectContainer, duration:Number = .5, delay:Number = 0):void
		{
			if (target)
			{
				var itemCount:int, i:uint = 0;
				for (i = 0; i < target.numChildren; i++)
				{
					var displayitem:DisplayObject = target.getChildAt(i);
					if (displayitem is StaticText || displayitem is TextField)
					{
						var myFieldLabel:DisplayObject = displayitem as DisplayObject;
						TweenLite.to(myFieldLabel, duration, {delay: delay + (itemCount * .1), alpha: 0, x: myFieldLabel.x - 20, ease: Expo.easeOut});
						
						itemCount++;
					}
				}
			}
		}
	
	}

}