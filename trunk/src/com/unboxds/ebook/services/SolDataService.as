package com.unboxds.ebook.services
{
	import com.unboxds.ebook.constants.ScormConstants;
	import com.unboxds.ebook.model.vo.EbookData;
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
			_onLoad = new Signal(EbookData);
			_onSave = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);
		}

		/* INTERFACE com.unboxds.ebook.model.IEbookDataService */

		public function load():void
		{
			Logger.log("SolDataService.load");

			var ebookData:EbookData = new EbookData();

			// check if first time creating data
			if (getParam(ScormConstants.PARAM_SUSPEND_DATA) != null)
			{
				ebookData.lesson_mode = getParam(ScormConstants.PARAM_LESSON_MODE);
				ebookData.lesson_status = getParam(ScormConstants.PARAM_LESSON_STATUS);
				ebookData.scoreMax = Number(getParam(ScormConstants.PARAM_SCORE_MAX));
				ebookData.scoreMin = Number(getParam(ScormConstants.PARAM_SCORE_MIN));
				ebookData.scoreRaw = Number(getParam(ScormConstants.PARAM_SCORE_RAW));
				ebookData.student_id = getParam(ScormConstants.PARAM_STUDENT_ID);
				ebookData.student_name = getParam(ScormConstants.PARAM_STUDENT_NAME);
				ebookData.suspend_data = getParam(ScormConstants.PARAM_SUSPEND_DATA);
				ebookData.total_time = getParam(ScormConstants.PARAM_TOTAL_TIME);
			}

			_onLoad.dispatch(ebookData);
		}

		/**
		 * Update and commit to the LMS the EbookData
		 */
		public function save(data:EbookData):void
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
		private function update(data:EbookData):void
		{
			setParam(ScormConstants.PARAM_EXIT, data.exit);
			setParam(ScormConstants.PARAM_LESSON_STATUS, data.lesson_status);
			setParam(ScormConstants.PARAM_SCORE_MAX, String(data.scoreMax));
			setParam(ScormConstants.PARAM_SCORE_MIN, String(data.scoreMin));
			setParam(ScormConstants.PARAM_SCORE_RAW, String(data.scoreRaw));
			setParam(ScormConstants.PARAM_SESSION_TIME, data.session_time);
			setParam(ScormConstants.PARAM_SUSPEND_DATA, data.suspend_data);
		}

		private function setParam(param:String, value:String):void
		{
			Logger.log("SolDataService.setParam > param : " + param + " > value : " + value);

			sol.data[param] = value;
		}

		private function getParam(param:String):String
		{
			var ret:String = sol.data[param];

			Logger.log("SolDataService.getParam > param: " + param + " > ret: " + ret);

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