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

	/**
	 * Wrapper class to basic EbookApi Class initialization.
	 * When EbookApi Framework has complete loading, onComplete Signal is dispatched.
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookContext
	{
		private var data:XML;
		private var contextView:DisplayObjectContainer;

		private var ebookModel:EbookModel;
		private var ebookController:EbookController;
		private var navModel:NavModel;
		private var navController:NavController;

		private var debugPanel:DebugPanel;

		public function EbookContext(contextView:DisplayObjectContainer, data:XML)
		{
			this.data = data;
			this.contextView = contextView;
		}

		public function bootstrap():void
		{
			Logger.log("[EbookAS Framework]\n[UNBOX® 2009-2015 — http://www.unbox.com.br — All rights reserved.]");
			Logger.log("EbookContext.startup");

			ebookModel = EbookApi.getEbookModel();
			ebookController = EbookApi.getEbookController();
			navModel = EbookApi.getNavModel();
			navController = EbookApi.getNavController();

			config();
		}

		private function config():void
		{
			Logger.log("EbookContext.config");

			ebookModel.enableAlerts = data.config.@enableAlerts == "true";
			ebookModel.isConsultMode = data.config.@consultMode == "true";
			ebookModel.dataServiceType = data.config.@dataServiceType;
			ebookModel.scormReplaceDoubleQuotes = data.config.@scormReplaceDoubleQuotes == "true";
			ebookModel.enableDebugPanel = data.config.@enableDebugPanel == "true";
			ebookModel.version = data.config.@version;
			ebookModel.outputXMLContent = data.config.@outputXMLContent == "true";
			ebookModel.saveOnPageChange = data.config.@saveOnPageChange == "true";
			ebookModel.activitiesMaxScore = ArrayUtils.toNumber(data.config.activities.maxScore.toString().split(","));
			ebookModel.activitiesStatus = ArrayUtils.fillArray(ebookModel.activitiesMaxScore.length, -1);
			ebookModel.activitiesUserScore = ArrayUtils.fillArray(ebookModel.activitiesMaxScore.length, -1);

			//-- start navigation
			navModel.xmlData = data;
			navModel.init();

			navController.onChange.add(navHandler);
			navController.init();

			//-- start debug panel
			if (ebookModel.enableDebugPanel)
			{
				debugPanel = new DebugPanel(this.contextView, navModel.totalPages);
				debugPanel.setCallbacks(navController.backPage, navController.nextPage, navController.navigateToPageIndex);

				Logger.callback = debugPanel.logToPanel;
				EbookApi.setDebugPanel(debugPanel);
			}
		}

		private function navHandler(page:PageVO):void
		{
			Logger.log("----------------- PAGE LOADED -----------------");
			Logger.log(page.toString());

			Gaia.api.goto(page.branch);

			if (!ebookModel.isConsultMode && ebookModel.saveOnPageChange)
				ebookController.save();
		}
	}
}