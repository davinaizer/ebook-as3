package com.unboxds.ebook.view.ui
{
	import assets.AboutPanelSymbol;

	import com.unboxds.utils.Logger;

	import flash.events.Event;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class AboutPanel extends ContentObject
	{
		private var view:AboutPanelSymbol;
		
		public function AboutPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);
			
			Logger.log("AboutPanel.AboutPanel");
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		private function init():void
		{
			Logger.log("AboutPanel.init");
			
			this.x = parseFloat(contentXML.@x);
			this.y = parseFloat(contentXML.@y);
			
			view = new AboutPanelSymbol();
			view.cacheAsBitmap = true;
			view.baseBox_Placeholder.visible = false;
			addChild(view);
			
			target = view;
			parseContent();
		}

	}

}