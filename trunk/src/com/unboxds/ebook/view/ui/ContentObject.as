package com.unboxds.ebook.view.ui
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.unboxds.ebook.model.ContentParser;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.StyleSheet;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	
	public class ContentObject extends Sprite
	{
		private var _contentXML:XML;
		private var _stylesheet:StyleSheet;
		private var _target:Sprite;
		
		protected var _onShow:Signal;
		protected var _onHide:Signal;
		
		public function ContentObject(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			_contentXML = contentXML;
			_stylesheet = stylesheet;
			
			_target = this;
			_target.alpha = 0;
			_target.visible = false;
			
			_onShow = new Signal();
			_onHide = new Signal();
			
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		public function parseContent():void
		{
			new ContentParser(_target, contentXML, stylesheet).parse();
			
			var tweenXML:XML = XML(XMLList(_contentXML.tween).toXMLString());
			if (tweenXML.hasComplexContent())
				new TweenParser(_target, tweenXML).parse();
		}
		
		public function show():void
		{
			TweenLite.to(this, .25, {autoAlpha: 1, onComplete: onCompleteShow});
		}
		
		public function hide():void
		{
			TweenLite.to(this, .25, {autoAlpha: 0, onComplete: onCompleteHide});
		}
		
		public function onCompleteShow(e:Event = null):void
		{
			_onShow.dispatch();
		}
		
		public function onCompleteHide(e:Event = null):void
		{
			_onHide.dispatch();
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
		
		public function set target(value:Sprite):void
		{
			_target = value;
		}
		
		public function get onShow():ISignal
		{
			return _onShow;
		}
		
		public function get onHide():ISignal
		{
			return _onHide;
		}
		
		public function get target():Sprite
		{
			return _target;
		}
	
	}

}