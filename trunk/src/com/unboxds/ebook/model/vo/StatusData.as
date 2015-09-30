package com.unboxds.ebook.model.vo
{
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class StatusData
	{
		//-- STATUS CONSTANTS
		public static const STATUS_NOT_INITIALIZED:int = 0;
		public static const STATUS_INITIALIZED:int = 1;
		public static const STATUS_COMPLETED:int = 2;
		
		private static const DELIMITER:String = "|";
		private static const SUBDELIMITER:String = ",";
		
		//-- ebook version
		private var _status:int;
		private var _maxPage:int;
		private var _maxModule:int;
		private var _currentPage:int;
		private var _currentModule:int;
		private var _currentLesson:int;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;
		private var _lessonStatus:CustomData;
		private var _startDate:Date;
		private var _endDate:Date;
		
		public function StatusData()
		{
			_status = STATUS_NOT_INITIALIZED;
			_maxPage = 0;
			_maxModule = 0;
			_currentPage = 0;
			_currentModule = 0;
			_currentLesson = 0;
			_quizTries = 0;
			_quizScore = 0;
			_quizStatus = STATUS_NOT_INITIALIZED;
			_lessonStatus = new CustomData();
			_startDate = new Date();
			_endDate = new Date();
		}
		
		/*** GETTERS and SETTERS ***/
		public function get maxPage():int
		{
			return _maxPage;
		}
		
		public function set maxPage(maxPage:int):void
		{
			_maxPage = maxPage;
		}
		
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		public function set currentPage(currentPage:int):void
		{
			_currentPage = currentPage;
		}
		
		public function get currentModule():int
		{
			return _currentModule;
		}
		
		public function set currentModule(currentModule:int):void
		{
			_currentModule = currentModule;
		}
		
		public function get currentLesson():int
		{
			return _currentLesson;
		}
		
		public function set currentLesson(currentLesson:int):void
		{
			_currentLesson = currentLesson;
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
		
		public function get maxModule():int
		{
			return _maxModule;
		}
		
		public function set maxModule(value:int):void
		{
			_maxModule = value;
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

	}
}

