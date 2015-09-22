package com.unboxds.ebook.controller
{
	import com.unboxds.ebook.Ebook;
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
	public class DataController
	{
		private var nav:NavController;
		private var ebook:Ebook;
		private var dataService:IEbookDataService;
		private var status:EbookModel; // holds the lessondata, this data is stored inside _ebookData as lesson_suspend
		private var sessionTimer:SessionTimer;
		private var dataController:DataController;
		
		private var isExtIntAvaiable:Boolean;
		private var isDataServiceAvaiable:Boolean;
		
		private var _dataServiceType:String;
		private var _scormReplaceDoubleQuotes:Boolean;
		private var _ebookData:ScormData;
		private var _isConsultMode:Boolean;
		private var _enableAlerts:Boolean;
		private var _hasAccessibility:Boolean;
		private var _enableDebugPanel:Boolean;
		
		public function DataController()
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
			Logger.log("DataController.start");
			
			_ebookData = new ScormData();
			
			//-- get objects instances
			ebook = Ebook.getInstance();
			status = ebook.getStatus(); // TODO Use StatusModel instead
			nav = ebook.getNav();
			dataController = ebook.getDataController();
			sessionTimer = new SessionTimer();
			
			_isConsultMode ? startBrowseMode() : initDataService();
		}
		
		public function startBrowseMode():void
		{
			Logger.log("DataController.startBrowseMode");
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
			Logger.log("DataController.initDataService");
			
			if (_dataServiceType == "SCORM" && isExtIntAvaiable)
			{
				dataService = new ScormDataService();
			}
			else
			{
				Logger.log("DataController.initDataService >> DataService SCORM not available! Using SharedObject instead.");
				dataService = new SolDataService();
			}
			
			if (isExtIntAvaiable)
				ExternalInterface.addCallback("jsCall", jsCall);
			
			dataService.onLoaded.add(onDataLoaded);
			dataService.onSaved.add(onDataSaved);
			dataService.onLoadError.add(onDataLoadError);
			dataService.onSaveError.add(onDataSaveError);
			dataService.load();
		}
		
		private function onDataLoaded(data:ScormData):void
		{
			Logger.log("DataController.onDataLoaded");
			
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
					Logger.log("DataController.initDataService >> SUSPEND_DATA null OR empty. New user!");
					
					_ebookData.lesson_status = ScormData.STATUS_INCOMPLETE;
					
					status.status = EbookModel.STATUS_INITIALIZED;
					sessionTimer.initSession();
					nav.navigateToIndex(0, 0);
					
					//-- save all data
					save();
				}
				else
				{
					Logger.log("DataController.initDataService >> SUSPEND_DATA read.");
					
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
			Logger.log("DataController.onDataSaved >> Saved successfully!");
		}
		
		private function onDataLoadError(msg:String):void
		{
			Logger.log("DataController.onDataLoadError >> " + msg);
			
			if (isExtIntAvaiable && _enableAlerts)
				ExternalInterface.call("alert", "Erro ao carregar dados do DATASERVICE (" + _dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);
			
			isDataServiceAvaiable = false;
			startBrowseMode();
		}
		
		private function onDataSaveError(msg:String):void
		{
			Logger.log("DataController.onDataSaveError >> " + msg);
			
			if (isExtIntAvaiable && _enableAlerts)
				ExternalInterface.call("alert", "Erro ao salvar dados no DATASERVICE (" + _dataServiceType + ").\n\nContate o administrador do sistema.\n\n" + msg);
		}
		
		/********************* SAVE *********************/
		public function save():void
		{
			Logger.log("DataController.save");
			
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
				Logger.log("DataController.save >> Not allowed to save!");
			}
		}
		
		public function finishEbook():void
		{
			Logger.log("DataController.finishEbook");
			
			if (!_isConsultMode && status.status == EbookModel.STATUS_INITIALIZED)
			{
				status.endDate = new Date();
				status.status = EbookModel.STATUS_COMPLETED;
				_ebookData.exit = ScormData.EXIT_LOGOUT;
				
				save();
			}
			else
			{
				Logger.log("DataController.finishEbook >> Course STATUS_COMPLETED, not allowed to save any more data!");
			}
		}
		
		public function closeBrowser():void
		{
			Logger.log("DataController.closeBrowser");
			
			if (isExtIntAvaiable)
			{
				ExternalInterface.call("scorm.save");
				ExternalInterface.call("API_Extended.SetNavCommand('exit')"); // SUNTOTAL API
				ExternalInterface.call("scorm.quit");
				ExternalInterface.call("exit");
			}
			else
			{
				Logger.log("DataController.closeBrowser >> ExternalInterface not available!");
			}
		}
		
		public function jsCall(functionName:String, params:String):void
		{
			Logger.log("DataController.jsCall > functionName : " + functionName + ", params : " + params);
			
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