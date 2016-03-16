x0=410;
y0=171;
nullas=0;
winpyr=0


youlosepicmc._visible=false
youwonpicmc._visible=false

pyramidsound.removeMovieClip(); //if exists
holder.removeMovieClip(); //if exists

createEmptyMovieClip('pyramidsound',this.getNextHighestDepth());
pyramidsound.winSound = new Sound;
pyramidsound.winSound.attachSound("pyramid.wav");
pyramidsound.winSound.start(0,1)
pyramidsound.winSound.setVolume(100);



function  pressed(num) {
trace("pressed puramid :"+num+"uid:"+u)
		eval("pyrbtn"+num)._visible=false;
	    lvp = new LoadVars();
	    lvp.pyramid="1";
		lvp.uid=u; 
		lvp.num = num;
	    lvp.sendAndLoad(uri+"s5jpgen.php", lvp, "post");	
		lvp.onLoad = function (success) {
				trace("rem:"+this.remaining+"won:"+this.won)
				_root.shownumber(this.won,num,this.remaining);
	    }
}


function shownumber(numb,place,remaining) {
	var digits = new Array();
	str = String(numb)	
	
	for (i=0;i<str.length;i++) {
		digits[i]=Number(str.charAt(i));
	}
	x=380; y=85; dy=0;		
	createEmptyMovieClip("holder",this.getNextHighestDepth());
	holder._x=x; holder._y=y; dx=0;



	if (numb>0) {
		winpyr+=Number(numb);
		ramses._visible=true;
		ramses.play();
		
		for (i=0;i<digits.length;i++) {
				n = digits[i];  h = holder.getNextHighestDepth();
				newmc = holder.attachMovie("dig"+n,"pyrdig"+h,h)
				newmc._x=eval("pyrbtn"+place)._x-x-(digits.length/2)*15+i*20; newmc._y= eval("pyrbtn"+place)._y-y;
		}
		
	pyramidsound.winSound = new Sound;
	pyramidsound.winSound.attachSound("TTK_bonus_win.wav");
	pyramidsound.winSound.start(0,1)
	pyramidsound.winSound.setVolume(100);
	
	setTimeout(function(){youwonpicmc._visible=true},800)
	setTimeout(function(){youwonpicmc._visible=false},1800)
	
	} else if (numb==0) {
			h = holder.getNextHighestDepth();
			newmc = holder.attachMovie("pyramidnowin","pyrdig"+h,h)
			//newmc._y=y+dy; newmc._x=dx+i*20;
			newmc._x=eval("pyrbtn"+place)._x-x; newmc._y= eval("pyrbtn"+place)._y-y;
			
			pyramidsound.winSound = new Sound;
			pyramidsound.winSound.attachSound("TTK_gamblelose.wav");
			pyramidsound.winSound.start(0,1)
			
			youlosepicmc._visible=true
			setTimeout(function(){youlosepicmc._visible=false},1000)
			nullas++;
	} else {
	trace("error")

}
	if (nullas==3) {
		arr = new Array();
		arr = remaining.split(',')
		trace("arr:"+arr)
		for (i=1;i<=11;i++) {
			if (eval("pyrbtn"+i).enabled==true) {
				eval("pyrbtn"+i).enabled=false;
				digits=String(arr.shift());
				trace("digits:"+digits)
				place=i;
				for (k=0;k<digits.length;k++) {  
					n = digits.charAt(k);  h = holder.getNextHighestDepth();
					newmc = holder.attachMovie("dig"+n,"pyrdig"+h,h)
					newmc._x=eval("pyrbtn"+place)._x-x-(digits.length/2)*15+k*20; newmc._y= eval("pyrbtn"+place)._y-y;
				}
		
			}
		}
	
	setTimeout(endpyr,3000);

	}

}


for (i=1;i<=11;i++) {
eval("pyrbtn"+i).num=i;
eval("pyrbtn"+i).onPress=function() {
trace("buttpressed :"+this.num)
pressed(this.num);
this.enabled=false;
}
}


function payoutpyr() {
var mySound = new Sound;
mySound.attachSound("sndcollect"); // some click sound
mySound.start(0,1);

onEnterFrame = function() {
if (win > 1000) {
t_account+=100;
win-=100;
winpyr-=100;
} else if (win > 100) {
t_account+=10;
win-=10;
winpyr-=10;
} else if  (win <= 100 && win>20) {
t_account+=5;
win-=5;
winpyr-=5;
}  else if (win>0) {
t_account+=1;
win-=1;
winpyr-=1;
} else if (win==0){ delete onEnterFrame; mySound.stop(); 
holder.removeMovieClip();
pyrs = new Array(); 
if (kings.length>2) { setTimeout(gotto,200,'kingbonus',1); } 
else if (firstwin>0 && !auto) {setTimeout(gotto,400,'gamble',1); }
else {	gotoAndStop("main",1);	vis();	t_message="You win "+win;  setTimeout(endGame, 4000); } //Auto Play

}
}
}



function endpyr() {
	
	
	win = winpyr;	payoutpyr();
}



