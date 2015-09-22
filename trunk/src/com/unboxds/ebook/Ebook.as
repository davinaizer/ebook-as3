package com.unboxds.ebook
{
	import com.unboxds.ebook.controller.DataController;
	import com.unboxds.ebook.controller.NavController;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.utils.DebugPanel;
	import com.unboxds.utils.Logger;
	
	/**
	 * Ebook Framework main class.
	 * 
	 * <p>In simple terms, the Ebook FrameWork is a tool to speed up eLearning and paged content creation.<br> 
	 * It has a set of tools to help paging content, transitions effects, user's data tracking, navigation.</p>
	 * 
	 * <p>It was mainly developed to be used as eLearning creation framework but it can be used to create other non-learning content, as websites, hotsites, catalogs, etc.</p>
	 * 
	 * <p>The Ebook Framework was built over Gaia Framework. 
	 * The Gaia framework has a very powerful asset and page manager.
	 * More info about how it works and documentation, can be found here (http://gaiaflashframework.tenderapp.com/).</p>
	 * 
	 * <p>To start building an application using UNBOXDS Ebook Framework, we higly recommend reading the Gaia´s documentation first.</p>
	 * <p>To create an ebook app, you have two main files to edit, xml/ebook_nav.xml and xml/ebook_ui.xml.</p>
	 * <p>The file ebook_nav is used to config all the navigation and pages sequence of the material. You can config other propreties of the ebook, such as:
	 * <ul><li>consultMode:	if true, the ebook is set to Consult Mode only, thus not saving any data to the dataService.</li>
	 * <li>enableAlerts:	if true, all comunication and startup erros dialogs are show.</li>
	 * <li>dataServiceType:	Here you can specify the dataservice type to be used in the ebook. Allowed only: SCORM and SharedObject. If SCORM is set, the SCORM API is used and will require a SORM compatible LMS. For SharedObject dataservice all the users and ebook´s data will be written locally using ShareObject Class.</li>
	 * <li>customData:	Sometimes its necessary to use persistent user´s data or store user´s progress and achievements. To help in this task CustomData Class was created and to setup the data format, you can define using the tags below.</li>
	 * <ul><li>maxPoints:	An array specifying a test or interactions max points.</li>
	 * <li>lessonStatus:	An array specifying a test or interactions status. Its best used using the CustomData status constants. See CustomData class.</li>
	 * </ul></ul>
	 * </p>
	 * 
	 * <p>To help common tasks, the Ebook FrameWork has a integrated ContentParser that reads the page content XML and renders the data. To understand how this class works see ContentParser Class.</p>
	 * 
	 * <p>All rights reserved - UNBOX® - http://www.unbox.com.br</p>
	 * 
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class Ebook
	{
		private static var instance:Ebook = new Ebook();
		
		private var implNav:NavController;
		private var implStatus:EbookModel;
		private var implScormController:DataController;
		private var debugPanel:DebugPanel;
		
		/**
		 * Singleton function to get an Ebook Instance
		 * @return Ebook unique instance
		 */
		public static function getInstance():Ebook
		{
			return instance;
		}
		
		/**
		 * Singleton Class Constructor.
		 * Should not be used. Use getInstance() instead.
		 */
		public function Ebook()
		{
			Logger.log("[AS3 Ebook Framework]\n[UNBOX® 2009-2015 — http://www.unbox.com.br — All rights reserved.]");
			
			if (instance)
				throw new Error("Ebook can only be accessed through Ebook.getInstance()");
		}
		
		/**
		 * Function to access Ebook´s Nav Class instance.
		 * Nav Class is responsible for Ebook´s content navigation.
		 * @return com.unboxds.ebook.controller.NavController Class instance
		 */
		public function getNav():NavController
		{
			if (implNav == null)
				implNav = new NavController();
			return implNav;
		}
		
		/**
		 * Function to access Ebook´s Data Controller istance.
		 * DataController Class is resposible for storing, controlling and acessing data services. eg. ScormDataService, SharedObjectDataService.
		 * @return com.unboxds.ebook.controller.DataController Class instance
		 */
		public function getDataController():DataController
		{
			if (implScormController == null)
				implScormController = new DataController();
			return implScormController;
		}
		
		/**
		 * Function to acess Ebook´s Status Class instance.
		 * Status Class is responsible for all the tracking, navigation and user´s data.
		 * @return
		 */
		public function getStatus():EbookModel
		{
			if (implStatus == null)
				implStatus = new EbookModel();
			return implStatus;
		}
		
		public function getDebugPanel():DebugPanel
		{
			return debugPanel;
		}
		
		public function setDebugPanel(debugPanel:DebugPanel):void
		{
			this.debugPanel = debugPanel;
		}
	}
}