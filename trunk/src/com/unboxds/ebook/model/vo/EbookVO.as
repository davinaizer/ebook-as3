package com.unboxds.ebook.model.vo
{
	import com.serialization.json.JSON;
	import com.unboxds.ebook.constants.EbookConstants;
	import com.unboxds.utils.ObjectUtil;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookVO
	{
		//-- Ebook State -- Store inside SuspendData
		private var _version:String;
		private var _status:int;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;
		private var _bookmarks:Array;

		private var _navVO:NavVO;
		private var _scormVO:ScormVO;
		private var _customData:CustomVO;

		public function EbookVO()
		{
			//-- STATE VARS
			_version = "";
			_status = EbookConstants.STATUS_NOT_INITIALIZED;
			_quizTries = 0;
			_quizScore = 0;
			_quizStatus = EbookConstants.STATUS_NOT_INITIALIZED;
			_startDate = new Date();
			_endDate = new Date();
			_bookmarks = [];

			//- sub classes containing info
			_navVO = new NavVO();
			_scormVO = new ScormVO();
			_customData = new CustomVO();
		}


		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			_status = value;
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

		public function get quizTries():int
		{
			return _quizTries;
		}

		public function set quizTries(value:int):void
		{
			_quizTries = value;
		}

		public function get quizScore():int
		{
			return _quizScore;
		}

		public function set quizScore(value:int):void
		{
			_quizScore = value;
		}

		public function get quizStatus():int
		{
			return _quizStatus;
		}

		public function set quizStatus(value:int):void
		{
			_quizStatus = value;
		}

		public function get bookmarks():Array
		{
			return _bookmarks;
		}

		public function set bookmarks(value:Array):void
		{
			_bookmarks = value;
		}

		public function get navVO():NavVO
		{
			return _navVO;
		}

		public function set navVO(value:NavVO):void
		{
			_navVO = value;
		}

		public function get lessonMode():String
		{
			return _scormVO.lessonMode;
		}

		public function set lessonMode(value:String):void
		{
			_scormVO.lessonMode = value;
		}

		public function get lessonStatus():String
		{
			return _scormVO.lessonStatus;
		}

		public function set lessonStatus(value:String):void
		{
			_scormVO.lessonStatus = value;
		}

		public function get scoreMax():int
		{
			return _scormVO.scoreMax;
		}

		public function set scoreMax(value:int):void
		{
			_scormVO.scoreMax = value;
		}

		public function get scoreMin():int
		{
			return _scormVO.scoreMin;
		}

		public function set scoreMin(value:int):void
		{
			_scormVO.scoreMin = value;
		}

		public function get scoreRaw():int
		{
			return _scormVO.scoreRaw;
		}

		public function set scoreRaw(value:int):void
		{
			_scormVO.scoreRaw = value;
		}

		public function get sessionTime():String
		{
			return _scormVO.sessionTime;
		}

		public function set sessionTime(value:String):void
		{
			_scormVO.sessionTime = value;
		}

		public function get totalTime():String
		{
			return _scormVO.totalTime;
		}

		public function set totalTime(value:String):void
		{
			_scormVO.totalTime = value;
		}

		public function get studentId():String
		{
			return _scormVO.studentId;
		}

		public function set studentId(value:String):void
		{
			_scormVO.studentId = value;
		}

		public function get studentName():String
		{
			return _scormVO.studentName;
		}

		public function set studentName(value:String):void
		{
			_scormVO.studentName = value;
		}

		public function get suspendData():String
		{
			return _scormVO.suspendData;
		}

		public function set suspendData(value:String):void
		{
			_scormVO.suspendData = value;
		}

		public function get customData():CustomVO
		{
			return _customData;
		}

		public function set customData(value:CustomVO):void
		{
			_customData = value;
		}

		public function toString():String
		{
			var ret:String = ObjectUtil.toString(this);
			return ret;
		}
	}
}