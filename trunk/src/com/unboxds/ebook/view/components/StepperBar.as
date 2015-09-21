package com.unboxds.ebook.view.components
{
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */

	// TODO REMOVE THIS CLASS - USE BARMETER INSTEAD
	public class StepperBar extends Sprite
	{
		private var _barWidth:Number;
		private var _barHeight:Number;
		private var _barColor:Number;
		private var _barColorAlpha:Number;
		private var _thumbColor:Number;
		private var _thumbColorAlpha:Number;

		private var _steps:int;
		private var _current:int;
		private var _autoHideThumb:Boolean;

		private var thumb:Sprite;
		private var scrollbar:Sprite;
		private var thumbHeight:Number;
		private var thumbWidth:Number;

		private var isVerticalScrolling:Boolean;
		private var hasInit:Boolean;

		public function StepperBar()
		{
			_current = 1;
			_steps = 1;
			_barColor = 0xAE1F22;
			_barColorAlpha = 1;
			_thumbColor = 0xFFFFFF;
			_thumbColorAlpha = 1;
			_autoHideThumb = false;

			hasInit = false;

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}

		private function init():void
		{
			scrollbar = new Sprite();
			thumb = new Sprite();

			addChild(scrollbar);
			addChild(thumb);

			isVerticalScrolling = _barHeight > _barWidth;

			draw();
			update();

			hasInit = true;
		}

		private function draw():void
		{
			_steps = _steps < 1 ? 1 : _steps;

			scrollbar.graphics.clear();
			scrollbar.graphics.beginFill(_barColor, _barColorAlpha);
			scrollbar.graphics.drawRect(0, 0, _barWidth, _barHeight);
			scrollbar.graphics.endFill();

			thumbWidth = isVerticalScrolling ? _barWidth : _barWidth / _steps;
			thumbHeight = isVerticalScrolling ? _barHeight / _steps : _barHeight;

			thumb.graphics.clear();
			thumb.graphics.beginFill(_thumbColor, _thumbColorAlpha);
			thumb.graphics.drawRect(0, 0, thumbWidth, thumbHeight);
			thumb.graphics.endFill();
		}

		private function update():void
		{
			_current = _current > _steps ? _steps : _current;
			_current = _current < 1 ? 1 : _current;

			var nY:Number = isVerticalScrolling ? thumbHeight * (_current - 1) : 0;
			var nX:Number = isVerticalScrolling ? 0 : thumbWidth * (_current - 1);

			TweenLite.to(thumb, .25, {overwrite: 1, x: nX, y: nY, alpha: 1, onComplete: onUpdate});
		}

		private function onUpdate():void
		{
			if (_autoHideThumb)
				TweenLite.to(thumb, 1, {delay: .5, alpha: 0});
		}

		public function get barWidth():Number
		{
			return _barWidth;
		}

		public function set barWidth(value:Number):void
		{
			_barWidth = value;
		}

		public function get barHeight():Number
		{
			return _barHeight;
		}

		public function set barHeight(value:Number):void
		{
			_barHeight = value;
		}

		public function get barColor():Number
		{
			return _barColor;
		}

		public function set barColor(value:Number):void
		{
			_barColor = value;
		}

		public function get thumbColor():Number
		{
			return _thumbColor;
		}

		public function set thumbColor(value:Number):void
		{
			_thumbColor = value;
		}

		public function get steps():int
		{
			return _steps;
		}

		public function set steps(value:int):void
		{
			_steps = value;

			if (hasInit)
			{
				draw();
				update();
			}
		}

		public function get current():int
		{
			return _current;
		}

		public function set current(value:int):void
		{
			_current = value;

			if (hasInit)
				update();
		}

		public function get autoHideThumb():Boolean
		{
			return _autoHideThumb;
		}

		public function set autoHideThumb(value:Boolean):void
		{
			_autoHideThumb = value;
		}

		public function get barColorAlpha():Number
		{
			return _barColorAlpha;
		}

		public function set barColorAlpha(value:Number):void
		{
			_barColorAlpha = value;
		}

		public function get thumbColorAlpha():Number
		{
			return _thumbColorAlpha;
		}

		public function set thumbColorAlpha(value:Number):void
		{
			_thumbColorAlpha = value;
		}

	}

}