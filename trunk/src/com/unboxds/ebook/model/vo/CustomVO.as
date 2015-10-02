package com.unboxds.ebook.model.vo
{
	import com.serialization.json.JSON;

	/**
	 * ...
	 * @author Davi Naizer
	 * @version 0.1
	 */
	public class CustomVO
	{
		private var _maxPoints:Array;
		private var _userPoints:Array;
		private var _lessonStatus:Array;
		private var _bookmarks:Array;

		public function CustomVO()
		{
			_maxPoints = [0];
			_userPoints = [-1];
			_lessonStatus = [0];
			//TODO put bookmarks inside EbookVO
			_bookmarks = [];
		}

		/* ----------- GETTERS SETTERS ----------- */
		public function setLessonStatus(lessonId:int, status:int):void
		{
			_lessonStatus[lessonId] = status;
		}

		public function getLessonStatus(lessonId:int):int
		{
			return parseInt(_lessonStatus[lessonId]);
		}

		public function setPoints(value:int, index:int):void
		{
			userPoints[index] = value;
		}

		public function getPoints(index:int):int
		{
			return userPoints[index];
		}

		public function getTotalPoints():int
		{
			var total:int = 0;
			for (var i:int = 0; i < userPoints.length; i++)
			{
				if (userPoints[i] > 0)
					total += userPoints[i];
			}
			return total;
		}

		public function getTotalMaxPoints():int
		{
			var total:int = 0;
			for (var i:int = 0; i < maxPoints.length; i++)
			{
				total += maxPoints[i];
			}
			return total;
		}

		public function getGrade():int
		{
			var grade:int = 100 * getTotalPoints() / getTotalMaxPoints();
			// grade = AvalUtils.roundGrade(grade);

			return grade;
		}

		public function isTestDone(index:int):Boolean
		{
			return userPoints[index] > -1;
		}

		public function get maxPoints():Array
		{
			return _maxPoints;
		}

		public function set maxPoints(value:Array):void
		{
			_maxPoints = value;
		}

		public function get userPoints():Array
		{
			return _userPoints;
		}

		public function set userPoints(value:Array):void
		{
			_userPoints = value;
		}

		public function get lessonStatus():Array
		{
			return _lessonStatus;
		}

		public function set lessonStatus(value:Array):void
		{
			_lessonStatus = value;
		}

		public function get bookmarks():Array
		{
			return _bookmarks;
		}

		public function set bookmarks(value:Array):void
		{
			_bookmarks = value;
		}

		/* ----------- REQUIRED ----------- */
		public function parseData(data:String):CustomVO
		{
			var retObj:Object = com.serialization.json.JSON.deserialize(data);

			for (var i:String in retObj)
				if (this.hasOwnProperty(i))
					this[i] = retObj[i];

			return this;
		}

		public function toString():String
		{
			var ret:String = com.serialization.json.JSON.serialize(this);
			return ret;
		}
	}
}