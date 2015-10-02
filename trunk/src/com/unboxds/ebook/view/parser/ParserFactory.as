/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.ebook.constants.ContentType;

	public class ParserFactory
	{
		public function ParserFactory()
		{
		}

		static public function getParser(parserType:String):AbsParser
		{
			switch (parserType)
			{
				case ContentType.TEXTFIELD:
					return new TextFieldParser();
					break;

				case ContentType.LINK:
					return new LinkParser();
					break;

				case ContentType.TOOLTIP:
					return new TooltipParser();
					break;

				case ContentType.SIMPLEBUTTON:
					return new SimpleButtonParser();
					break;

				case ContentType.IMAGE:
					return new ImageParser();
					break;

				case ContentType.NAVIGATION:
					return new NavigationParser();
					break;

				case ContentType.VARIABLES:
					return new VariablesParser();
					break;
			}

			return null;
		}
	}
}
