x0=410;
y0=171;
kingcounter=0;
winking=0;

kingbonus._visible=false
diamond._visible=false


holder.removeMovieClip(); //if exists
pyramidsound.removeMovieClip(); //if exists
createEmptyMovieClip('pyramidsound',this.getNextHighestDepth());



for (i=1;i<=5;i++) {
eval("kingbtn"+i).num=i;
eval("kingbtn"+i).onPress=function() {
trace("buttpressed :"+this.num)
pressed(this.num);
this.enabled=false;
}
}



function  pressed(num) {
trace("pressed kingbonus :"+num+"uid:"+u)
		eval("kingbtn"+num)._visible=false;
	    lvk = new LoadVars();
	    lvk.kingbonus="1";
		lvk.uid=u; 
		lvk.num = num;
	    lvk.sendAndLoad(uri+"s5jpgen.php", lvk, "post");		
	    lvk.onLoad = function (success) {
		trace("rem:"+this.remaining+"won:"+this.won)
		_root.shownumber(this.won,this.num,this.remaining);
	    }
}


function shownumber(numb,place,remaining) {
	var digits = new Array();
	str = String(numb)	
	kingcounter++;
	
	for (i=0;i<str.length;i++) {
		digits[i]=Number(str.charAt(i));
	}
	x=380; y=85; dy=0;		
	createEmptyMovieClip("holder",this.getNextHighestDepth());
	holder._x=x; holder._y=y; dx=0;

		if (numb>=0) {
		winking+=Number(numb);
		kingbonus._visible=true
		diamond._visible=true
		kingbonus.play()
		diamond.play()
		
	
		for (i=0;i<digits.length;i++) {
				n = digits[i];  h = holder.getNextHighestDepth();
				newmc = holder.attachMovie("dig"+n,"kingdig"+h,h)
				newmc._x=eval("kingbtn"+place)._x-x-(digits.length/2)*15+i*20; newmc._y= eval("kingbtn"+place)._y-y;
		}
	
	if (numb>0) {
	pyramidsound.winSound = new Sound();
	pyramidsound.winSound.attachSound("TTK_bonus_win.wav");
	pyramidsound.winSound.start(0,1)
	pyramidsound.winSound.setVolume(100);
	
	} else {
		pyramidsound.winSound = new Sound();
		pyramidsound.winSound.attachSound("TTK_gamblelose.wav");
		pyramidsound.winSound.start(0,1)
		
		arr = new Array();
		arr = remaining.split(',')
		trace("arr:"+arr)
		for (i=1;i<=5;i++) {
			if (eval("kingbtn"+i).enabled==true) {
				eval("kingbtn"+i).enabled=false;
				digits=String(arr.shift());
				trace("digits:"+digits)
				place=i;
				for (k=0;k<digits.length;k++) {  
					n = digits.charAt(k);  h = holder.getNextHighestDepth();
					newmc = holder.attachMovie("dig"+n,"kingdig"+h,h)
					newmc._x=eval("kingbtn"+place)._x-x-(digits.length/2)*15+k*20; newmc._y= eval("kingbtn"+place)._y-y;
				}
		
			}
		}
		
	}
	
	win=winking
	
	} else  {
	trace("**** error")
	}
	
	if (kingcounter==5 || numb==0) {
		setTimeout(endking,4000);
	}

}


function endking() {
win = winking;	
		
var mySound = new Sound;
mySound.attachSound("sndcollect"); // some click sound
mySound.start(0,1);

onEnterFrame = function() {
if (win > 1000) {
t_account+=100;
win-=100;

} else if (win > 100) {
t_account+=10;
win-=10;

} else if  (win <= 100 && win>20) {
t_account+=5;
win-=5;

}  else if (win>0) {
t_account+=1;
win-=1;

} else if (win==0){ delete onEnterFrame; mySound.stop(); 
	kings = new Array();
	holder.removeMovieClip();
	if (firstwin>0 && !auto) {setTimeout(gotto,100,'gamble',1); }
	else {gotoAndStop("main",1); vis(); t_message="You win "+win; setTimeout(endGame, 100); } //Auto Play
}
}
}



		


