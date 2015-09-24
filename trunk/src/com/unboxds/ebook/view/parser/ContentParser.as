package com.unboxds.ebook.view.parser
{
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;

	/**
	 * Helper class to build the content read from a XML
	 * <p>To be parsed the content must use "content" tag and the attribute "type" must be set accordingly.</p>
	 * <p>The Content Parser accepts some predefined content types to help you creating the page content.</p>
	 * <p>Accepted types are: text, link, tooltip, simplebutton and image.</p>
	 * <p>For convenience, please use ContentType class to access these constants when used manually inside a class.</p>
	 * <p>Every content type accepts different parameters. To know these differences, see the examples below.</p>
	 * <p>Examples of usage:</p>
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 *
	 */
	public class ContentParser extends AbsParser
	{
		public function ContentParser(target:DisplayObjectContainer, contentXML:XML, stylesheet:StyleSheet = null)
		{
			this.target = target;
			this.contentXML = contentXML;
			this.stylesheet = stylesheet;
		}

		override public function parse():void
		{
			var typeCount:int = contentXML.content.length();
			for (var i:int = 0; i < typeCount; i++)
			{
				var type:String = contentXML.content[i].@type;
				var cXML:XML = contentXML.content[i];

				var parser:AbsParser = ParserFactory.getParser(type);
				if (parser != null)
				{
					parser.target = target;
					parser.contentXML = cXML;
					parser.stylesheet = stylesheet;
					parser.parse();
				}
			}
		}
	}
}