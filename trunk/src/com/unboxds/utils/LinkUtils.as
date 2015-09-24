/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	//TODO Relocate this class -> as3_unboxLib
	public class LinkUtils
	{
		public function LinkUtils()
		{
		}

		static public function openLink(urlStr:String, params:String = "_blank"):void
		{
			var linkType:String = urlStr.split("://")[0];
			switch (linkType)
			{
				case "http":
				case "https":
				case "ftp":
					break;

				case "file":
					urlStr = urlStr.split("file://")[1];
					break;

				case "tooltip":
					break;
				default:
					break;
			}

			var url:URLRequest = new URLRequest(urlStr);
			try
			{
				navigateToURL(url, params);
			}
			catch (e:Error)
			{
				Logger.log("OPENLINK Error >> URL: " + url + " >> PARAMS:" + params);
			}
		}
	}
}
