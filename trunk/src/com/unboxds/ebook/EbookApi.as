package com.unboxds.ebook
{
	import com.unboxds.ebook.controller.EbookController;
	import com.unboxds.ebook.controller.NavController;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.utils.DebugPanel;
	import com.unboxds.utils.Logger;

	/**
	 * Ebook Framework API class.
	 *
	 * <p>In simple terms, the EbookApi FrameWork is a tool to speed up eLearning and paged content creation.<br>
	 * It has a set of tools to help paging content, transitions effects, user's data tracking, navigation.</p>
	 *
	 * <p>It was mainly developed to be used as eLearning creation framework but it can be used to create other non-learning content, as websites, hotsites, catalogs, etc.</p>
	 *
	 * <p>The EbookApi Framework was built over Gaia Framework.
	 * The Gaia framework has a very powerful asset and page manager.
	 * More info about how it works and documentation, can be found here (http://gaiaflashframework.tenderapp.com/).</p>
	 *
	 * <p>To start building an application using UNBOXDS EbookApi Framework, we higly recommend reading the Gaia´s documentation first.</p>
	 * <p>To create an ebook app, you have two main files to edit, xml/ebook_nav.xml and xml/ebook_ui.xml.</p>
	 * <p>The file ebook_nav is used to config all the navigation and pages sequence of the material. You can config other propreties of the ebook, such as:
	 * <ul><li>consultMode:    if true, the ebook is set to Consult Mode only, thus not saving any data to the dataService.</li>
	 * <li>enableAlerts:    if true, all comunication and startup erros dialogs are show.</li>
	 * <li>dataServiceType:    Here you can specify the dataservice type to be used in the ebook. Allowed only: SCORM and SharedObject. If SCORM is set, the SCORM API is used and will require a SORM compatible LMS. For SharedObject dataservice all the users and ebook´s data will be written locally using ShareObject Class.</li>
	 * <li>customData:    Sometimes its necessary to use persistent user´s data or store user´s progress and achievements. To help in this task CustomData Class was created and to setup the data format, you can define using the tags below.</li>
	 * <ul><li>maxPoints:    An array specifying a test or interactions max points.</li>
	 * <li>lessonStatus:    An array specifying a test or interactions status. Its best used using the CustomData status constants. See CustomData class.</li>
	 * </ul></ul>
	 * </p>
	 *
	 * <p>To help common tasks, the EbookApi FrameWork has a integrated ContentParser that reads the page content XML and renders the data. To understand how this class works see ContentParser Class.</p>
	 *
	 * <p>All rights reserved - UNBOX® - http://www.unbox.com.br</p>
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookApi
	{
		private static var instance:EbookApi = new EbookApi();

		private var navController:NavController;
		private var model:EbookModel;
		private var controller:EbookController;

		private var debugPanel:DebugPanel;

		/**
		 * Singleton function to get an EbookApi Instance
		 * @return EbookApi unique instance
		 */
		public static function getInstance():EbookApi
		{
			return instance;
		}

		/**
		 * Singleton Class Constructor.
		 * Should not be used. Use getInstance() instead.
		 */
		public function EbookApi()
		{
			Logger.log("[EbookAS Framework]\n[UNBOX® 2009-2015 — http://www.unbox.com.br — All rights reserved.]");

			if (instance)
				throw new Error("EbookApi can only be accessed through EbookApi.getInstance()");
		}

		/**
		 * Function to access EbookApi´s Nav Class instance.
		 * Nav Class is responsible for EbookApi´s content navigation.
		 * @return NavController Class instance
		 */
		public function getNavController():NavController
		{
			if (navController == null)
				navController = new NavController();
			return navController;
		}

		/**
		 * Function to access Ebook's Controller instance.
		 * EbookController Class is responsible for storing, controlling and accessing data services. eg. ScormDataService, SharedObjectDataService.
		 * @return EbookController Class instance
		 */
		public function getEbookController():EbookController
		{
			if (controller == null)
				controller = new EbookController();
			return controller;
		}

		/**
		 * Function to acess Ebook's Model Class instance.
		 * EbookModel Class is responsible for all the tracking, navigation and user´s data.
		 * @return
		 */
		public function getEbookModel():EbookModel
		{
			if (model == null)
				model = new EbookModel();
			return model;
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