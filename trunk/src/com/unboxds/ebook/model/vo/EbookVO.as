package com.unboxds.ebook.model.vo
{
	import com.serialization.json.JSON;
	import com.unboxds.utils.ObjectUtil;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookVO implements ISerializable
	{
		private var _version:String;
		private var _status:int;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _quizTries:int;
		private var _quizScore:int;
		private var _quizStatus:int;
		private var _bookmarks:Array;
		private var _activitiesStatus:Array;
		private var _activitiesUserScore:Array;

		private var _navVO:NavVO;
		private var _scormVO:ScormVO;

		public function EbookVO()
		{
			_navVO = new NavVO();
			_scormVO = new ScormVO();
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

		public function get navVO():NavVO
		{
			return _navVO;
		}

		public function set navVO(value:NavVO):void
		{
			_navVO = value;
		}

		public function get scormVO():ScormVO
		{
			return _scormVO;
		}

		public function set scormVO(value:ScormVO):void
		{
			_scormVO = value;
		}

		// -- SERIALIZABLE
		public function toJSON():String
		{
			return com.serialization.json.JSON.serialize(this);
		}

		public function parse(obj:Object):void
		{
			ObjectUtil.copyProps(obj, this);
		}
	}
}