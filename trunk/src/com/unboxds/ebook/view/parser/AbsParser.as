/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;

	/**
	 * Abstract Parser Class
	 * Do not instantiate this class
	 */
	public class AbsParser
	{
		private var _target:DisplayObjectContainer;
		private var _contentXML:XML;
		private var _stylesheet:StyleSheet;

		public function AbsParser()
		{
		}

		public function parse():void
		{
		}

		public function get target():DisplayObjectContainer
		{
			return _target;
		}

		public function set target(value:DisplayObjectContainer):void
		{
			_target = value;
		}

		public function get contentXML():XML
		{
			return _contentXML;
		}

		public function set contentXML(value:XML):void
		{
			_contentXML = value;
		}

		public function get stylesheet():StyleSheet
		{
			return _stylesheet;
		}

		public function set stylesheet(value:StyleSheet):void
		{
			_stylesheet = value;
		}
	}
}
