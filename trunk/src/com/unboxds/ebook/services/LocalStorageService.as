package com.unboxds.ebook.services
{
	import com.adobe.serialization.json.JSON;
	import com.unboxds.ebook.model.vo.EbookDTO;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.net.SharedObject;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class LocalStorageService implements IEbookDataService
	{
		private var sol:SharedObject;

		// Interface methods
		private var _isAvailable:Boolean;
		private var _onLoad:Signal;
		private var _onSave:Signal;
		private var _onLoadError:Signal;
		private var _onSaveError:Signal;

		public function LocalStorageService()
		{
			Logger.log("LocalStorageService.LocalStorageService");

			sol = SharedObject.getLocal("UNBOX_eBookAS_V3");

			_isAvailable = true;
			_onLoad = new Signal(EbookDTO);
			_onSave = new Signal();
			_onLoadError = new Signal(String);
			_onSaveError = new Signal(String);
		}

		public function load():void
		{
			var ebookDTO:EbookDTO = new EbookDTO();

			if (sol.data.ebookDTO != null)
			{
				Logger.log("LocalStorageService.load >> Ebook Data found!");

				var jsonObj:Object = com.adobe.serialization.json.JSON.decode(sol.data.ebookDTO);

				ObjectUtils.copyProps(jsonObj.navVO, ebookDTO.navVO);
				ObjectUtils.copyProps(jsonObj.scormVO, ebookDTO.scormVO);
				ObjectUtils.copyProps(jsonObj.statusVO, ebookDTO.statusVO);
			}
			else
			{
				Logger.log("LocalStorageService.load >> NO Data found! Creating New.");
			}

			_onLoad.dispatch(ebookDTO);
		}

		public function save(data:EbookDTO):void
		{
			Logger.log("LocalStorageService.save");

			sol.data.ebookDTO = com.adobe.serialization.json.JSON.encode(data);
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