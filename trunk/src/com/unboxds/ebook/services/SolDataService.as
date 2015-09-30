package com.unboxds.ebook.services
{
	import com.unboxds.ebook.model.vo.ScormData;
	import com.unboxds.ebook.model.vo.ScormParams;
	import com.unboxds.utils.Logger;

	import flash.net.SharedObject;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class SolDataService implements IEbookDataService
	{
		private var sol:SharedObject;
		
		// Interface methods
		private var _isAvailable:Boolean;
		private var _onLoad:Signal;
		private var _onSave:Signal;
		private var _onLoadError:Signal;
		private var _onSaveError:Signal;
		
		public function SolDataService()
		{
			init();
		}
		
		private function init():void
		{
			Logger.log("SolDataService.init");
			
			sol = SharedObject.getLocal("EbookSolData");
			
			_isAvailable = true;
			_onLoad = new Signal(ScormData);
			_onSave = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);
		}
		
		/* INTERFACE com.unboxds.ebook.model.IEbookDataService */
		
		public function load():void
		{
			Logger.log("SolDataService.load");
			
			var ebookData:ScormData = new ScormData();
			
			// check if first time creating data
			if (getParam(ScormParams.PARAM_SUSPEND_DATA) != null)
			{
				ebookData.comments = getParam(ScormParams.PARAM_COMMENTS);
				ebookData.credit = getParam(ScormParams.PARAM_CREDIT);
				ebookData.entry = getParam(ScormParams.PARAM_ENTRY);
				ebookData.launch_data = getParam(ScormParams.PARAM_LAUNCHA_DATA);
				ebookData.lesson_location = getParam(ScormParams.PARAM_LESSON_LOCATION);
				ebookData.lesson_mode = getParam(ScormParams.PARAM_LESSON_MODE);
				ebookData.lesson_status = getParam(ScormParams.PARAM_LESSON_STATUS);
				ebookData.scoreMax = Number(getParam(ScormParams.PARAM_SCORE_MAX));
				ebookData.scoreMin = Number(getParam(ScormParams.PARAM_SCORE_MIN));
				ebookData.scoreRaw = Number(getParam(ScormParams.PARAM_SCORE_RAW));
				ebookData.student_id = getParam(ScormParams.PARAM_STUDENT_ID);
				ebookData.student_name = getParam(ScormParams.PARAM_STUDENT_NAME);
				ebookData.suspend_data = getParam(ScormParams.PARAM_SUSPEND_DATA);
				ebookData.total_time = getParam(ScormParams.PARAM_TOTAL_TIME);
			}
			
			_onLoad.dispatch(ebookData);
		}
		
		/**
		 * Update and commit to the LMS the EbookData
		 */
		public function save(data:ScormData):void
		{
			update(data);
			
			sol.flush();
			sol.close();
			
			_onSave.dispatch();
		}
		
		/* INTERFACE com.unboxds.ebook.services.IEbookDataService */
		
		public function get isAvailable():Boolean
		{
			return _isAvailable;
		}
		
		/**
		 * Update without commiting to the LMS
		 */
		private function update(data:ScormData):void
		{
			setParam(ScormParams.PARAM_EXIT, data.exit);
			setParam(ScormParams.PARAM_LESSON_LOCATION, data.lesson_location);
			setParam(ScormParams.PARAM_LESSON_STATUS, data.lesson_status);
			setParam(ScormParams.PARAM_SCORE_MAX, String(data.scoreMax));
			setParam(ScormParams.PARAM_SCORE_MIN, String(data.scoreMin));
			setParam(ScormParams.PARAM_SCORE_RAW, String(data.scoreRaw));
			setParam(ScormParams.PARAM_SESSION_TIME, data.session_time);
			setParam(ScormParams.PARAM_SUSPEND_DATA, data.suspend_data);
		}
		
		private function setParam(param:String, value:String):void
		{
			Logger.log("SolDataService.setParam > param : " + param + ", value : " + value);
			
			sol.data[param] = value;
		}
		
		private function getParam(param:String):String
		{
			var ret:String = sol.data[param];
			
			Logger.log("SolDataService.getParam > param: " + param + " ret: " + ret);
			
			return ret;
		}
		
		public function get onLoadError():ISignal
		{
			return _onLoadError;
		}
		
		public function get onSaveError():ISignal
		{
			return _onSaveError;
		}
		
		public function get onLoad():ISignal
		{
			return _onLoad;
		}
		
		public function get onSave():ISignal
		{
			return _onSave;
		}

	}

}