package com.unboxds.ebook.model.vo
{
	import com.unboxds.ebook.constants.EbookConstants;

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

			//- sub classes containing info
			_navVO = new NavVO();
			_scormVO = new ScormVO();
			_customData = new CustomVO();
		}

		public function get lessonMode():String
		{
			return _scormVO.lessonMode;
		}

		public function set lessonMode(value:String):void
		{
			if (value != null)
				_scormVO.lessonMode = value;
		}

		public function get lessonStatus():String
		{
			return _scormVO.lessonStatus;
		}

		public function set lessonStatus(value:String):void
		{
			if (value != null)
				_scormVO.lessonStatus = value;
		}

		public function get scoreMax():int
		{
			return _scormVO.scoreMax;
		}

		public function set scoreMax(value:int):void
		{
			if (!isNaN(value))
				_scormVO.scoreMax = value;
		}

		public function get scoreMin():int
		{
			return _scormVO.scoreMin;
		}

		public function set scoreMin(value:int):void
		{
			if (!isNaN(value))
				_scormVO.scoreMin = value;
		}

		public function get scoreRaw():int
		{
			return _scormVO.scoreRaw;
		}

		public function set scoreRaw(value:int):void
		{
			if (!isNaN(value))
				_scormVO.scoreRaw = value;
		}

		public function get sessionTime():String
		{
			return _scormVO.sessionTime;
		}

		public function set sessionTime(value:String):void
		{
			if (value != null)
				_scormVO.sessionTime = value;
		}

		public function get studentId():String
		{
			return _scormVO.studentId;
		}

		public function set studentId(value:String):void
		{
			if (value != null)
				_scormVO.studentId = value;
		}

		public function get studentName():String
		{
			return _scormVO.studentName;
		}

		public function set studentName(value:String):void
		{
			if (value != null)
				_scormVO.studentName = value;
		}

		public function get totalTime():String
		{
			return _scormVO.totalTime;
		}

		public function set totalTime(value:String):void
		{
			if (value != null)
				_scormVO.totalTime = value;
		}

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			if (value != null)
				_version = value;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			if (!isNaN(value))
				_status = value;
		}

		public function get startDate():Date
		{
			return _startDate;
		}

		public function set startDate(value:Date):void
		{
			if (value != null)
				_startDate = value;
		}

		public function get endDate():Date
		{
			return _endDate;
		}

		public function set endDate(value:Date):void
		{
			if (value != null)
				_endDate = value;
		}

		public function get quizTries():int
		{
			return _quizTries;
		}

		public function set quizTries(value:int):void
		{
			if (!isNaN(value))
				_quizTries = value;
		}

		public function get quizScore():int
		{
			return _quizScore;
		}

		public function set quizScore(value:int):void
		{
			if (!isNaN(value))
				_quizScore = value;
		}

		public function get quizStatus():int
		{
			return _quizStatus;
		}

		public function set quizStatus(value:int):void
		{
			if (!isNaN(value))
				_quizStatus = value;
		}

		public function get navVO():NavVO
		{
			return _navVO;
		}

		public function set navVO(value:NavVO):void
		{
			_navVO = value;
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
			var str:String = "";
			for (var i:String in this)
				str += "	- key : " + i + ", value : " + this[i] + "/n";
			return str;
		}
	}
}