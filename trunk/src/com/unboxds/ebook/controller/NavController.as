package com.unboxds.ebook.controller
{
	import com.unboxds.ebook.EbookApi;
	import com.unboxds.ebook.model.NavModel;
	import com.unboxds.ebook.model.vo.PageVO;
	import com.unboxds.utils.Logger;

	import org.osflash.signals.Signal;

	public class NavController
	{
		private var model:NavModel;

		private var _onChange:Signal;
		private var _onBeforeNextPage:Function;
		private var _onBeforeBackPage:Function;

		public function NavController()
		{
			Logger.log("NavController.NavController");

			onChange = new Signal(PageVO);
		}

		public function init():void
		{
			Logger.log("NavController.init");

			model = EbookApi.getNavModel();
		}

		public function nextPage():void
		{
			if (_onBeforeNextPage != null)
			{
				_onBeforeNextPage();
			}
			else
			{
				if (model.currentPage < model.pages[model.currentModule].length - 1)
				{
					model.currentPage++;
				}
				else if (model.currentModule < model.pages.length - 1)
				{
					if (model.currentModule == model.maxModule)
						model.maxPage = 0;

					model.currentPage = 0;
					model.currentModule++;
				}

				model.navDirection = 1;

				loadPage();
			}
		}

		public function backPage():void
		{
			if (_onBeforeBackPage != null)
			{
				_onBeforeBackPage();
			}
			else
			{
				if (model.currentPage > 0)
				{
					model.currentPage--;
				}
				else if (model.currentModule > 0)
				{
					model.currentModule--;
					model.currentPage = model.pages[model.currentModule].length - 1;
				}

				model.navDirection = -1;

				loadPage();
			}
		}

		/**
		 * Metodo que deve ser chamado para carregar a pagina que esta indicado
		 * pelo model.currentPage.
		 */
		public function loadPage():void
		{
			if (EbookApi.getEbookModel().isConsultMode == false)
			{
				if (model.currentModule > model.maxModule)
				{
					model.maxModule = model.currentModule;

					if (model.currentPage != model.maxPage)
						model.maxPage = (model.currentPage >= model.pages[model.maxModule].length) ? model.pages[model.maxModule].length - 1 : model.currentPage;
				}

				if (model.currentModule == model.maxModule && model.currentPage > model.maxPage)
					model.maxPage = model.currentPage;
			}

			_onBeforeNextPage = null;
			_onBeforeBackPage = null;

			onChange.dispatch(model.getCurrentPage());
		}

		/**
		 * Sempre que for ter algum evento de navegacao, chamar esse metodo, que
		 * alem de navegar para a pagina desejada, também atualiza o index para
		 * correção da navegacao linear.
		 * @param    pg - nome da pagina para onde irá se navegar.
		 */
		public function navigateTo(pg:String):void
		{
			var page:PageVO = model.getPageByName(pg);
			navigateToPageIndex(page.index);
		}

		/**
		 * Navega para uma página em especifica, determinada por modulo e pagina.
		 * @param    module - numero do modulo a ser navegado.
		 * @param    page - numero da pagina a ser navegada.
		 */
		public function navigateToIndex(module:int, page:int):void
		{
			model.navDirection = -1;

			if (module > model.currentModule)
			{
				model.navDirection = 1;
			}
			else if (module == model.currentModule && model.currentPage < page)
			{
				model.navDirection = 1;
			}

			model.currentPage = page;
			model.currentModule = module;

			loadPage();
		}

		/**
		 * Navega para uma página em especifico, determinada pelo indice da pagina.
		 * @param    index  numero da pagina a ser navegada.
		 */
		public function navigateToPageIndex(index:int):void
		{
			if (model.pageQueue[index])
				var page:PageVO = model.pageQueue[index] as PageVO;
			else
				return;

			model.navDirection = -1;

			if (page.moduleIndex > model.currentModule)
			{
				model.navDirection = 1;
			}
			else if (page.moduleIndex == model.currentModule && model.currentPage < page.localIndex)
			{
				model.navDirection = 1;
			}

			model.currentPage = page.localIndex;
			model.currentModule = page.moduleIndex;

			loadPage();
		}

		public function get onBeforeNextPage():Function
		{
			return _onBeforeNextPage;
		}

		public function set onBeforeNextPage(value:Function):void
		{
			_onBeforeNextPage = value;
		}

		public function get onBeforeBackPage():Function
		{
			return _onBeforeBackPage;
		}

		public function set onBeforeBackPage(value:Function):void
		{
			_onBeforeBackPage = value;
		}

		public function get onChange():Signal
		{
			return _onChange;
		}

		public function set onChange(value:Signal):void
		{
			_onChange = value;
		}

	}

}