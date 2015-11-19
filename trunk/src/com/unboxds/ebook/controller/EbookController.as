package com.unboxds.ebook.controller
{
	import com.unboxds.ebook.EbookApi;
	import com.unboxds.ebook.constants.EbookConstants;
	import com.unboxds.ebook.constants.ScormConstants;
	import com.unboxds.ebook.constants.ServiceConstants;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.NavModel;
	import com.unboxds.ebook.model.vo.EbookVO;
	import com.unboxds.ebook.services.IEbookDataService;
	import com.unboxds.ebook.services.LocalStorageService;
	import com.unboxds.ebook.services.ScormDataService;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.external.ExternalInterface;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookController
	{
		private var model:EbookModel;
		private var controller:EbookController;
		private var navModel:NavModel;
		private var navController:NavController;

		private var dataService:IEbookDataService;

		public function EbookController()
		{
		}

		/********************* Start *********************/
		public function start():void
		{
			Logger.log("EbookController.start");

			model = EbookApi.getEbookModel();
			controller = EbookApi.getEbookController();
			navModel = EbookApi.getNavModel();
			navController = EbookApi.getNavController();

			model.isConsultMode ? startBrowseMode() : initDataService();
		}

		public function startBrowseMode():void
		{
			Logger.log("EbookController.startBrowseMode");
			Logger.log("*** RUNNING BROWSE MODE ***");

			if (model.isExtIntAvailable && model.enableAlerts)
				ExternalInterface.call("alert", "Iniciando o treinamento em modo CONSULTA.\n\nSeus dados não serão gravados.");

			model.isConsultMode = true;

			navModel.maxModule = navModel.totalModules - 1;
			navModel.maxPage = navModel.getPages()[navModel.totalPages - 1].localIndex;
			navModel.currentModule = 0;
			navModel.currentPage = 0;

			navController.loadPage();
		}

		private function initDataService():void
		{
			Logger.log("EbookController.initDataService > dataServiceType: " + model.dataServiceType);

			switch (model.dataServiceType)
			{
				case ServiceConstants.SCORM_SERVER:
					dataService = new ScormDataService();
					break;

				case ServiceConstants.LOCAL_STORAGE:
					dataService = new LocalStorageService();
					break;
			}

			if (model.isExtIntAvailable)
				ExternalInterface.addCallback("jsCall", jsCall);

			dataService.onLoad.add(onDataLoaded);
			dataService.onSave.add(onDataSaved);
			dataService.onLoadError.add(onDataLoadError);
			dataService.onSaveError.add(onDataSaveError);
			dataService.load();
		}

		private function onDataLoaded(data:EbookVO):void
		{
			Logger.log("EbookController.onDataLoaded");

			Logger.log("EbookController >>>>>>>>>> CHECKING DATA LOADED <<<<<<<< ");
			Logger.log(ObjectUtils.toString(data));

			model.isDataServiceAvailable = true;
			model.restore(data);

			//-- check browse mode
			if (model.lessonMode == ScormConstants.MODE_BROWSE)
			{
				startBrowseMode();
			}
			else
			{
				if (model.status == EbookConstants.STATUS_NOT_INITIALIZED || model.lessonStatus == ScormConstants.STATUS_NOT_ATTEMPTED)
				{
					Logger.log("EbookController.initDataService >> New user!");

					model.status = EbookConstants.STATUS_INITIALIZED;
					model.lessonStatus = ScormConstants.STATUS_INCOMPLETE;

					save();
				}
				else
				{
					Logger.log("EbookController.initDataService >> Ebook data read from server.");
					navModel.restore(data.navVO);
				}

				model.startTimer();
				navController.loadPage();
			}
		}

		//** EVENTS HANDLER

		private function onDataSaved():void
		{
			Logger.log("EbookController.onDataSaved >> Saved successfully!");
		}

		private function onDataLoadError(msg:String):void
		{
			Logger.log("EbookController.onDataLoadError >> " + msg);

			if (model.isExtIntAvailable && model.enableAlerts)
				ExternalInterface.call("alert", "Erro ao carregar dados do DATASERVICE (" + model.dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);

			model.isDataServiceAvailable = false;
			startBrowseMode();
		}

		private function onDataSaveError(msg:String):void
		{
			Logger.log("EbookController.onDataSaveError >> " + msg);

			if (model.isExtIntAvailable && model.enableAlerts)
				ExternalInterface.call("alert", "Erro ao salvar dados no DATASERVICE (" + model.dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);
		}

		/********************* SAVE *********************/
		public function save():void
		{
			Logger.log("EbookController.save");

			if (model.isDataServiceAvailable && !model.isConsultMode && model.lessonStatus == ScormConstants.STATUS_INCOMPLETE)
			{
				if (model.status == EbookConstants.STATUS_COMPLETED)
					model.lessonStatus = ScormConstants.STATUS_COMPLETED;

				var data:EbookVO = model.dump();
				data.navVO = navModel.dump();

				Logger.log(ObjectUtils.toString(data));

				dataService.save(data);
			}
			else
			{
				Logger.log("EbookController.save >> Not allowed to save!");
			}
		}

		public function finishEbook():void
		{
			Logger.log("EbookController.finishEbook");

			if (model.isConsultMode == false && model.status == EbookConstants.STATUS_INITIALIZED)
			{
				model.endDate = new Date();
				model.status = EbookConstants.STATUS_COMPLETED;

				save();
			}
			else
			{
				Logger.log("EbookController.finishEbook >> Course STATUS_COMPLETED, not allowed to save any more data!");
			}
		}

		public function closeBrowser():void
		{
			Logger.log("EbookController.closeBrowser");

			if (model.isExtIntAvailable)
			{
				ExternalInterface.call("scorm.save");
				ExternalInterface.call("scorm.quit");
				ExternalInterface.call("exit");
			}
			else
			{
				Logger.log("EbookController.closeBrowser >> ExternalInterface not available!");
			}
		}

		public function jsCall(functionName:String, params:String):void
		{
			Logger.log("EbookController.jsCall > functionName : " + functionName + ", params : " + params);

			switch (functionName)
			{
				case "save":
					save();
					break;

				case "exit":
					closeBrowser();
					break;

				default:
			}
		}
	}
}