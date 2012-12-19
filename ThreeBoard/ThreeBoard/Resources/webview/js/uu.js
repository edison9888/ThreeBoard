/**
 * @author lizhuhong
 * modified on 2012-09-06, for IOS only
 * image header is added, as well as the following random headers,
 * title below or above the horizontal seperator header,
 * meanwhile, checkSingleTap interface is added
 * all image can be set successfully, and should be clickable
 */
(function() {		
	var wrapperDiv = document.getElementById("wrapper");
	var imageBoxArr, viewMode, fontSize;
	var isMove;
	//var categoryArray = ["entertainment", "fashion", "creativity", "travelling", "beautiful pic"];
	var categoryArray = ["\u5a31\u4e50","\u65f6\u5c1a", "\u521b\u610f", "\u65c5\u6e38", "\u7f8e\u56fe"];
 
 // Javascript语言
 // 通知iPhone UIWebView 加载url对应的资源
 // url的格式为: gap:something
    function loadURL(url) {
        var iFrame;
        iFrame = document.createElement("iframe");
        iFrame.setAttribute("src", url);
        iFrame.setAttribute("style", "display:none;");
        iFrame.setAttribute("height", "0px");
        iFrame.setAttribute("width", "0px");
        iFrame.setAttribute("frameborder", "0");
        document.body.appendChild(iFrame);
        // 发起请求后这个iFrame就没用了，所以把它从dom上移除掉
        iFrame.parentNode.removeChild(iFrame);
        iFrame = null;
    }
 
	window.setContent = function(json) {
		var originalNews = document.getElementById("view_original_news");
		var newsDetails = document.getElementById("news_details");
		var title = json.title || '';		
		var site = json.site || '';
		var time = json.ts ? json.ts : '';
		var category = json.category || '';
		var newsUrl = json.url || '';
		var newsContent = json.content || '';
 
       // setContentBegin();
		
		if (viewMode != undefined) {
			setViewMode(viewMode);
		}
		
		if (fontSize != undefined) {
			setTextFont(fontSize);
		}
		
		if (typeof(newsContent) == "string") {
			newsContent = eval("(" + newsContent + ")");
		}
		
		newsContent = parseContentToHtml(newsContent);
        newsDetails.innerHTML = newsContent;
		
		imageBoxArr = newsDetails.getElementsByClassName("imgBox");
		createHeader(title, site, time, category);
		
		if (originalNews != undefined) {
			originalNews.parentElement.removeChild(originalNews);
		}
				
//		originalNews = document.createElement("div");					
//		originalNews.setAttribute("id", "view_original_news");
//		originalNews.setAttribute("data-url", newsUrl);
//		originalNews.setAttribute("data-action", "open_original");
//		originalNews.appendChild(document.createTextNode("\u6d4f\u89c8\u539f\u6587"));
//		document.getElementById("content").appendChild(originalNews);
 
//        originalNews.addEventListener("touchstart", handleTouchStart, false);
//        originalNews.addEventListener("touchmove", handleTouchMove, false);
//        originalNews.addEventListener("touchend", handleTouchEnd, false);
	
        setContentFinish();
	}
	
//    window.checkSingleTap = function(x, y) {
//        var targetElm, scrolledY = window.scrollY;
//        var prefix = "bdapi://hybrid?info=";
//        var action = "";
//        var args ="";
//        if (scrolledY > 0) {
//            if (document.elementFromPoint(0, scrolledY + window.innerHeight - 1) != null) {
//                y += scrolledY;
//            }
//        }
// 
//        targetElm = document.elementFromPoint(x, y);
// 
//        if (targetElm.tagName === "IMG") {
//            action = "image";
//            args = '{"imageUrl" : "' + targetElm.getAttribute("data-url") + '"}';    
//        }
//
//        else if (targetElm.getAttribute("class") === "imgBox") {
//            action = "image";
//            args = '{"imageUrl" : "' + targetElm.firstChild.getAttribute("data-url") + '"}';  
//        }
//
//        else if (targetElm.getAttribute("id") !== "view_original_news") {
//            action = "single_tap";
//            args = "{}";
//        }
// 
//        window.location.href = prefix + '{"action": "' + action + '", "args":' + args + '}';
// 
//    }

	
	window.setImage = function(imageArray) {	
		var imageBoxes = document.getElementsByClassName("imgBox");
		var imageSetNum = imageArray.length;		
		var imageNum = imageBoxes.length; 
		var tempImage;
				
		for (var i = 0; i < imageSetNum; i++) {			
			for (var j = 0; j < imageNum; j++) {
				tempImage = imageBoxes[j].firstChild;
				if (tempImage.getAttribute("data-url") == imageArray[i].imageUrl) {
					tempImage.setAttribute("src", imageArray[i].localPath);
                    tempImage.style.visibility = "visible";
                    tempImage.parentElement.style.background = "none";
				}
			}
		}
	}
	
	window.setViewMode = function(mode) {		
		viewMode = mode;
		
		if (mode == 0) {
			addClass(document.body, "nightMode");
		} 
		else {
			removeClass(document.body, "nightMode");
		}		
	}
	
	window.setTextFont = function(font) {	
		fontSize = font;
		
		switch (font) {		
			case 2: 
				removeClass(document.body, "smallFont");
				addClass(document.body, "bigFont");
				break;
			case 0:
				removeClass(document.body, "bigFont");
				addClass(document.body, "smallFont");
				break;
			default:
				removeClass(document.body, "bigFont");
				removeClass(document.body, "smallFont");
		}		
	}

	
    function setContentBegin() {
        window.location.href = 'bdapi://hybrid?info={"action": "set_content_begin", "args": {}}';
    }
	
    function setContentFinish() {
        window.location.href = 'bdapi://hybrid?info={"action": "set_content_finish", "args": {}}';
    }
	
	function wrapElm(tagName, id, text) {
		var elm = document.createElement(tagName),
			textNode = document.createTextNode(text);
		elm.setAttribute("id", id);
		elm.appendChild(textNode);
		
		return elm;	
	}
	
	function createElm(tagName, id) {
		var elm = document.createElement(tagName);
		elm.setAttribute("id", id);
					
		return elm;
	}
	
//	function fillDescriptionDiv(parent, firstElm, sencondElm, lastElm) {		
//		parent.appendChild(firstElm);
//		parent.appendChild(sencondElm);
//		parent.appendChild(lastElm);
//		return parent;
//	}
 
    function fillDescriptionDiv(parent, childElem)
    {
        parent.appendChild(childElem);
        return parent;
    }
	
	function createHeader(title, site, time, category) {
		var rand = Math.floor(Math.random() * 4);
		var header = document.getElementById("header"),
			titleElm = wrapElm("h1", "title_h1", title),
			titleDiv = createElm("div", "title"),
			siteSpan = wrapElm("span", "site", site),
			timeSpan = wrapElm("span", "time", time),
			categorySpan = wrapElm("span", "category", category),
			descriptionDiv = createElm("div", "description"),
            paraElm = document.getElementById("news_details").getElementsByTagName("p");
						
		if (header != undefined) {
			header.parentElement.removeChild(header);
			header = createElm("div", "header");
			document.getElementById("wrapper").insertBefore(header, document.getElementById("content"));
		}
		
		titleDiv.appendChild(titleElm);
 
//        descriptionDiv = fillDescriptionDiv(descriptionDiv, siteSpan, categorySpan, timeSpan);
        descriptionDiv = fillDescriptionDiv(descriptionDiv, timeSpan);
        header.appendChild(titleDiv);
        header.appendChild(descriptionDiv);
        removeClass(header, "title_on_bottom");
        removeClass(header, "image_header");
        removeClass(wrapperDiv, "wrapper_with_image_header");
	
			
	}
	
	function isValInArray(arr, val) {
		for (var item in arr) {
			if (arr[item] == val) {
				return true;
			}
		}
		return false;
	}
	
	function parseContentToHtml(content) {
        var documentWidth = 320;
		var arrLength = content.length;
		var paragraph = [], url, width, height, imageHeight, imageWidth;
        var defaultImage = "../image/text_page_pic.png";
 
        if (hasClass(document.body, "nightMode") != -1) {
            defaultImage = "../image/night_mode_text_page_pic.png";
        }
 
		for (var i = 0; i < arrLength; i++) {			
			if (content[i].type == "text") {
				paragraph.push('<p class="news_paragraph">' + content[i].data + '</p>');
			}
			else if (content[i].type == "image") {
 
                url = content[i].data.small.url;
                width = parseInt(content[i].data.small.width);
				height = parseInt(content[i].data.small.height);
 
                if (width <= documentWidth) {
                    imageHeight = height;
                    imageWidth = width;
                }
                
                else {                    
                    imageHeight = Math.floor(height * documentWidth / width);
                    imageWidth = documentWidth;
                }
			
				paragraph.push('<div class="imgBox" style="width: ' + imageWidth + 'px; height: ' + imageHeight + 'px;"><img width="' + imageWidth + '" height="' + imageHeight + '" data-url="' + url + '" data-action="image" src="" style="border: none; "/></div>');
//                paragraph.push('<div class="imgBox" style="width: ' + imageWidth + 'px; height: ' + imageHeight + 'px;"><img width="' + imageWidth + '" height="' + imageHeight + '" data-url="' + url + '" data-action="image" src="'+url+'" style="border: none; "/></div>');
			}
		}
			
		return paragraph.join('');			
	}
		
//	function getLocalTime(timestamp) {
//		var date = new Date(parseInt(timestamp));
//		var year = date.getFullYear();
//		var month = date.getMonth() + 1;
//		var day = date.getDate();
//		
//		return (year + "-" + formatNum(month) + "-" + formatNum(day));
//	}
	
	function formatNum(num) {	
		if (num < 10) {
			return "0" + num;
		}
		return num;		
	}
	
	function hasClass(elm, className) {		
	    var classes = elm.className.split(' ');
	    
	    for(var index in classes) {
	        if (classes[index] == className) {
	        	return index;
	        }	        	        
	    }
	    
	    return -1;	    
	}
	
	function addClass(elm, newClass) {  	
	    var classes = elm.className.split(' ');
	    var classIndex = hasClass(elm, newClass);
	    
	    if (classIndex == -1) {
	    	classes.push(newClass);
	    }
	    
	    elm.className = classes.join(' ');	    
	}

	function removeClass(elm, className) {		
	    var classes = elm.className.split(' ');
	    var classIndex = hasClass(elm, className);
	    
	    if (classIndex != -1) {
	    	classes.splice(classIndex, 1);
	    }
	    	    	
	    elm.className = classes.join(' ');	 		
	}	
	
//    function handleTouchStart(event) {	
//		var srcElm = event.srcElmment || event.target;
//		isMove = false;
//		addClass(srcElm, "pressed");
//	}
//	
//	function handleTouchMove(event) {
//		var srcElm = event.srcElmment || event.target;	
//		isMove = true;
//		removeClass(srcElm, "pressed");
//    }
//	
//	function handleTouchEnd(event) {		
//		var srcElm = event.srcElmment || event.target;			
//		var action = "";
//		var args = "";
//		var prefix = "bdapi://hybrid?info=";
//		
//		setTimeout(function() {
//			removeClass(srcElm, "pressed");
//		}, 200);
//			
//		if (!isMove) {
//            action = "open_original";
//            args = '{"url" : "' + srcElm.getAttribute("data-url") + '"}';             
//
//			window.location.href = prefix + '{"action": "' + action + '", "args":' + args + '}';
//		}													
//    }
	
	function isAndroid() {
		return navigator.userAgent.match(/android/i);
	}
	
	function init() {	
		if (isAndroid()) {
			document.addEventListener('DOMContentLoaded', function() {
    			window.location.href = 'bdapi://hybrid?info={"action": "load_finish", "args": {}}';
			}, false);
			addClass(document.body, "android");
		}
		else {
			removeClass(document.body, "android");
		}							
	}
	
	init();
		
})();
