package com.unboxds.ebook.model.vo
{
	import com.unboxds.ebook.constants.ScormConstants;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookData
	{
		//-- SCORM fields 1.2
		private var _lesson_mode:String;
		private var _lesson_status:String;
		private var _scoreMax:int;
		private var _scoreMin:int;
		private var _scoreRaw:int;
		private var _session_time:String;
		private var _student_id:String;
		private var _student_name:String;

		private var _suspend_data:String;

		private var _total_time:String;

		public function EbookData()
		{
			_lesson_mode = ScormConstants.MODE_NORMAL;
			_lesson_status = ScormConstants.STATUS_NOT_ATTEMPTED;
			_scoreMax = 100;
			_scoreMin = 0;
			//_scoreRaw = 0;
			_session_time = "0000:00:00.00";
			_student_id = "";
			_student_name = "TREINANDO";
			_suspend_data = "";
			_total_time = "0000:00:00.00";
		}

		public function get lesson_mode():String
		{
			return _lesson_mode;
		}

		public function set lesson_mode(value:String):void
		{
			if (value != null)
				_lesson_mode = value;
		}

		public function get lesson_status():String
		{
			return _lesson_status;
		}

		public function set lesson_status(value:String):void
		{
			if (value != null)
				_lesson_status = value;
		}

		public function get scoreMax():int
		{
			return _scoreMax;
		}

		public function set scoreMax(value:int):void
		{
			if (!isNaN(value))
				_scoreMax = value;
		}

		public function get scoreMin():int
		{
			return _scoreMin;
		}

		public function set scoreMin(value:int):void
		{
			if (!isNaN(value))
				_scoreMin = value;
		}

		public function get scoreRaw():int
		{
			return _scoreRaw;
		}

		public function set scoreRaw(value:int):void
		{
			if (!isNaN(value))
				_scoreRaw = value;
		}

		public function get session_time():String
		{
			return _session_time;
		}

		public function set session_time(value:String):void
		{
			if (value != null)
				_session_time = value;
		}

		public function get student_id():String
		{
			return _student_id;
		}

		public function set student_id(value:String):void
		{
			if (value != null)
				_student_id = value;
		}

		public function get student_name():String
		{
			return _student_name;
		}

		public function set student_name(value:String):void
		{
			if (value != null)
				_student_name = value;
		}

		public function get suspend_data():String
		{
			return _suspend_data;
		}

		public function set suspend_data(value:String):void
		{
			if (value != null)
				_suspend_data = value;
		}

		public function get total_time():String
		{
			return _total_time;
		}

		public function set total_time(value:String):void
		{
			if (value != null)
				_total_time = value;
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