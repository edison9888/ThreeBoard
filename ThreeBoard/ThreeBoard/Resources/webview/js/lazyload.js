!function() {
	var defaultOptions = {threshold: 0, placeholder: "image/pixel.gif"};
	var images = [];
	function lazyLoad(selector, options) {
		images = [].slice.call(document.querySelectorAll(selector),0);
		images.forEach(function(image){
			image.style.height = getComputedStyle(image).height;
			image.setAttribute("original-src", image.getAttribute("src"));
		});
		for(var i in options) defaultOptions[i] = options[i];
		checkTheFoldImages();
	};
	function insideView(image) {
		var fromTop = (image.offsetTop + parseInt(image.style.height) > window.scrollY - defaultOptions['threshold']);
		var fromBootom = (image.offsetTop < window.scrollY + window.innerHeight/2 + defaultOptions['threshold'])
        return fromTop && fromBootom;
    };
    function loadOriginalImage(image) {
    	image.setAttribute("src", image.getAttribute("original-src"));
    };
    function unloadOriginalImage(image) {
    	image.setAttribute("src", defaultOptions.placeholder);
    };
    function checkTheFoldImages() {
        images.forEach(function(image) {
            if (insideView(image)) {
                loadOriginalImage(image);
            } 
			else {
				unloadOriginalImage(image);
            }
        });
    };
	window.onscroll = function() {
		checkTheFoldImages();
	};
	window.lazyLoad = lazyLoad;
}();