/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.ebook.EbookApi;

	public class NavigationParser extends AbsParser
	{
		private var navActions:Object;

		public function NavigationParser()
		{
		}

		override public function parse():void
		{
			navActions = {};

			var actionCount:int = contentXML.action.length();
			for (var i:int = 0; i < actionCount; i++)
			{
				var type:String = contentXML.action[i].@type;
				var value:String = contentXML.action[i].value;

				navActions[type] = value;

				switch (type)
				{
					case "onBeforeNextPage":
						EbookApi.getInstance().getNavController().onBeforeNextPage = this.onBeforeNextPage;
						break;

					case "onBeforeBackPage":
						EbookApi.getInstance().getNavController().onBeforeBackPage = this.onBeforeBackPage;
						break;
				}
			}
		}

		//-- NAVIGATION FUNCTIONS
		private function onBeforeNextPage():void
		{
			EbookApi.getInstance().getNavController().navigateTo(navActions["onBeforeNextPage"]);
		}

		private function onBeforeBackPage():void
		{
			EbookApi.getInstance().getNavController().navigateTo(navActions["onBeforeBackPage"]);
		}

	}
}
