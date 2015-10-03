package com.unboxds.ebook.model
{
	import com.serialization.json.JSON;
	import com.unboxds.ebook.constants.EbookConstants;
	import com.unboxds.ebook.constants.ScormConstants;
	import com.unboxds.ebook.model.vo.CustomVO;
	import com.unboxds.ebook.model.vo.EbookVO;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtil;

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

		//-- Ebook State
		private var _version:String;
		private var _status:int;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;
		private var _bookmarks:Array;
		private var _customData:CustomVO;

		//-- EbookVO vars - Scorm Vars
		private var _lessonMode:String;
		private var _lessonStatus:String;
		private var _scoreMax:int;
		private var _scoreMin:int;
		private var _scoreRaw:int;
		private var _sessionTime:String;
		private var _studentId:String;
		private var _studentName:String;
		private var _totalTime:String;

		public function EbookModel()
		{
			_isConsultMode = false;
			_enableAlerts = true;
			_dataServiceType = "SharedObject";
			_isDataServiceAvailable = false;
			_isExtIntAvailable = ExternalInterface.available;
			_scormReplaceDoubleQuotes = false;
			_enableDebugPanel = true;

			//-- STATE VARS
			_version = "";
			_status = EbookConstants.STATUS_NOT_INITIALIZED;
			_quizTries = 0;
			_quizScore = 0;
			_quizStatus = EbookConstants.STATUS_NOT_INITIALIZED;
			_startDate = new Date();
			_endDate = new Date();
			_bookmarks = [];

			//-- Scorm
			_lessonMode = ScormConstants.MODE_NORMAL;
			_lessonStatus = ScormConstants.STATUS_NOT_ATTEMPTED;
			_scoreMax = 100;
			_scoreMin = 0;
			//_scoreRaw = 0;
			_sessionTime = "0000:00:00.00";
			_studentId = "";
			_studentName = "TREINANDO";
			_totalTime = "0000:00:00.00";

			_customData = new CustomVO();
		}

		public function dump():EbookVO
		{
			Logger.log("EbookModel.dump");

			var ebookVO:EbookVO = new EbookVO();
			ebookVO.bookmarks = _bookmarks;
			ebookVO.customData = _customData;
			ebookVO.endDate = _endDate;
			ebookVO.quizScore = _quizScore;
			ebookVO.quizStatus = _quizStatus;
			ebookVO.quizTries = _quizTries;
			ebookVO.startDate = _startDate;
			ebookVO.status = _status;
			ebookVO.version = _version;
			ebookVO.scoreMax = _scoreMax;
			ebookVO.scoreMin = _scoreMin;
			ebookVO.scoreRaw = _scoreRaw;
			ebookVO.sessionTime = _sessionTime;
			ebookVO.lessonMode = _lessonMode;
			ebookVO.lessonStatus = _lessonStatus;
			ebookVO.totalTime = _totalTime;

			return ebookVO;
		}

		public function restore(value:EbookVO):void
		{
			Logger.log("EbookModel.restore > " + value);

			if (value != null)
				ObjectUtil.parse(value, this);
		}

		/*** GETTERS and SETTERS ***/

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
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

		public function get lessonMode():String
		{
			return _lessonMode;
		}

		public function set lessonMode(value:String):void
		{
			_lessonMode = value;
		}

		public function get lessonStatus():String
		{
			return _lessonStatus;
		}

		public function set lessonStatus(value:String):void
		{
			_lessonStatus = value;
		}

		public function get scoreMax():int
		{
			return _scoreMax;
		}

		public function set scoreMax(value:int):void
		{
			_scoreMax = value;
		}

		public function get scoreMin():int
		{
			return _scoreMin;
		}

		public function set scoreMin(value:int):void
		{
			_scoreMin = value;
		}

		public function get scoreRaw():int
		{
			return _scoreRaw;
		}

		public function set scoreRaw(value:int):void
		{
			_scoreRaw = value;
		}

		public function get sessionTime():String
		{
			return _sessionTime;
		}

		public function set sessionTime(value:String):void
		{
			_sessionTime = value;
		}

		public function get studentId():String
		{
			return _studentId;
		}

		public function set studentId(value:String):void
		{
			_studentId = value;
		}

		public function get studentName():String
		{
			return _studentName;
		}

		public function set studentName(value:String):void
		{
			_studentName = value;
		}

		public function get totalTime():String
		{
			return _totalTime;
		}

		public function set totalTime(value:String):void
		{
			_totalTime = value;
		}

		public function get customData():CustomVO
		{
			return _customData;
		}

		public function set customData(value:CustomVO):void
		{
			_customData = value;
		}

		public function get bookmarks():Array
		{
			return _bookmarks;
		}

		public function set bookmarks(value:Array):void
		{
			_bookmarks = value;
		}

		public function toString():String
		{
			var ret:String = com.serialization.json.JSON.serialize(this);
			return ret;
		}
	}
}