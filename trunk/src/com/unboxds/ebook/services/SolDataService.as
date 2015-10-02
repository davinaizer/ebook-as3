package com.unboxds.ebook.services
{
	import com.unboxds.ebook.model.vo.EbookVO;
	import com.unboxds.utils.Logger;

	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;

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
			Logger.log("SolDataService.SolDataService");

			sol = SharedObject.getLocal("UNBOX_eBookAS_V3");

			_isAvailable = true;
			_onLoad = new Signal(EbookVO);
			_onSave = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);
		}

		public function load():void
		{
			var ebookVO:EbookVO = new EbookVO();

			if (sol.data.ebookVO != null)
			{
				Logger.log("SolDataService.load >> Ebook Data found!");

				var dataObj:Object = sol.data.ebookVO;
				parseObject(dataObj, ebookVO);
			}
			else
			{
				Logger.log("SolDataService.load >> NO Data found! Creating New.");
			}

			_onLoad.dispatch(ebookVO);
		}

		private function parseObject(obj:Object, targetObj:Object):void
		{
			for (var param:String in obj)
			{
				if (targetObj.hasOwnProperty(param))
				{
					var classType:String = getQualifiedClassName(obj[param]);
					if (classType == "Object")
					{
						parseObject(obj[param], targetObj[param])
					}
					else
					{
						targetObj[param] = obj[param];
						Logger.log("SolDataService.parseObject >> " + param + " : " + ( (targetObj[param])));
					}
				}
			}
		}

		/**
		 * Update and commit to the LMS the EbookVO
		 */
		public function save(data:EbookVO):void
		{
			Logger.log("SolDataService.save > data :" + data);

			for (var i:String in data)
				Logger.log("SolDataService.save >> " + i + " > value : " + data[i]);

			sol.data.ebookVO = data;
			sol.flush();
			sol.close();

			_onSave.dispatch();
		}

		public function get isAvailable():Boolean
		{
			return _isAvailable;
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