package com.unboxds.ebook.model
{
	import com.unboxds.utils.NumberUtils;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class SessionTimer
	{
		private static var startTime:Number;
		private static var endTime:Number;
		private static var sessionTime:Number;
		private static var d:Date;
		
		public function SessionTimer()
		{
		}
		
		public function initSession():void
		{
			d = new Date();
			startTime = d.getTime();
		}
		
		/**
		 * Return session time in seconds
		 */
		public function getSessionTime():Number
		{
			d = new Date();
			sessionTime = (d.getTime() - startTime) / 1000;
			
			return sessionTime;
		}
		
		/**
		 * Return Session time in CMITimespan format: "hh:mm:ss.ss"
		 */
		public function getCMISessionTime():String
		{
			return secondsToCMITime(getSessionTime());
		}
		
		public function secondsToCMITime(seconds:Number):String
		{
			var hr:Number = int(seconds / 3600);
			var min:Number = int(seconds / 60) - (hr * 60);
			var sec:Number = NumberUtils.fmtNumDec(seconds % 60, 2);
			var cmiTime:String = NumberUtils.fixPadding(hr, 4) + ":" + NumberUtils.fixPadding(min, 2) + ":" + NumberUtils.fixPadding(sec, 2);
			
			return cmiTime;
		}
		
		public function cmiTimeToSeconds(cmiTime:String):Number
		{
			var timeArr:Array = cmiTime.split(":");
			var seconds:Number = 0;
			
			for (var i:Number = 0; i < timeArr.length; i++)
			{
				var time:Number = parseFloat(timeArr[i]);
				seconds += time * Math.pow(60, timeArr.length - 1 - i);
			}
			
			return seconds;
		}
	
	}

}