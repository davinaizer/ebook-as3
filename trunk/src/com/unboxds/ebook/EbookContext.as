package com.unboxds.ebook
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.controller.EbookController;
	import com.unboxds.ebook.controller.NavController;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.NavModel;
	import com.unboxds.ebook.model.vo.PageVO;
	import com.unboxds.utils.ArrayUtils;
	import com.unboxds.utils.DebugPanel;
	import com.unboxds.utils.Logger;

	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;

	/**
	 * Wrapper class to basic EbookApi Class initialization.
	 * When EbookApi Framework has complete loading, onComplete Signal is dispatched.
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookContext
	{
		private var data:XML;
		private var contextView:DisplayObjectContainer;

		private var model:EbookModel;
		private var controller:EbookController;
		private var navModel:NavModel;
		private var navController:NavController;

		private var debugPanel:DebugPanel;

		public function EbookContext(contextView:DisplayObjectContainer, data:XML)
		{
			this.data = data;
			this.contextView = contextView;
		}

		public function startup():void
		{
			Logger.log("EbookContext.startup");

			model = EbookApi.getInstance().getEbookModel();
			controller = EbookApi.getInstance().getEbookController();
			navModel = EbookApi.getInstance().getNavModel();
			navController = EbookApi.getInstance().getNavController();

			config();
		}

		private function config():void
		{
			Logger.log("EbookContext.config");

			//-- start ebook params
			// TODO The logic for parse config data should be inside the MODEL
			model.enableAlerts = data.config.@enableAlerts == "true";
			model.isConsultMode = data.config.@consultMode == "true";
			model.dataServiceType = data.config.@dataServiceType;
			model.scormReplaceDoubleQuotes = data.config.@scormReplaceDoubleQuotes == "true";
			model.enableDebugPanel = data.config.@enableDebugPanel == "true";
			model.version = data.config.@version;
			model.customData.maxPoints = ArrayUtils.toNumber(data.config.customData.maxPoints.toString().split(","));
			model.customData.lessonStatus = ArrayUtils.toNumber(data.config.customData.lessonStatus.toString().split(","));
			model.customData.userPoints = ArrayUtils.fillArray(model.customData.maxPoints.length, -1);

			//-- start navigation controller
			navController.xmlData = data;
			navController.onChange.add(navHandler);
			navController.init();

			//-- start debug panel
			if (model.enableDebugPanel)
			{
				debugPanel = new DebugPanel(this.contextView, navModel.totalPages);
				debugPanel.setCallbacks(navController.backPage, navController.nextPage, navController.navigateToPageIndex);

				Logger.callback = debugPanel.logToPanel;
				EbookApi.getInstance().setDebugPanel(debugPanel);
			}
		}

		private function navHandler(page:PageVO):void
		{
			Logger.log(page.toString());

			Gaia.api.goto(page.branch);

			if (!ExternalInterface.available)
				controller.save();
		}

	}

}