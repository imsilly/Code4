// JavaScript Document
function createbookmarklink() {
	
	title = document.title;
	url = window.location.href;
	
	if (window.sidebar) { // Mozilla Firefox Bookmark
		window.sidebar.addPanel(title, url,"");
	} else if( window.external ) { // IE Favorite
		window.external.AddFavorite( url, title); 
	} else if(window.opera && window.print) { // Opera Hotlist
		var elem = document.createElement('a');
		elem.setAttribute('href',url);
		elem.setAttribute('title',title);
		elem.setAttribute('rel','sidebar');
		elem.click();
	}
}