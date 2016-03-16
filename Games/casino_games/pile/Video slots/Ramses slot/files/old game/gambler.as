stop()

trace(" gambler ***" )

createEmptyMovieClip("gamblesound",this.getNextHighestDepth())
gamblesound.mySound = new Sound;
gamblesound.mySound.attachSound("TTK_gamblebackground.wav"); // some click sound
gamblesound.mySound.start(0,1000);



win = firstwin;  //dont mix with pyramid win

blackbmc._visible= false;
enabledcardclick=false;
halfbmc._visible=false
collectbmc._visible=false
chosencolor=undefined
halfbtn._visible=true
collectbtn.enabled=true;

g1btn.enabled= g2btn.enabled= g3btn.enabled= g4btn.enabled= g5btn.enabled = false;

cardsclicked = 0;

wintext1="2x win"; wintext2="3x win"; win1=win*2; win2=win*3; 

function dobuttons() {

if (blackbmc._visible==false) {
redbmc._visible=false;
blackbmc._visible=true;
} else {
redbmc._visible=true;
blackbmc._visible=false;
}

if (cardsclicked==5) {  //won all 5 card
removecards();
gotoAndStop("main",1);
vis();
t_message="You win "+win
}

}

s1 = setInterval(dobuttons,500);

blackbtn.onPress= function() {
blackbmc._visible=true;
redbmc._visible=false;
blackbtn._visible=false
redbtn._visible=false
chosencolor=0
halfbmc._visible=false
enabledcardclick=true;
g1btn.enabled= g2btn.enabled= g3btn.enabled= g4btn.enabled= g5btn.enabled = true;
clearInterval(s1);
}

redbtn.onPress= function() {
blackbmc._visible=false;
redbmc._visible=true;
blackbtn._visible=false
redbtn._visible=false
chosencolor=1
halfbmc._visible=false
enabledcardclick=true;
g1btn.enabled= g2btn.enabled= g3btn.enabled= g4btn.enabled= g5btn.enabled = true;
clearInterval(s1);
}

halfbtn.onPress= function() {
halfbmc._visible=true
lvh.gamble="1";
lvh.halfamount="1";
lvh.uid=u;
collectbmc._visible=true;
win0=win;
if (win0==1) {collectpress(); return;}
win = Math.round(win/2);
t_account+= (win0-Math.round(win/2));
lvh.sendAndLoad(uri+"s5jpgen.php", lvh, "post");	
lvh.onData = function(raw) {
collectbmc._visible=false
}
}

collectbtn.onPress= function() {
this.enabled= false;
collectpress();
}



function collectpress() {
clearInterval(s1);
lvg.gamble="1";
lvg.collect="1";
lvg.uid=u;
collectbmc._visible=true
lvg.sendAndLoad(uri+"s5jpgen.php", lvg, "post");	
lvg.onData = function(raw) {
collectbmc._visible=false
}
payout();
cll1 = setInterval(function() {if (payoutdone) {clearInterval(cll1); endgamble();} },200)
}

function removecards() {
for (i=1;i<=5;i++) {
eval('card'+i).removeMovieClip()
}
}

for (i=1;i<=5;i++) {
eval("g"+i+"btn").num=i;
eval("g"+i+"btn").onPress=function() {

trace("num:"+this.num+"enabl:"+enabledcardclick)
if (!enabledcardclick) return
cardsclicked++;
g1btn.enabled= g2btn.enabled= g3btn.enabled= g4btn.enabled= g5btn.enabled = false;
enabledcardclick=false;
lvg= new LoadVars;
lvg.gamble="1";
lvg.half="1";
lvg.uid=u;
lvg.num=this.num
lvg.chosencolor=chosencolor; 
lvg.sendAndLoad(uri+"s5jpgen.php", lvg, "post");
lvg.onData = function(raw) {
trace("ondata raw:"+raw)
if (raw eq 'won') {
if (chosencolor==1) mc = _root.attachMovie('redcard','card'+this.num,_root.getNextHighestDepth()); 
else mc = _root.attachMovie('blackcard','card'+this.num,_root.getNextHighestDepth()); 
trace(this._parent.num+" *"+_parent.num+" this"+this+" num:"+this.num)
mc._y=354; mc._x=80+(this.num-1)*160;
mySound = new Sound;
mySound.attachSound("TTK_gamblewin.wav"); // some click sound
mySound.start(0,1);
s1 = setInterval(dobuttons,500);
blackbtn._visible=true; redbtn._visible=true; collectbtn.enabled=true;
win= win*2; wintext1="3x win";wintext2="4x win";win1=win*3;win2=win*4;
eval("g"+this.num+"btn")._visible=false;
} else if (raw eq 'lose') {
if (chosencolor==0) mc = _root.attachMovie('redcard','card'+this.num,_root.getNextHighestDepth()); 
else mc = _root.attachMovie('blackcard','card'+this.num,_root.getNextHighestDepth()); 
trace(this._parent.num+" *"+_parent.num+" this"+this+" num:"+this.num)
mc._y=354; mc._x=80+(this.num-1)*160;
mySound = new Sound;
mySound.attachSound("TTK_gamblelose.wav"); // some click sound
mySound.start(0,1);
win=0;
setTimeout(endgamble,3000);
}
}

}

}


function endgamble() {
gamblesound.mySound.stop();
removeMovieClip("gamblesound")
removecards();
t_message="You win "+win
gotoAndStop("main",1);
//if (!auto && !freespins) b_spin._visible = true;
vis();
gamble=0;
if (auto) setTimeout(endGame,3000); else setTimeout(endGame,300);
}
	
