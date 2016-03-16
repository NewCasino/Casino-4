function doCalc(){
	//get values in inputs from user
	var direct = doValue('direct');
	var viral = doValue('viral');		  
	var invitelevels = doValue('invitelevels');
	var fixedinvitelevels = (invitelevels - 1);
	
	//invitelevels = Number(invitelevels.selectedIndex);  
	var yourmembers = doValue('yourmembers');		  
	var yourwebsite = doValue('yourwebsite');		  
	var yourtoolbar = doValue('yourtoolbar');
	updateInvites(gEl('viral').value);
	//initialize vars before loops to get level 1 values
	var holder1 = direct;
	var holder1members = ((holder1 * yourmembers)*.0030)*30;
	var holder1toolbar = ((holder1 * yourtoolbar)*0.03)*30;
	
	
	/* store values */
	var _tc = gEl('direct').value + '|' + gEl('viral').value + '|' + gEl('invitelevels').value + '|' + gEl('yourmembers').value + '|' + gEl('yourwebsite').value + '|' + gEl('yourtoolbar').value;
	setCookie('i5_calc', _tc) 
	
	//if invites are 2 or greater
	if(invitelevels>=2){
		for (i=0;i<fixedinvitelevels;i++){
			
			//get total direct members per invite level		
			var holder2 = (holder1 * viral);	
			var holdall = direct += holder2;
			
			//get total $ from members per invite level
			var holder2members = ((holder2 * yourmembers)*.0030)*30;						
			var holdallmembers = holder1members += holder2members;
			
			//get total $ from your toolbar
			var holder2toolbar = ((holder2 * yourtoolbar)*0.03)*30;					
			var holdalltoolbar = holder1toolbar += holder2toolbar;
									
			//now done with one invite level so change holder var to equal current direct reg number 
			//start of loop then does * viral num to continue untill we reach end of viral number
			holder1 = holder2;
		}		
		
		//write totals to all inputs
		var totaldirect = holdall;
		var totalyourmembers = holdallmembers;
		var totalyourwebsite = (yourwebsite * 0.01)*30;
		var totalyourtoolbar = holdalltoolbar;
		var totalnet = (totalyourmembers + totalyourwebsite + totalyourtoolbar); 	
		showTotal(totaldirect,'totaldirect');
		showTotal(totalyourmembers,'totalyourmembers');	
		showTotal(totalyourwebsite,'totalyourwebsite');
		showTotal(totalyourtoolbar,'totalyourtoolbar');
		showTotal(totalnet,'totalnet');
	} else {
		//write totals to all inputs based on less than 2 viral audience
		var totaldirect = direct;
		var totalyourmembers = holder1members;
		var totalyourwebsite = (yourwebsite * 0.01)*30;
		var totalyourtoolbar = holder1toolbar;
		var totalnet = (totalyourmembers + totalyourwebsite + totalyourtoolbar);
		//alert(totalnet);	
		showTotal(totaldirect,'totaldirect');
		showTotal(totalyourmembers,'totalyourmembers');	
		showTotal(totalyourwebsite,'totalyourwebsite');
		showTotal(totalyourtoolbar,'totalyourtoolbar');
		showTotal(totalnet,'totalnet');
		//document.getElementById('totalnet').value = totalnet;
	}
	function doValue(who)
	{
		if (document.getElementById(who))
		{
			var theValue = document.getElementById(who).value;
			//convert string to num before pass back
			return parseInt(theValue.replace(/[\s\,]/g,''));
		}
		return 0;
	}
	function showTotal(myNum,who)
	{
	      	var decimal = 2;
	      	for(i=1; i<=2; i++)
	      	{ 
		        decimal = decimal *100;
			var myFormattedNum = ((myNum * decimal)/decimal);
			if (myNum = totalnet) {
				document.getElementById(who).value = "$"+addCommas(myFormattedNum.toFixed(2));
			}else{
				myFormattedNum = addCommas(myFormattedNum.toFixed(2));
				document.getElementById(who).value = (myFormattedNum == 'NaN' || myFormattedNum == NaN) ? '0.00' : myFormattedNum;
			}
		}
	}
	
	function addCommas(nStr)
	{
		nStr += '';
		x = nStr.split('.');
		x1 = x[0];
		x2 = x.length > 1 ? '.' + x[1] : '';
		var rgx = /(\d+)(\d{3})/;
		while (rgx.test(x1)) {
			x1 = x1.replace(rgx, '$1' + ',' + '$2');
		}
		return x1 + x2;
	}	
}
function initBlueCalc()
{
	if (!gEl('yourmembers') || !gEl('yourtoolbar'))
		return;
	var m = getCookie('i5_calc');
	if (m)
	{
		var t = m.split('|');
		gEl('direct').value = (t[0] == '') ? 0 : t[0];
		setSelectedValue('viral', (t[1] == '' ? 0 : t[1]));
		setSelectedValue('invitelevels', (t[2] == '' ? 0 : t[2]));
		setSelectedValue('yourmembers', (t[3] == '' ? 0 : t[3]));
		gEl('yourwebsite').value = (t[4] == '') ? 0 : t[4];
		setSelectedValue('yourtoolbar', (t[5] == '' ? 0 : t[5]));
	}
	doCalc();
}
function emptyValue(who){
	if(who.value=='0')
	who.value = '';
}

//when user changes viral select, need to allow / disallow invites select
//if viral audience is not at least 2, then invitation level stays at 1 (disabled)
function updateInvites(num){
	//alert("my num is :" + num + "and is of type " + typeof(num));
	num = parseInt(num);
	if (num >= 2) {
		document.getElementById('invitelevels').disabled = false;
	}else{
		document.getElementById('invitelevels').disabled = true;
		document.getElementById('invitelevels').value = 1;
	}
}

addEvent(window, 'load', initBlueCalc);
