package com.unboxds.ebook.model
{
	import com.unboxds.ebook.constants.EbookConstants;
	import com.unboxds.ebook.model.vo.CustomData;
	import com.unboxds.ebook.model.vo.EbookData;

	import flash.external.ExternalInterface;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookModel
	{
		//-- Behaviour
		private var _isExtIntAvailable:Boolean;
		private var _isDataServiceAvailable:Boolean;
		private var _dataServiceType:String;
		private var _scormReplaceDoubleQuotes:Boolean;
		private var _isConsultMode:Boolean;
		private var _enableAlerts:Boolean;
		private var _enableDebugPanel:Boolean;

		//-- State
		private var _ebookVersion:String;
		private var _status:int;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;

		//-- Nav State
		private var _ebookData:EbookData;
		private var _lessonStatus:CustomData;

		public function EbookModel()
		{
			_isConsultMode = false;
			_enableAlerts = true;
			_dataServiceType = "SharedObject";
			_isDataServiceAvailable = false;
			_isExtIntAvailable = ExternalInterface.available;
			_scormReplaceDoubleQuotes = false;
			_enableDebugPanel = true;

			_ebookVersion = "";
			_status = EbookConstants.STATUS_NOT_INITIALIZED;
			_quizTries = 0;
			_quizScore = 0;
			_quizStatus = EbookConstants.STATUS_NOT_INITIALIZED;
			_startDate = new Date();
			_endDate = new Date();

			_ebookData = new EbookData();
			_lessonStatus = new CustomData();
		}

		public function parseData(values:String):void
		{
			if (values != null)
			{
				if (values.length > 4096)
					throw new Error("*** WARNING: Data overflow! ParseData string > 4096 chars ***");

				//-- Parse Data
				var data:Array = values.split(EbookConstants.DELIMITER);

				_ebookVersion = data[0];
				_status = parseInt(data[1]);
				_quizStatus = parseInt(data[2]);
				_quizTries = parseInt(data[3]);
				_quizScore = parseInt(data[4]);
				_startDate = new Date(data[5]);
				_endDate = new Date(data[6]);

//				_ebookData = new EbookData(); // Todo pass string data to parse
				_lessonStatus = new CustomData().parseData(String(data[7]));
			}
		}

		public function toString():String
		{
			var data:Array = [];

			data.push(_ebookVersion);
			data.push(_status);
//			data.push(_maxPage);
//			data.push(_maxModule);
//			data.push(_currentPage);
//			data.push(_currentModule);
//			data.push(_currentLesson);
			data.push(_quizStatus);
			data.push(_quizTries);
			data.push(_quizScore);
			data.push(_startDate.toString());
			data.push(_endDate.toString());
//			data.push(_ebookData.toString());
			data.push(_lessonStatus.toString());

			return data.join(EbookConstants.DELIMITER);
		}

		/*** GETTERS and SETTERS ***/

		public function get ebookVersion():String
		{
			return _ebookVersion;
		}

		public function set ebookVersion(ebookVersion:String):void
		{
			_ebookVersion = ebookVersion;
		}

		public function get quizTries():int
		{
			return _quizTries;
		}

		public function set quizTries(quizCount:int):void
		{
			_quizTries = quizCount;
		}

		public function get quizScore():int
		{
			return _quizScore;
		}

		public function set quizScore(quizScore:int):void
		{
			_quizScore = quizScore;
		}

		public function get quizStatus():int
		{
			return _quizStatus;
		}

		public function set quizStatus(quizStatus:int):void
		{
			_quizStatus = quizStatus;
		}

		public function get lessonStatus():CustomData
		{
			return _lessonStatus;
		}

		public function set lessonStatus(lessonStatus:CustomData):void
		{
			_lessonStatus = lessonStatus;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(status:int):void
		{
			_status = status;
		}

		public function get startDate():Date
		{
			return _startDate;
		}

		public function set startDate(value:Date):void
		{
			_startDate = value;
		}

		public function get endDate():Date
		{
			return _endDate;
		}

		public function set endDate(value:Date):void
		{
			_endDate = value;
		}

		public function get dataServiceType():String
		{
			return _dataServiceType;
		}

		public function set dataServiceType(value:String):void
		{
			_dataServiceType = value;
		}

		public function get scormReplaceDoubleQuotes():Boolean
		{
			return _scormReplaceDoubleQuotes;
		}

		public function set scormReplaceDoubleQuotes(value:Boolean):void
		{
			_scormReplaceDoubleQuotes = value;
		}

		public function get isConsultMode():Boolean
		{
			return _isConsultMode;
		}

		public function set isConsultMode(value:Boolean):void
		{
			_isConsultMode = value;
		}

		public function get enableAlerts():Boolean
		{
			return _enableAlerts;
		}

		public function set enableAlerts(value:Boolean):void
		{
			_enableAlerts = value;
		}

		public function get enableDebugPanel():Boolean
		{
			return _enableDebugPanel;
		}

		public function set enableDebugPanel(value:Boolean):void
		{
			_enableDebugPanel = value;
		}

		public function get isExtIntAvailable():Boolean
		{
			return _isExtIntAvailable;
		}

		public function set isExtIntAvailable(value:Boolean):void
		{
			_isExtIntAvailable = value;
		}

		public function get isDataServiceAvailable():Boolean
		{
			return _isDataServiceAvailable;
		}

		public function set isDataServiceAvailable(value:Boolean):void
		{
			_isDataServiceAvailable = value;
		}

		public function get ebookData():EbookData
		{
			return _ebookData;
		}

		public function set ebookData(value:EbookData):void
		{
			_ebookData = value;
		}
	}
}