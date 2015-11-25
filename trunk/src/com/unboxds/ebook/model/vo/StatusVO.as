/**
 * Created by Naizer on 24/11/2015.
 */
package com.unboxds.ebook.model.vo
{
	import com.unboxds.ebook.constants.EbookConstants;

	public class StatusVO
	{
		private var _version:String;
		private var _status:int;
		private var _startDate:String;
		private var _endDate:String;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;
		private var _bookmarks:Array;
		private var _activitiesStatus:Array;
		private var _activitiesUserScore:Array;

		public function StatusVO()
		{
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

		public function get startDate():String
		{
			return _startDate;
		}

		public function set startDate(value:String):void
		{
			_startDate = value;
		}

		public function get endDate():String
		{
			return _endDate;
		}

		public function set endDate(value:String):void
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

		public function get activitiesStatus():Array
		{
			return _activitiesStatus;
		}

		public function set activitiesStatus(value:Array):void
		{
			_activitiesStatus = value;
		}

		public function get activitiesUserScore():Array
		{
			return _activitiesUserScore;
		}

		public function set activitiesUserScore(value:Array):void
		{
			_activitiesUserScore = value;
		}
	}
}
