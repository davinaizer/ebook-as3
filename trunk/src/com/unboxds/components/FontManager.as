package com.unboxds.components
{
	import com.unboxds.utils.Logger;

	import flash.display.MovieClip;
	import flash.text.Font;

	/**
	 * ...
	 * @author Davi Naizer
	 */
	public class FontManager extends MovieClip
	{
		// UNICODE RANGE REFERENCE
		/*
		 Default ranges
		 U+0020-U+0040, // Punctuation, Numbers
		 U+0041-U+005A, // Upper-Case A-Z
		 U+005B-U+0060, // Punctuation and Symbols
		 U+0061-U+007A, // Lower-Case a-z
		 U+007B-U+007E, // Punctuation and Symbols

		 Extended ranges (if multi-lingual required)
		 U+0080-U+00FF, // Latin I
		 U+0100-U+017F, // Latin Extended A
		 U+0400-U+04FF, // Cyrillic
		 U+0370-U+03FF, // Greek
		 U+1E00-U+1EFF, // Latin Extended Additional
		 */
		
		[Embed(source="../../../../lib/fonts/Roboto-Light.ttf",
				fontFamily="Roboto",
				fontName="Roboto Light",
				fontWeight="normal",
				fontStyle="normal",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var RobotoLight:Class;

		[Embed(source="../../../../lib/fonts/Roboto-LightItalic.ttf",
				fontFamily="Roboto",
				fontName="Roboto Light",
				fontWeight="normal",
				fontStyle="italic",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var RobotoLightItalic:Class;

		[Embed(source="../../../../lib/fonts/Roboto-Regular.ttf",
				fontFamily="Roboto",
				fontName="Roboto",
				fontWeight="normal",
				fontStyle="normal",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var Roboto:Class;

		[Embed(source="../../../../lib/fonts/Roboto-Italic.ttf",
				fontFamily="Roboto",
				fontName="Roboto",
				fontWeight="normal",
				fontStyle="italic",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var RobotoItalic:Class;

		[Embed(source="../../../../lib/fonts/Roboto-Bold.ttf",
				fontFamily="Roboto",
				fontName="Roboto",
				fontWeight="bold",
				fontStyle="normal",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var RobotoBold:Class;

		[Embed(source="../../../../lib/fonts/Roboto-BoldItalic.ttf",
				fontFamily="Roboto",
				fontName="Roboto",
				fontWeight="bold",
				fontStyle="italic",
				mimeType="application/x-font-truetype",
				embedAsCFF="false",
				unicodeRange="U+0020-U+007E,U+0080-U+00FF,U+2019-U+2022")]
		private static var RobotoBoldItalic:Class;

		public function FontManager()
		{
			embedFonts();
		}
		
		public static function embedFonts():void
		{
			Logger.log("FontManager.embedFonts");

			Font.registerFont(Roboto);
			Font.registerFont(RobotoBold);
			Font.registerFont(RobotoBoldItalic);
			Font.registerFont(RobotoItalic);
			Font.registerFont(RobotoLight);
			Font.registerFont(RobotoLightItalic);

			var fonts:Array = Font.enumerateFonts();
			for each(var font:Font in fonts)
				Logger.log("FontManager.embedFonts >> registerFont > " + font.fontName + ":" + font.fontStyle);
		}

	}

}