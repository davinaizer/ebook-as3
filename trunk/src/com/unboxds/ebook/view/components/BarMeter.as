package com.unboxds.ebook.view.components
{
	import com.greensock.TweenLite;
	import com.unboxds.utils.Logger;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class BarMeter extends AbstractProgressMeter
	{
		private var _width:Number;
		private var _height:Number;

		private var bgColor:Number;
		private var bgColorAlpha:Number;
		private var barColor:Number;
		private var barColorAlpha:Number;
		private var secondaryBarColor:Number;
		private var secondaryBarColorAlpha:Number;

		private var bgView:Sprite;
		private var barView:Sprite;
		private var secondaryBarView:Sprite;

		private var hasInit:Boolean;

		public function BarMeter()
		{
			Logger.log("BarMeter.BarMeter");

			super();

			_width = 100;
			_height = 2;

			bgColor = 0xE4E4E4;
			bgColorAlpha = 1;
			barColor = 0x006AB6;
			barColorAlpha = 1;
			secondaryBarColor = 0x00A900;
			secondaryBarColorAlpha = 1;

			hasInit = false;

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			parseConfig();
			init();
			draw();
		}

		override protected function init():void
		{
			Logger.log("BarMeter.init");

			bgView = new Sprite();
			barView = new Sprite();
			secondaryBarView = new Sprite();

			addChild(bgView);
			addChild(secondaryBarView);
			addChild(barView);

			hasInit = true;
		}

		private function parseConfig():void
		{
			x = parseFloat(contentXML.@x);
			y = parseFloat(contentXML.@y);

			_width = parseInt(contentXML.@width);
			_height = parseInt(contentXML.@height);

			bgColor = parseInt(contentXML.@bgColor);
			bgColorAlpha = parseFloat(contentXML.@bgColorAlpha);
			barColor = parseInt(contentXML.@barColor);
			barColorAlpha = parseFloat(contentXML.@barColorAlpha);
			secondaryBarColor = parseInt(contentXML.@secondaryBarColor);
			secondaryBarColorAlpha = parseFloat(contentXML.@secondaryBarColorAlpha);
		}

		private function draw():void
		{
			bgView.graphics.clear();
			bgView.graphics.beginFill(bgColor, bgColorAlpha);
			bgView.graphics.drawRect(0, 0, _width, _height);
			bgView.graphics.endFill();

			barView.graphics.clear();
			barView.graphics.beginFill(barColor, barColorAlpha);
			barView.graphics.drawRect(0, 0, _width, _height);
			barView.graphics.endFill();

			secondaryBarView.graphics.clear();
			secondaryBarView.graphics.beginFill(secondaryBarColor, secondaryBarColorAlpha);
			secondaryBarView.graphics.drawRect(0, 0, _width, _height);
			secondaryBarView.graphics.endFill();
		}

		private function update():void
		{
			var newBarWidth:Number = _width * (progress / max);
			var newSecondaryBarWidth:Number = _width * (secondaryProgress / max);

			TweenLite.to(barView, .25, {overwrite: 1, width: newBarWidth, alpha: 1});
			TweenLite.to(secondaryBarView, .25, {overwrite: 1, width: newSecondaryBarWidth, alpha: 1});
		}

		override public function setProgress(progress:uint):void
		{
			this.progress = progress;

			if (hasInit)
				update();
		}

		override public function setSecondaryProgress(progress:uint):void
		{
			this.secondaryProgress = progress;

			if (hasInit)
				update();
		}

		override public function setMax(max:uint):void
		{
			this.max = max;

			if (hasInit)
				draw();
		}

	}

}