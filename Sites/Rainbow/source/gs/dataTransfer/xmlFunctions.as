
var mainObj=_root.parsed_obj;
var galleryObj=_root.gallery_obj;


function textSelectable(selectedObject) {
	isTextSelected=getSettingsValue(mainObj, "textSelectable", "item");
	if (isTextSelected=="true") {
		selectedObject.selectable=true;
		
		}
	}


function getXmlSection (obj, itemName,  sectionName) {
		i=0;
	while (obj[itemName][i]) {
		if (obj[itemName][i].name==sectionName) {
			returnedResult=true;
			return (i);
			break;
		}
		i++;
	}
}


function getSettingsValue (obj, itemName, itemType) {
	sectionNum=getXmlSection(obj, "section",  "settings");
	k=0;
	while (obj["section"][sectionNum][itemType][k]) {
		if (obj["section"][sectionNum][itemType][k].name==itemName) {
			return (obj.section[sectionNum][itemType][k].value);
			break;
		}
		k++;
	}
}

function getCopyright (textObj) {
	textObj.htmlText=getSettingsValue(mainObj, "copyright", "item");
	textSelectable(textObj);
}


function getCompanyName (textObj) {
	textObj.htmlText=getSettingsValue(mainObj, "companyName", "item");
	textSelectable(textObj);
}

function getSlogan (textObj) {
	textObj.htmlText=getSettingsValue(mainObj, "slogan", "item");
	textSelectable(textObj);
}


function getSystemValue (textObj, systemOptionName) {
	textObj.htmlText=getSettingsValue(mainObj, systemOptionName, "item");
	textSelectable(textObj);
}




function getMenuLink (textObj, linkNum) {
	sectionNum=getXmlSection(mainObj, "section",  "menu");
	textObj.htmlText=mainObj["section"][sectionNum].link[linkNum].value;
	textSelectable(textObj);
}




function getMenuSystemOrder (linkNum) {
	sectionNum=getXmlSection(mainObj, "section", "menu");
	return (mainObj["section"][sectionNum].link[linkNum].systemOrder);
	
}


function getCurrentText(textObj, textNumber) {
	sectionNum=getXmlSection(mainObj, "section", "pages");
	currentPage=_root.link-_root.firstPageFrame;
	textObj.htmlText=mainObj["section"][sectionNum]["page"][currentPage]["texts"][0]["pageText"][textNumber].value;
	textSelectable(textObj);
	
	



}




function getMenuPreviousLink (linkNum) {
	k=0;
	systemOrder=getMenuSystemOrder(k);
	while (systemOrder) {
		if (systemOrder==linkNum) {
			orderResult=k+1;
			break;
		}
		k++;
		systemOrder=getMenuSystemOrder(k);
	}
	return (orderResult);
}


function getCurrentImageName(imageNumber) {
	sectionNum=getXmlSection(mainObj, "section", "pages");
	currentPage=_root.link-_root.firstPageFrame;
	imageParams=new Array();
	imageParams['name']=mainObj["section"][sectionNum]["page"][currentPage]["image"][imageNumber]["imageUrl"];
	imageParams['linkToOpen']=mainObj["section"][sectionNum]["page"][currentPage]["image"][imageNumber]["link"];
	imageParams['target']=mainObj["section"][sectionNum]["page"][currentPage]["image"][imageNumber]["target"];
	return (imageParams);
}

function getCurrentImageName_splash(imageNumber) {
	sectionNum=getXmlSection(mainObj, "section", "settings");
	imageParams=new Array();
	imageParams['name']=mainObj["section"][sectionNum]["image"][imageNumber]["imageUrl"];
	imageParams['linkToOpen']=mainObj["section"][sectionNum]["image"][imageNumber]["link"];
	return (imageParams);
}

function checkLinkType (linkTextType, linkNumber) {
 		k=0;
		typeCount=0;
		finalLinkNumber=parseInt(linkNumber)+1;
		currentPage=_root.link-_root.firstPageFrame;
		sectionNum=getXmlSection(mainObj, "section", "pages");
		linkTypeCkeck=mainObj["section"][sectionNum]["page"][currentPage]["link"][k]["linkType"]; 
		while (linkTypeCkeck){
			if (linkTypeCkeck==linkTextType) {
	 			typeCount++;
			}
			if (typeCount==finalLinkNumber) {
				
				return(k);
				break;
			}
			k++;
			linkTypeCkeck=mainObj["section"][sectionNum]["page"][currentPage]["link"][k]["linkType"]; 
		}
}

_root.readMoreFrameType = 'readmore';

function more_click_func(number) {
	if(_root.my_flag == 1) {
		_root.link=1;
		_root.link_prev=1;
		getMenuPreviousLink(_root.link)
		//_root.main.gotoAndPlay("s4");
	}
	tempNumber = number.split(" ");
	number=tempNumber.join("");
	number=number.toLowerCase();
	num=_root.pagesReadMoreFrame;
	currentPage=_root.link-_root.firstPageFrame;
	
	if( isNaN(Number(number)) ) {
		readMoreType = number;
	} else {
		readMoreType = 'readmore';
	}
	
	if( (_root.link<>num || _root.readMoreFrameType!=readMoreType) and _root.animation==1) {
		_root.animation=0;
		_root.link_prev=_root.link;
		if (_root.link<>6 and _root.my_flag <> 1) {
			_root.menu["item"+getMenuPreviousLink(_root.link)].gotoAndPlay("s2");
			_root.menu2["item"+getMenuPreviousLink(_root.link)].gotoAndPlay("s2");
		}

		//_root.plane_movs(_root.base_koord[0])
		
		if (number=='privacypolicy') {
			_root.readMoreFrameType = 'privacypolicy';
			sectionNum=getXmlSection(mainObj, "section", "privacyPolicy");
			titleNum=getXmlSection(mainObj.section[sectionNum], "item", "pageTitle");
			textNum=getXmlSection(mainObj.section[sectionNum], "item", "pageText");
			_root.readMoreTitle=mainObj.section[sectionNum]["item"][titleNum].value;
			_root.readMoreText=mainObj.section[sectionNum]["item"][textNum].value;
		} else if (number=='termsofuse') {
			_root.readMoreFrameType = 'termsofuse';
			sectionNum=getXmlSection(mainObj, "section", "termsOfUse");
			titleNum=getXmlSection(mainObj.section[sectionNum], "item", "pageTitle");
			textNum=getXmlSection(mainObj.section[sectionNum], "item", "pageText");
			_root.readMoreTitle=mainObj.section[sectionNum]["item"][titleNum].value;
			_root.readMoreText=mainObj.section[sectionNum]["item"][textNum].value;
		} else {
			_root.readMoreFrameType = 'readmore';
			sectionNum=getXmlSection(mainObj, "section", "pages"); 
			linkCount=checkLinkType("readMoreLink", number);
			i=0;
			linkTitleNum=getXmlSection(mainObj["section"][sectionNum]["page"][currentPage]["link"][linkCount], "item", "title");			
			linkTextNum=getXmlSection(mainObj["section"][sectionNum]["page"][currentPage]["link"][linkCount], "item", "linkText"); 
			_root.readMoreTitle=mainObj["section"][sectionNum]["page"][currentPage]["link"][linkCount]["item"][linkTitleNum].value;
			_root.readMoreText=mainObj["section"][sectionNum]["page"][currentPage]["link"][linkCount]["item"][linkTextNum].value;			 
		}
		_root.link=num;
		_root.play();
	}
}


function getContactFormText(textObj, textNumber) {
	sectionNum=getXmlSection(mainObj, "section", "contactForm");
	textObj.htmlText=mainObj["section"][sectionNum]["texts"][0]["pageText"][textNumber].value;
	textSelectable(textObj);
}


function getContactFormText_only(textNumber) {
	sectionNum=getXmlSection(mainObj, "section", "contactForm");
	return htmlText=mainObj["section"][sectionNum]["texts"][0]["pageText"][textNumber].value;

}


function getContactFormParams() {
	sectionNum=getXmlSection(mainObj, "section", "contactForm");
	ContactFormParams=new Array();
	servNum=getXmlSection(mainObj["section"][sectionNum], "item", "serverOption");
	recNum=getXmlSection(mainObj["section"][sectionNum], "item", "recipient");
	ContactFormParams['rec']=mainObj["section"][sectionNum]["item"][recNum].value;
	ContactFormParams['serv']=mainObj["section"][sectionNum]["item"][servNum].value
	return (ContactFormParams);
}




// gallery functions
function getGallerySystemProperty(propName) {
	sectionNum=getXmlSection(galleryObj, "section", "systemOptions");
	propNum=getXmlSection(galleryObj["section"][sectionNum], "option", propName);
	return (galleryObj["section"][sectionNum]["option"][propNum].value);
}

function getGallerySettings(propName) {
	sectionNum=getXmlSection(galleryObj, "section", "settings");
	propNum=getXmlSection(galleryObj["section"][sectionNum], "option", propName);
	return (galleryObj["section"][sectionNum]["option"][propNum].value);
}

function getGalleryImage(imageNum, categoryNum) {
	sectionNum=getXmlSection(galleryObj, "section", "imagesData");
	imageParams=new Array();
	image=galleryObj["section"][sectionNum]["category"][categoryNum]["image"][imageNum];
	nameNum=getXmlSection(image, "item", "imageUrl");
	commentNum=getXmlSection(image, "item", "imageComment");
	imageParams['name']=image['item'][nameNum].value;
	imageParams['comment']=image['item'][commentNum].value;
	return (imageParams);
}

function getCurrentGalleryName(categoryNum) {
	sectionNum=getXmlSection(galleryObj, "section", "imagesData");
	return (galleryObj["section"][sectionNum]["category"][categoryNum].name);
}