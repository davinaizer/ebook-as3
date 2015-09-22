package com.unboxds.ebook.services
{
	import com.pipwerks.SCORM;
	import com.unboxds.ebook.model.vo.ScormData;
	import com.unboxds.ebook.model.vo.ScormParams;
	import com.unboxds.utils.Logger;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class ScormDataService implements IEbookDataService
	{
		private static var _isConnected:Boolean;
		
		private var scormAPI:SCORM;
		
		// Interface methods
		private var _isAvailable:Boolean;
		private var _onLoaded:Signal;
		private var _onSaved:Signal;
		private var _onLoadError:Signal;
		private var _onSaveError:Signal;
		
		public function ScormDataService()
		{
			Logger.log("ScormDataService.ScormDataService");
			
			init();
		}
		
		private function init():void
		{
			Logger.log("ScormDataService.init");
			
			scormAPI = new SCORM();
			_isAvailable = _isConnected = scormAPI.connect();
			
			Logger.log("ScormDataService.isAvailable: " + _isAvailable);
			
			_onLoaded = new Signal(ScormData);
			_onSaved = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);
		}
		
		public function get isAvailable():Boolean
		{
			return _isAvailable;
		}
		
		public function load():void
		{
			Logger.log("ScormDataService.load");
			
			if (_isConnected)
			{
				var ebookData:ScormData = new ScormData();
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
				
				_onLoaded.dispatch(ebookData);
			}
			else
			{
				_onLoadError.dispatch("ScormDataService Load Error. ScormDataService.connect: " + _isConnected);
			}
		}
		
		/**
		 * Update and commit to the LMS the EbookData
		 */
		public function save(data:ScormData):void
		{
			update(data);
			
			var success:Boolean = scormAPI.save();
			if (_isConnected && success)
			{
				_onSaved.dispatch();
			}
			else
			{
				_onSaveError.dispatch("ScormDataService Save Error. ScormDataService.connect: " + _isConnected);
			}
		}
		
		/**
		 * Update without commiting to the LMS
		 */
		private function update(data:ScormData):void
		{
			//success = scorm.set(PARAM_COMMENTS, scormVO.comments);
			setParam(ScormParams.PARAM_EXIT, data.exit);
			setParam(ScormParams.PARAM_LESSON_LOCATION, data.lesson_location);
			setParam(ScormParams.PARAM_LESSON_STATUS, data.lesson_status);
			setParam(ScormParams.PARAM_SCORE_MAX, String(data.scoreMax));
			setParam(ScormParams.PARAM_SCORE_MIN, String(data.scoreMin));
			setParam(ScormParams.PARAM_SCORE_RAW, String(data.scoreRaw));
			setParam(ScormParams.PARAM_SESSION_TIME, data.session_time);
			setParam(ScormParams.PARAM_SUSPEND_DATA, data.suspend_data);
		}
		
		private function setParam(param:String, value:String):Boolean
		{
			var ret:Boolean = scormAPI.set(param, value);
			
			Logger.log("ScormDataService.setParam> param: " + param + " value: " + value + " saved: " + ret);
			
			return ret;
		}
		
		private function getParam(param:String):String
		{
			var ret:String = scormAPI.get(param);
			
			Logger.log("ScormDataService.getParam > param: " + param + " ret: " + ret);
			
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
		
		public function get onLoaded():ISignal
		{
			return _onLoaded;
		}
		
		public function get onSaved():ISignal
		{
			return _onSaved;
		}

	}

}