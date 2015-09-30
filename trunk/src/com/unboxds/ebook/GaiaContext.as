package com.unboxds.ebook
{
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.core.GaiaMain;

	import flash.events.Event;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * Wrapper for Gaia Framework initization.
	 *
	 * When Gaia Framework has complete loading, onComplete Signal is dispatched.
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class GaiaContext extends GaiaMain
	{
		private var _data:XML;
		private var _onComplete:Signal;
		
		public function GaiaContext()
		{
			super();
			siteXML = "xml/ebook_nav.xml";
			
			_onComplete = new Signal();
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			//alignSite(1000, 600);
			super.onAddedToStage(event);
		}
		
		override protected function onResize(event:Event):void
		{
			//view.x = Math.round((stage.stageWidth - __WIDTH) / 2);
			//view.y = Math.round((stage.stageHeight - __HEIGHT) / 2);
		}
		
		override protected function init():void
		{
			initComplete();
			
			_data = Gaia.api.getSiteXML();
			_onComplete.dispatch();
		}
		
		/**
		 * Returns the XML data from ebook_nav.xml
		 */
		public function get data():XML
		{
			return _data;
		}
		
		/**
		 * The signal dispatched when Gaia is complete all initialization
		 */
		public function get onComplete():ISignal
		{
			return _onComplete;
		}

	}

}