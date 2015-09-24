package com.unboxds.ebook.view.components
{
	import com.unboxds.ebook.view.parser.ContentParser;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.NumberUtils;
	import com.unboxds.utils.StringUtils;

	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class NumericMeter extends AbsProgressMeter
	{
		private var _currentIndexStr:String;
		private var _totalIndexStr:String;
		
		private var statusTxt:TextField;
		private var statusStr:String;
		private var zeroPadding:int;
		
		public function NumericMeter(contentXML:XML, stylesheet:StyleSheet)
		{
			super(contentXML, stylesheet);
			alpha = 0;
			visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		private function init():void
		{
			Logger.log("NumericMeter.init");
			
			progress = 0;
			max = 0;
			
			this.x = parseFloat(contentXML.@x);
			this.y = parseFloat(contentXML.@y);
			zeroPadding = parseInt(contentXML.@zeroPadding);
			
			statusTxt = new TextField();
			statusTxt.name = "statusTxt";
			addChild(statusTxt);
			
			new ContentParser(this, contentXML, stylesheet).parse();
			
			statusTxt.text = "";
			statusStr = contentXML.content.(@type == "text").content.(@instanceName == "statusTxt").title.toString();
		}
		
		override public function setProgress(progress:uint):void
		{
			if (progress >= max) progress = max - 1;

			//-- create String to set pad with zeros
			_currentIndexStr = NumberUtils.fixPadding(progress, zeroPadding);
			_totalIndexStr = NumberUtils.fixPadding(max, zeroPadding);

			setCurrentIndex(progress);
		}
		
		public function setCurrentIndex(index:int):void
		{
			statusTxt.htmlText = StringUtils.parseTextVars(statusStr, this);
			progress = index;
		}
	}
}