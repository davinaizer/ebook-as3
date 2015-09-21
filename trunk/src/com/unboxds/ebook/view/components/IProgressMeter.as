package com.unboxds.ebook.view.components
{
	import flash.text.StyleSheet;
	import org.osflash.signals.ISignal;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public interface IProgressMeter
	{
		function enable(value:Boolean):void;
		function setProgress(current:int, total:int):void;
	}

}