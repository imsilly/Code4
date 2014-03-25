function init () {
	window.onresize = function() {
		this.setHeightWidth();
	}
	setHeightWidth();
}

function setHeightWidth(){
	var FlashcontentObj = document.getElementById('flashcontent');
	if(document.body.offsetWidth < 900){
		FlashcontentObj.style.width = '900px';
	} else{
		FlashcontentObj.style.width = '100%';
	}
}