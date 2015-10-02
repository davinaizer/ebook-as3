package com.unboxds.ebook.controller
{
	import com.unboxds.ebook.EbookApi;
	import com.unboxds.ebook.constants.EbookConstants;
	import com.unboxds.ebook.constants.ScormConstants;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.NavModel;
	import com.unboxds.ebook.model.SessionTimer;
	import com.unboxds.ebook.model.vo.EbookData;
	import com.unboxds.ebook.services.IEbookDataService;
	import com.unboxds.ebook.services.ScormDataService;
	import com.unboxds.ebook.services.SolDataService;
	import com.unboxds.utils.Logger;

	import flash.external.ExternalInterface;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */

		//TODO Refactor Controller
	public class EbookController
	{
		private var model:EbookModel;
		private var controller:EbookController;
		private var navModel:NavModel;
		private var navController:NavController;

		//TODO Services should be inside a Model.
		private var dataService:IEbookDataService;

		//TODO Move DATA to MODEL
		private var sessionTimer:SessionTimer;

		public function EbookController()
		{
		}

		/********************* Start *********************/
		public function start():void
		{
			Logger.log("EbookController.start");

			//-- get objects instances
			model = EbookApi.getInstance().getEbookModel();
			controller = EbookApi.getInstance().getEbookController();
			navModel = EbookApi.getInstance().getNavModel();
			navController = EbookApi.getInstance().getNavController();

			sessionTimer = new SessionTimer();

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

			if (model.dataServiceType == "SCORM" && model.isExtIntAvailable)
			{
				dataService = new ScormDataService();
			}
			else
			{
				dataService = new SolDataService();
			}

			if (model.isExtIntAvailable)
				ExternalInterface.addCallback("jsCall", jsCall);

			dataService.onLoad.add(onDataLoaded);
			dataService.onSave.add(onDataSaved);
			dataService.onLoadError.add(onDataLoadError);
			dataService.onSaveError.add(onDataSaveError);
			dataService.load();
		}

		private function onDataLoaded(data:EbookData):void
		{
			Logger.log("EbookController.onDataLoaded");

			model.isDataServiceAvailable = true;
			model.ebookData = data;

			for (var i:String in model.ebookData)
				Logger.log("	LOAD SCORM DATA >> " + i + ", value : " + model.ebookData[i]);

			//-- check browse mode
			if (model.ebookData.lesson_mode == ScormConstants.MODE_BROWSE)
			{
				startBrowseMode();
			}
			else
			{
				if (model.ebookData.suspend_data == null || model.ebookData.suspend_data == "" || model.ebookData.lesson_status == ScormConstants.STATUS_NOT_ATTEMPTED)
				{
					Logger.log("EbookController.initDataService >> SUSPEND_DATA null OR empty. New user!");

					model.ebookData.lesson_status = ScormConstants.STATUS_INCOMPLETE;

					model.status = EbookConstants.STATUS_INITIALIZED;
					sessionTimer.initSession();
					navController.loadPage();

					//-- save all data
					save();
				}
				else
				{
					Logger.log("EbookController.initDataService >> SUSPEND_DATA read.");

					//-- read saved data
					model.ebookData.suspend_data = model.ebookData.suspend_data.replace(/'/g, "\"");

					model.parseData(model.ebookData.suspend_data);
					sessionTimer.initSession();
					navController.loadPage(); // loads current page
				}
			}
		}

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

			if (model.isDataServiceAvailable && !model.isConsultMode && model.ebookData.lesson_status == ScormConstants.STATUS_INCOMPLETE)
			{
				if (model.status == EbookConstants.STATUS_COMPLETED)
					model.ebookData.lesson_status = ScormConstants.STATUS_COMPLETED;

				//-- SUSPEND_DATA - REPLACE DOUBLE QUOTES? - LMS compatibility check (BUG from some LMS vendors)
				model.ebookData.suspend_data = (model.scormReplaceDoubleQuotes) ? model.toString().replace(/"/g, "'") : model.toString();
				model.ebookData.session_time = sessionTimer.getCMISessionTime();

				for (var i:String in model.ebookData)
					Logger.log("	SAVE EBOOK DATA >> " + i + ", value : " + model.ebookData[i]);

				//-- contact dataService to SAVE Data
				dataService.save(model.ebookData);
			}
			else
			{
				Logger.log("EbookController.save >> Not allowed to save!");
			}
		}

		public function finishEbook():void
		{
			Logger.log("EbookController.finishEbook");

			if (!model.isConsultMode && model.status == EbookConstants.STATUS_INITIALIZED)
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

		/********************* GETTERS and SETTERS *********************/
		public function get ebookData():EbookData
		{
			return model.ebookData;
		}

		public function set ebookData(value:EbookData):void
		{
			model.ebookData = value;
		}

	}

}