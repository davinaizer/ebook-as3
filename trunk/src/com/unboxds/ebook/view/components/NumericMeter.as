package com.unboxds.ebook.view.components
{
	import com.unboxds.ebook.model.ContentParser;
	import com.unboxds.ebook.view.ui.ContentObject;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.NumberUtils;
	import com.unboxds.utils.StringUtils;
	import flash.events.Event;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class NumericMeter extends ContentObject
	{
		private var _currentIndex:int;
		private var _totalIndex:int;
		private var _onChange:Signal;
		
		private var _currentIndexStr:String;
		private var _totalIndexStr:String;
		
		private var statusTxt:TextField;
		private var statusStr:String;
		private var zeroPadding:int;
		
		public function NumericMeter()
		{
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
			
			_onChange = new Signal(int, int);
			
			currentIndex = 0;
			totalIndex = 0;
			
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
		
		public function setProgress(current:int, total:int):void
		{
			if (current >= total)
				current = total - 1;
			if (current < 0)
				current = 0;
			
			_currentIndex = current + 1;
			_totalIndex = total;
			
			//-- create String to set pad with zeros
			_currentIndexStr = NumberUtils.fixPadding(_currentIndex, zeroPadding);
			_totalIndexStr = NumberUtils.fixPadding(_totalIndex, zeroPadding);
			
			setCurrentIndex(current);
		}
		
		public function setCurrentIndex(index:int):void
		{
			statusTxt.htmlText = StringUtils.parseTextVars(statusStr, this);
			_currentIndex = index;
		}
		
		public function block(value:Boolean):void
		{
			// nothing
		}
		
		/* INTERFACE com.unboxds.ebook.view.components.IProgressMeter */
		public function get onChange():ISignal
		{
			return _onChange;
		}
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		public function get totalIndex():int
		{
			return _totalIndex;
		}
		
		public function set totalIndex(value:int):void
		{
			_totalIndex = value;
		}
		
		public function get currentIndexStr():String
		{
			return _currentIndexStr;
		}
		
		public function set currentIndexStr(value:String):void
		{
			_currentIndexStr = value;
		}
		
		public function get totalIndexStr():String
		{
			return _totalIndexStr;
		}
		
		public function set totalIndexStr(value:String):void
		{
			_totalIndexStr = value;
		}
	
	}

}