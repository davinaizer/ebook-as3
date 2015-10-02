package com.unboxds.ebook.view.ui
{
	import assets.HelpPanelSymbol;

	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class HelpPanel extends UIPanel
	{
		private var view:HelpPanelSymbol;
		private var openTween:TweenMax;
		
		public function HelpPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			Logger.log("HelpPanel.HelpPanel");
			
			super(contentXML, stylesheet);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		public function init():void
		{
			Logger.log("HelpPanel.init");
			
			view = new HelpPanelSymbol();
			view.cacheAsBitmap = true;
			view.x = parseFloat(contentXML.@x);
			view.y = parseFloat(contentXML.@y);
			addChild(view);
			
			target = view;
			
			//-- read Tweeen
			var tweenData:XMLList = contentXML.tween.tween.(@id == "openTween");
			openTween = TweenParser.getTweenFromXML(target, tweenData[0]);
			openTween.addEventListener(TweenEvent.COMPLETE, onCompleteShow);
			openTween.addEventListener(TweenEvent.REVERSE_COMPLETE, onCompleteHide);
			
			parseContent();
			
			super.show();
		}
		
		override public function show():void
		{
			Logger.log("HelpPanel.show");
			openTween.play();
		}
		
		override public function hide():void
		{
			Logger.log("HelpPanel.hide");
			openTween.reverse();
		}
		
	}

}