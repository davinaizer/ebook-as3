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

//--
window.onunload = unloadHandler;

// IE Console fix
(function() {
	var method;
    var noop = function () {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeline', 'timelineEnd', 'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());
