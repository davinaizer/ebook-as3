package com.unboxds.ebook.services
{
	import com.pipwerks.SCORM;
	import com.unboxds.ebook.constants.ScormConstants;
	import com.unboxds.ebook.model.vo.EbookVO;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.external.ExternalInterface;

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
		private var _onLoad:Signal;
		private var _onSave:Signal;
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

			_onLoad = new Signal(Object);
			_onSave = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);

			if (ExternalInterface.available)
			{
				scormAPI = new SCORM();
				_isAvailable = _isConnected = scormAPI.connect();

				Logger.log("ScormDataService.isAvailable: " + _isAvailable);
			}
			else
			{
				_onLoadError.dispatch("ScormDataService Load Error. ExternalInterface.available: " + ExternalInterface.available);
			}
		}

		public function load():void
		{
			Logger.log("ScormDataService.load");

			if (_isConnected)
			{
				var data:Object = {};

				//-- store NAVVO, ebook DAta and Custom Data
				var suspendData:String = getParam(ScormConstants.PARAM_SUSPEND_DATA);
				if (suspendData.length > 0)
				{
					Logger.log("ScormDataService.load > Ebook data found, parsing...");

					// replace single quote
					suspendData = suspendData.replace(/'/g, "\"");

					var jsonObj:Object = JSON.parse(suspendData);

					ObjectUtils.copyProps(jsonObj, data);
				} else
				{
					Logger.log("ScormDataService.load > Ebook data not found. First access.");
				}

				//-- SCORM
				data.lessonMode = getParam(ScormConstants.PARAM_LESSON_MODE);
				data.lessonStatus = getParam(ScormConstants.PARAM_LESSON_STATUS);
				data.scoreMax = Number(getParam(ScormConstants.PARAM_SCORE_MAX));
				data.scoreMin = Number(getParam(ScormConstants.PARAM_SCORE_MIN));
				data.scoreRaw = Number(getParam(ScormConstants.PARAM_SCORE_RAW));
				data.studentId = getParam(ScormConstants.PARAM_STUDENT_ID);
				data.studentName = getParam(ScormConstants.PARAM_STUDENT_NAME);
				data.totalTime = getParam(ScormConstants.PARAM_TOTAL_TIME);

				_onLoad.dispatch(data);
			}
			else
			{
				_onLoadError.dispatch("ScormDataService Load Error. ScormDataService.connect: " + _isConnected);
			}
		}

		/**
		 * Update and commit to the LMS the EbookVO
		 */
		public function save(data:EbookVO):void
		{
//			var ebookData:Object = {};

			var suspendData:String = data.toJSON();
			suspendData = suspendData.replace(/"/g, "'");

			setParam(ScormConstants.PARAM_SUSPEND_DATA, suspendData);
			setParam(ScormConstants.PARAM_LESSON_STATUS, data.scormVO.lessonStatus);
			setParam(ScormConstants.PARAM_SCORE_MAX, String(data.scormVO.scoreMax));
			setParam(ScormConstants.PARAM_SCORE_MIN, String(data.scormVO.scoreMin));
			setParam(ScormConstants.PARAM_SCORE_RAW, String(data.scormVO.scoreRaw));
			setParam(ScormConstants.PARAM_SESSION_TIME, data.scormVO.sessionTime);

			var success:Boolean = scormAPI.save();
			if (_isConnected && success)
			{
				_onSave.dispatch();
			}
			else
			{
				_onSaveError.dispatch("ScormDataService Save Error. ScormDataService.connect: " + _isConnected);
			}
		}

		private function setParam(param:String, value:String):Boolean
		{
			var ret:Boolean = scormAPI.set(param, value);

			Logger.log("ScormDataService.setParam > param: " + param + " value: " + value + " saved: " + ret);

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

		public function get onLoad():ISignal
		{
			return _onLoad;
		}

		public function get onSave():ISignal
		{
			return _onSave;
		}

		public function get isAvailable():Boolean
		{
			return _isAvailable;
		}


	}

}