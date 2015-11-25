package com.unboxds.ebook.model.vo
{
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookDTO
	{
		private var _statusVO:StatusVO;
		private var _scormVO:ScormVO;
		private var _navVO:NavVO;

		public function EbookDTO()
		{
			_statusVO = new StatusVO();
			_scormVO = new ScormVO();
			_navVO = new NavVO();
		}

		public function get statusVO():StatusVO
		{
			return _statusVO;
		}

		public function set statusVO(value:StatusVO):void
		{
			_statusVO = value;
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
	}
}