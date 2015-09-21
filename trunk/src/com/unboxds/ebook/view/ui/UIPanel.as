package com.unboxds.ebook.view.ui
{
	import flash.text.StyleSheet;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author Davi Naizer @ UNBOX Learning Experience
	 */
	public class UIPanel extends ContentObject
	{
		protected var _onOpen:Signal;
		protected var _onClose:Signal;
		protected var _isOpen:Boolean;
		
		public function UIPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);
			
			_onOpen = new Signal();
			_onClose = new Signal();
			_isOpen = false;
		}
		
		public function open():void
		{
			if (!_isOpen)
			{
				show();
				_isOpen = true;
				_onOpen.dispatch();
			}
		}
		
		public function close():void
		{
			if (_isOpen)
			{
				hide();
				_isOpen = false;
				_onClose.dispatch();
			}
		}
		
		public function get onOpen():ISignal
		{
			return _onOpen;
		}
		
		public function get onClose():ISignal
		{
			return _onClose;
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
		}

	}

}