package com.unboxds.ebook
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.controller.EbookController;
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
	 * Wrapper class to basic EbookApi Class initialization.
	 *
	 * When EbookApi Framework has complete loading, onComplete Signal is dispatched.
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookContext
	{
		private var data:XML;
		private var contextView:DisplayObjectContainer;

		private var ebookModel:EbookModel;
		private var ebookController:EbookController;

		private var navController:NavController;

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

			ebookModel = EbookApi.getInstance().getEbookModel();
			ebookController = EbookApi.getInstance().getEbookController();

			navController = EbookApi.getInstance().getNavController();

			config();
		}

		private function config():void
		{
			Logger.log("EbookContext.config");

			//-- start navigation controller
			navController.xmlData = data;
			navController.onChange.add(navHandler);
			navController.init();

			//-- start custom data
			ebookModel.ebookVersion = data.config.@version;
			ebookModel.lessonStatus.maxPoints = ArrayUtils.toNumber(data.config.customData.maxPoints.toString().split(","));
			ebookModel.lessonStatus.lessonStatus = ArrayUtils.toNumber(data.config.customData.lessonStatus.toString().split(","));
			ebookModel.lessonStatus.userPoints = ArrayUtils.fillArray(ebookModel.lessonStatus.maxPoints.length, -1);

			//-- start ebook params
			ebookController.enableAlerts = data.config.@enableAlerts == "true";
			ebookController.isConsultMode = data.config.@consultMode == "true";
			ebookController.dataServiceType = data.config.@dataServiceType;
			ebookController.scormReplaceDoubleQuotes = data.config.@scormReplaceDoubleQuotes == "true";
			ebookController.enableDebugPanel = data.config.@enableDebugPanel == "true";

			//-- start debug panel
			if (ebookController.enableDebugPanel)
			{
				debugPanel = new DebugPanel(this.contextView, navController.totalPages);
				debugPanel.setCallbacks(navController.backPage, navController.nextPage, navController.navigateToPageIndex);

				Logger.callback = debugPanel.logToPanel;
				EbookApi.getInstance().setDebugPanel(debugPanel);
			}
		}

		private function navHandler(page:PageData):void
		{
			Logger.log(page.toString());

			Gaia.api.goto(page.branch);

			if (!ExternalInterface.available)
				ebookController.save();
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