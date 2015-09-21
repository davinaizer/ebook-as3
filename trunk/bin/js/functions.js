//-- functions
function openWin(theURL, winName, features) {
	window.open(theURL, winName, features);
}

//-- functions
function MM_openBrWindow(theURL, winName, features) {
	window.open(theURL, winName, features);
}

function exit() {
	window.top.close();
}

function getMovie(movieName) {
	if (navigator.appName.indexOf("Microsoft") != -1) {
		return window[movieName];
	} else {
		return document[movieName];
	}
}

function saveEbook() {
	var flashObj = document.getElementById('flashcontent');
	flashObj.jsCall('save', '');
}
	
//-- SCORM FUNCTIONS
var unloaded = false;
var scorm = pipwerks.SCORM;
scorm.version = "1.2";

function unloadHandler() {
	if (!unloaded) {
		scorm.quit(); //close the SCORM API connection properly	
		unloaded = true;
	}
}

//-- check window close
function confirmClose(e) {
	//-- SAVE SCORM DATA
	saveEbook();
	scorm.save();

	if (!e) e = window.event;
	e.cancelBubble = true;
	e.returnValue = 'Deseja realmente sair deste treinamento?';
	if (e.stopPropagation) {
		e.stopPropagation();
		e.preventDefault();
	}
	return 'Deseja realmente sair deste treinamento?';
}
//-- CHECK WINDOW SIZE
function checkWindowSize() {
	var offsetWidth = window.outerWidth - window.innerWidth;
	var offsetHeight = window.outerHeight - window.innerHeight;
	var contentWidth = 1000 + offsetWidth;
	var contentHeight = 600 + offsetHeight;

	console.log("Resizing Window to fit Content >> " + contentWidth + " x " + contentHeight);

	window.resizeTo(contentWidth, contentHeight);
	window.moveTo(((screen.width - contentWidth) / 2), ((screen.height - contentHeight) / 2));
	window.focus();
}
//--
window.onbeforeunload = confirmClose;
window.onunload = unloadHandler;
window.onload = checkWindowSize;

var resizeTimer = null;
$(window).bind('load', function () {
    if (resizeTimer) clearTimeout(resizeTimer);
    resizeTimer = setTimeout(checkWindowSize, 500);
});
