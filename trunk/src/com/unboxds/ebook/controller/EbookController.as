package com.unboxds.ebook.controller
{
	import com.unboxds.ebook.EbookApi;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.SessionTimer;
	import com.unboxds.ebook.model.vo.ScormData;
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
		private var controller:EbookController;
		private var status:EbookModel;

		private var nav:NavController;

		private var ebookApi:EbookApi;

		//TODO Services should be inside a Model.
		private var dataService:IEbookDataService;

		//TODO Move DATA to MODEL
		private var sessionTimer:SessionTimer;
		private var isExtIntAvaiable:Boolean;
		private var isDataServiceAvaiable:Boolean;

		private var _dataServiceType:String;
		private var _scormReplaceDoubleQuotes:Boolean;
		private var _ebookData:ScormData;
		private var _isConsultMode:Boolean;
		private var _enableAlerts:Boolean;
		private var _hasAccessibility:Boolean;
		private var _enableDebugPanel:Boolean;

		public function EbookController()
		{
			_isConsultMode = false;
			_enableAlerts = true;
			_dataServiceType = "SharedObject";

			isDataServiceAvaiable = false;
			isExtIntAvaiable = ExternalInterface.available;
		}

		/********************* Start *********************/
		public function start():void
		{
			Logger.log("EbookController.start");

			_ebookData = new ScormData();

			//-- get objects instances
			ebookApi = EbookApi.getInstance();
			status = ebookApi.getEbookModel(); // TODO Use StatusModel instead
			nav = ebookApi.getNavController();
			controller = ebookApi.getEbookController();
			sessionTimer = new SessionTimer();

			_isConsultMode ? startBrowseMode() : initDataService();
		}

		public function startBrowseMode():void
		{
			Logger.log("EbookController.startBrowseMode");
			Logger.log("*** RUNNING BROWSE MODE ***");

			if (isExtIntAvaiable && _enableAlerts)
				ExternalInterface.call("alert", "Iniciando o treinamento em modo CONSULTA.\n\nSeus dados não serão gravados.");

			_isConsultMode = true;

			status.maxModule = nav.totalModules - 1;
			status.maxPage = nav.getPages()[nav.totalPages - 1].localIndex;
			status.currentModule = 0;
			status.currentPage = 0;

			nav.loadPage();
		}

		private function initDataService():void
		{
			Logger.log("EbookController.initDataService");

			if (_dataServiceType == "SCORM" && isExtIntAvaiable)
			{
				dataService = new ScormDataService();
			}
			else
			{
				Logger.log("EbookController.initDataService >> DataService SCORM not available! Using SharedObject instead.");
				dataService = new SolDataService();
			}

			if (isExtIntAvaiable)
				ExternalInterface.addCallback("jsCall", jsCall);

			dataService.onLoad.add(onDataLoaded);
			dataService.onSave.add(onDataSaved);
			dataService.onLoadError.add(onDataLoadError);
			dataService.onSaveError.add(onDataSaveError);
			dataService.load();
		}

		private function onDataLoaded(data:ScormData):void
		{
			Logger.log("EbookController.onDataLoaded");

			isDataServiceAvaiable = true;

			_ebookData = data;

			for (var i:Object in _ebookData)
				Logger.log("	LOAD SCORM DATA >> " + i + ", value : " + _ebookData[i]);

			//-- check browse mode
			if (_ebookData.lesson_mode == ScormData.MODE_BROWSE)
			{
				startBrowseMode();
			}
			else
			{
				if (_ebookData.suspend_data == null || _ebookData.suspend_data == "" || _ebookData.lesson_status == ScormData.STATUS_NOT_ATTEMPTED)
				{
					Logger.log("EbookController.initDataService >> SUSPEND_DATA null OR empty. New user!");

					_ebookData.lesson_status = ScormData.STATUS_INCOMPLETE;

					status.status = EbookModel.STATUS_INITIALIZED;
					sessionTimer.initSession();
					nav.navigateToIndex(0, 0);

					//-- save all data
					save();
				}
				else
				{
					Logger.log("EbookController.initDataService >> SUSPEND_DATA read.");

					//-- read saved data
					_ebookData.suspend_data = _ebookData.suspend_data.replace(/'/g, "\"");

					status.parseData(_ebookData.suspend_data);
					sessionTimer.initSession();
					nav.navigateToIndex(status.currentModule, status.currentPage);
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

			if (isExtIntAvaiable && _enableAlerts)
				ExternalInterface.call("alert", "Erro ao carregar dados do DATASERVICE (" + _dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);

			isDataServiceAvaiable = false;
			startBrowseMode();
		}

		private function onDataSaveError(msg:String):void
		{
			Logger.log("EbookController.onDataSaveError >> " + msg);

			if (isExtIntAvaiable && _enableAlerts)
				ExternalInterface.call("alert", "Erro ao salvar dados no DATASERVICE (" + _dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);
		}

		/********************* SAVE *********************/
		public function save():void
		{
			Logger.log("EbookController.save");

			if (isDataServiceAvaiable && !_isConsultMode && _ebookData.lesson_status == ScormData.STATUS_INCOMPLETE)
			{
				if (status.status == EbookModel.STATUS_COMPLETED)
					_ebookData.lesson_status = ScormData.STATUS_COMPLETED;

				//-- SUSPEND_DATA - REPLACE DOUBLE QUOTES? - LMS campatibility check (BUG from some LMS vendors)
				_ebookData.suspend_data = (_scormReplaceDoubleQuotes) ? status.toString().replace(/"/g, "'") : status.toString();
				_ebookData.session_time = sessionTimer.getCMISessionTime();

				for (var i:String in _ebookData)
					Logger.log("	SAVE EBOOK DATA >> " + i + ", value : " + _ebookData[i]);

				//-- contact dataService to SAVE Data
				dataService.save(_ebookData);
			}
			else
			{
				Logger.log("EbookController.save >> Not allowed to save!");
			}
		}

		public function finishEbook():void
		{
			Logger.log("EbookController.finishEbook");

			if (!_isConsultMode && status.status == EbookModel.STATUS_INITIALIZED)
			{
				status.endDate = new Date();
				status.status = EbookModel.STATUS_COMPLETED;
				_ebookData.exit = ScormData.EXIT_LOGOUT;

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

			if (isExtIntAvaiable)
			{
				ExternalInterface.call("scorm.save");
				ExternalInterface.call("API_Extended.SetNavCommand('exit')"); // SUNTOTAL API
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

		public function get isConsultMode():Boolean
		{
			return _isConsultMode;
		}

		public function set isConsultMode(value:Boolean):void
		{
			_isConsultMode = value;
		}

		public function get ebookData():ScormData
		{
			return _ebookData;
		}

		public function set ebookData(value:ScormData):void
		{

			_ebookData = value;
		}

		public function get dataServiceType():String
		{
			return _dataServiceType;
		}

		public function set dataServiceType(value:String):void
		{
			_dataServiceType = value;
		}

		public function get enableAlerts():Boolean
		{
			return _enableAlerts;
		}

		public function set enableAlerts(value:Boolean):void
		{
			_enableAlerts = value;
		}

		public function get hasAccessibility():Boolean
		{
			return _hasAccessibility;
		}

		public function set hasAccessibility(value:Boolean):void
		{
			_hasAccessibility = value;
		}

		public function get enableDebugPanel():Boolean
		{
			return _enableDebugPanel;
		}

		public function set enableDebugPanel(value:Boolean):void
		{
			_enableDebugPanel = value;
		}

		public function get scormReplaceDoubleQuotes():Boolean
		{
			return _scormReplaceDoubleQuotes;
		}

		public function set scormReplaceDoubleQuotes(value:Boolean):void
		{
			_scormReplaceDoubleQuotes = value;
		}
	}

}