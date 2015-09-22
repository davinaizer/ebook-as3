package com.unboxds.ebook
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.controller.DataController;
	import com.unboxds.ebook.controller.NavController;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.utils.ArrayUtils;
	import com.unboxds.utils.DebugPanel;
	import com.unboxds.utils.Logger;

	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;

	import org.osflash.signals.ISignal;

	/**
	 * Wrapper class to basic Ebook Class initialization.
	 *
	 * When Ebook Framework has complete loading, onComplete Signal is dispatched.
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookContext
	{
		private var data:XML;
		private var contextView:DisplayObjectContainer;
		private var ebook:Ebook;
		private var status:EbookModel;
		private var nav:NavController;
		private var dataController:DataController;
		
		private var _onComplete:ISignal;
		private var debugPanel:DebugPanel;
		
		public function EbookContext(contextView:DisplayObjectContainer, data:XML)
		{
			this.data = data;
			this.contextView = contextView;
		}
		
		public function startup():void
		{
			Logger.log("EbookContext.startup");
			
			ebook = Ebook.getInstance();
			status = ebook.getStatus();
			nav = ebook.getNav();
			dataController = ebook.getDataController();
			
			config();
		}
		
		private function config():void
		{
			Logger.log("EbookContext.config");
			
			//-- start navigation controller
			nav.xmlData = data;
			nav.onChange.add(navHandler);
			nav.init();
			
			//-- start custom data
			status.ebookVersion = data.config.@version;
			status.lessonStatus.maxPoints = ArrayUtils.toNumber(data.config.customData.maxPoints.toString().split(","));
			status.lessonStatus.lessonStatus = ArrayUtils.toNumber(data.config.customData.lessonStatus.toString().split(","));
			status.lessonStatus.userPoints = ArrayUtils.fillArray(status.lessonStatus.maxPoints.length, -1);
			
			//-- start ebook params
			dataController.enableAlerts = data.config.@enableAlerts == "true";
			dataController.isConsultMode = data.config.@consultMode == "true";
			dataController.dataServiceType = data.config.@dataServiceType;
			dataController.scormReplaceDoubleQuotes = data.config.@scormReplaceDoubleQuotes == "true";
			dataController.enableDebugPanel = data.config.@enableDebugPanel == "true";
			
			//-- start debug panel
			if (dataController.enableDebugPanel)
			{
				debugPanel = new DebugPanel(this.contextView, nav.totalPages);
				debugPanel.setCallbacks(nav.backPage, nav.nextPage, nav.navigateToPageIndex);
				Logger.callback = debugPanel.logToPanel;
				ebook.setDebugPanel(debugPanel);
			}
		}
		
		private function navHandler(page:PageData):void
		{
			Logger.log(page.toString());
			
			Gaia.api.goto(page.branch);
			
			if (!ExternalInterface.available)
				dataController.save();
		}
		
		public function get onComplete():ISignal
		{
			return _onComplete;
		}
		
		public function set onComplete(value:ISignal):void
		{
			_onComplete = value;
		}

	}

}