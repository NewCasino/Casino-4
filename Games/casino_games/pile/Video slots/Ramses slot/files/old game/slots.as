

//u="af88jmqq7g9b46mj2e1094r362";  //test

uri=''
//uri = 'http://localhost/gamblersclub/'
scene="main";


////// FUNCTIONS //////	

mntwokind = 6;
mnthreekind = 20;
mnfourkind = 50;
mnfivekind = 100;

buttons_off();

function Init(x,y){  //init wheels
	var i=0;
	var level=20;
	for (i=1; i<=num_wheel; i++){
		mc= this.attachMovie("mc_wheel","wheel"+i,level);
		this["wheel"+i]._xscale=100; // =40
		this["wheel"+i]._yscale=100;
		this["wheel"+i]._x=x;
		this["wheel"+i]._y=y;	
		this["wheel"+i].setMask(this["mask"+i]);
		x+=145; // = 65
		level+=2;
	}
	attachlinesframes();
	nonviswinlines();
}


function attachlinesframes() {
for (var i=1;i<=20;i++) {
attachMovie("l"+i,"line"+i,500+i);
eval("line"+i)._y=80;

var col = int((i-1) / 3);
var row = (i-1) % 3;
attachMovie('winframe',"wf"+i,i+5000);

eval("wf"+i)._x=postopleft._x+col*145;
eval("wf"+i)._y = postopleft._y + 125*row;

}
}

function dolines(linenum) {
var i;
nonviswinlines() 
for (i=1;i<=linenum;i++)  {
eval("line"+i)._visible=true
}
}

function hidelinebuttons() {
for (i=1;i<=20;i++)  {
eval("l"+i+"btn").enabled = false;
}
}

function enablelinebuttons() {
for (i=1;i<=20;i++)  {
eval("l"+i+"btn").enabled = true;
}
}


function nonviswinframes() {
var i;
for (i=1; i<=20; i++){
 eval("wf"+i)._visible=false;
}
}



function nonviswinlines() {
var i;
for (i=1; i<=20; i++){
eval("line"+i)._visible=false;
 eval("wf"+i)._visible=false;
}
}

function removelines() {
var i;
for (i=1;i<=20;i++) {eval("line"+i)._visible=false;  eval("wf"+i)._visible=false; }
}


function nonvis() {
nonviswinlines();
//for (i=1;i<=20;i++) {eval("w"+i)._visible=false;}

for (i=1; i<=num_wheel; i++){
this["wheel"+i]._visible=false;
}
for (i=1; i<=20; i++){
eval("wf"+i)._visible=false;
eval('line'+i)._visible=false;
}

}

function vis() {
trace("vis()")
var i;

for (i=1; i<=num_wheel; i++){
this["wheel"+i]._visible=true;
this["wheel"+i].setMask(this["mask"+i]);
}

/*
for (i=1; i<=35; i++){
eval("wf"+i)._visible=true;
eval('line'+i)._visible=true;
}
*/

if (!auto) {helpbtn._visible=true; }
}





function countpyrkingvalues(val) {
var pyramids = new Array(); 
for (k=0;k<=15;k++) { 
myvar = lv["n"+k]; 
if (myvar == val) pyramids.push(k);  
}  //count pyramids

return pyramids;
}
	


function selectsybyvalue(val) {
for (i=1;i<=20;i++) {
if (lv.eval("n"+i) == val) {
this["wf"+i]._visible=true;
}
}
}
	

//
function Generator(){
	var n=0;
	var res=Math.round(Math.random()*140);
	if( res<=10 ){ n=1; }
	else if( (res>10)&&(res<=20) ){ n=2; }
	else if( (res>20)&&(res<=30) ){ n=3; }
	else if( (res>30)&&(res<=40) ){ n=4; }
	else if( (res>40)&&(res<=50) ){ n=5; }
	else if( (res>50)&&(res<=60) ){ n=6; }
	else if( (res>60)&&(res<=70) ){ n=7; }
	else if( (res>70)&&(res<=80) ){ n=8; }
	else if( (res>80)&&(res<=90) ){ n=9; }
	else if( (res>90)&&(res<=100) ){ n=10; }
	else if( (res>100)&&(res<=110) ){ n=11; }
	else if( (res>110)&&(res<=120) ){ n=12; }
	else if( (res>120)&&(res<=130) ){ n=13; }
	else if( (res>130)&&(res<=140) ){ n=14; }
	return n;
}
//
function endGame() {
roll=false;
if (freespins > 0) _root.icontype="bsy"; else _root.icontype="sy";

trace("func endGame()*** "+freespins)
	if (pyrs.length>2) {
		setTimeout(gotto,4000,'pyramid',1);
	} else if (kings.length>2) {
		createEmptyMovieClip('kingsound',this.getNextHighestDepth());
		kingsound.winSound = new Sound;
		kingsound.winSound.attachSound("TTK_king.wav");
		kingsound.winSound.start(0,1)
		kingsound.winSound.setVolume(100);
		selectsybyvalue(11);
		setTimeout(gotto,4000,'kingbonus',1);
	}  else if (gamble && !auto) {
		 setTimeout(gotto,4000,'gamble',1); 
	} else if (freespins>0) {
		setTimeout(Spin,3000);
	} else if (auto){
			if (win) {
				lvc = new LoadVars;
				lvc.gamble="1";
				lvc.collect="1";
				lvc.uid=u;
				lvc.sendAndLoad(uri+"s5jpgen.php", lvc, "post");	
				lvc.onData = function(raw) {
				setTimeout(payout,2000);
				payoutdone=false;
				ttt = setInterval(function(){ if (payoutdone==true) {clearInterval(ttt);Spin(); }},200  )
				}
			}	else {setTimeout(Spin,2000);}
	} else {
			buttons_on();
	}
}				

function countResult(){
trace("func countResult()*********************** ")
gamble=0; //init;
firstwin = win=Number(lv.wn);
t_account=Number(lv.ub); 
t_message="You win "+win;
if (freespins && lv.slottype ne 'freespin')  {winall+=win; firstwin =winall;}
if (win && !freespins) gamble=1;
if (freespins) { freespins-- ; if (freespins==0) { if (winall>0) { gamble=1} } }
if (lv.slottype eq 'freespin') {slottype='freespin'; freespins=10; winall=0; } else {slottype=''; }


spinSound.stop();
countResultCo();
trace("win:"+win+" winall"+ winall)				
var h = showresult();
setTimeout(function() { 
if (freespins && slottype ne 'freespin') { win=winall; }
if (freespins) { t_message= "You have  "+ freespins + " BONUS spins"; }
endGame();
},h*500);
}



auto_off.onPress=function(){  // Turn On Auto Play
	for (i=1;i<=20;i++) {	eval("line"+i)._visible=false;	}
	

	var mySound = new Sound;
	mySound.attachSound("click");
	mySound.start(0,1);
	mySound.setVolume(100);
	
	if(bet&&!roll){ 
		if(t_account<bet){
			t_message="Insufficient Funds"; 
		}else{
			auto=true;
			auto_on._visible = true;
			auto_off._visible = false;
			Spin();
			buttons_off();
		}
	}
}
auto_on.onPress=function(){  // Turn Off Auto Play
	auto=false;
	//auto_off._visible = true;
	auto_on._visible = false;
	var mySound = new Sound;
	mySound.attachSound("click");
	mySound.start(0,1);
	mySound.setVolume(100);
	
}

//
function countLine(a, b, c, line){
	if( (a==b)&&(b==c)&&(a!=6) ){
		if(a==1){ // 7 7 7
			switch(line){
				case "1": 
				//info1.Light(11); 
				return 1; break;
				case "2": 
				//info1.Light(12); 
				return 1;
				break;
				case "3": 
				//info1.Light(13); 
				return 1;
				break;
				case "4": //info1.Light(14); 
				return 1; 
				break;
				case "5": 
				//info1.Light(15); 
				return 1; break;
			}
		}else{
			switch (a){
				case "2": //info2.Light(1); 
				break;
				case "3": //info2.Light(2); 
				break;
				case "4": //info2.Light(3); 
				break;
				case "5": //info2.Light(4); 
				break;
			}
		}
	}else{
		if ((a>2)&&(a<6)&&(b>2)&&(b<6)&&(c>2)&&(c<6)){ 
		//info2.Light(5) 
		} //Any Bar
	}
}

function evalline(d1,d2,d3,d4,d5,k) {
var result=0; var win=0; 
var s1 =  eval("lv.n"+d1);
var s2 =  eval("lv.n"+d2);
var s3 =  eval("lv.n"+d3);
var s4 =  eval("lv.n"+d4);
var s5 =  eval("lv.n"+d5);

if (s1!=10 && s1 != 11 && s1 != 13) {
if (lv.n4 == 2 || lv.n5==2 || lv.n6==2) {s2 = s1; } //on  pos 2 a joker 
if (lv.n7 == 2 || lv.n8==2 || lv.n9==2) {s3 = s2; } //on  pos 3 a joker 
if (lv.n10 == 2 || lv.n11==2 || lv.n12==2) {s4 = s3; } //on  pos 4 a joker 
}

//trace("evalline s1:"+s1+"s2:"+s2+"s3:"+s3+"s4"+s4+"s5:"+s5+" k:"+k+"lv.n1:"+lv.n1)

if (s1 == s2) {result = 2;  } 
if (s1 == s2 && s2 == s3) {result = 3; } 
if (s1 == s2 && s2 == s3 && s3 == s4) {result = 4; } 
if (s1 == s2 && s2 == s3 && s3 == s4 && s4==s5) {result = 5; } 

if ((s2==5 && s3==5 && s4==5) || (s2==5 && s3==5 && s5==5)  || (s2==5 && s4==5 && s5==5) || (s3==5 && s4==5 && s5==5)) {
result = 9;
for (i=1;i<=5;i++) { if (eval("s"+i) != 5) { if (i==1) s1 = 0; else if (i==2) s2=0; else if (i==3) s3 = 0; else if (i==4) s4 = 0;  else if (i==5) s5 = 0;    }}
}


if (!result) return false;

if (result !=9) {
//set joker ,  no joker by pyramid or king
if (s1!=10 && s1 != 11) 
for (i=result+1;i<=5;i++) { trace("i:"+i); if (i==3 && s3==2) {  result++ ; s3= s1; }  else if (i==4 && s4==2) {  result++ ; s4= s1; }  else if (i==5 && s5==2) {  result++ ; s5 = s1; }    else break; } 
//the other values 0
for (i=result+1;i<=5;i++) { if (i==3) s3=0; else if (i==4) s4=0; else if (i==5) s5=0;    }
}

var paytable= new Array();



paytable[88888] = 15000;

paytable[88888] = 15000;
paytable[88880] = 2000;
paytable[88800] = 100;
paytable[88000] = 10;

paytable[99999] = 2000;
paytable[99990] = 500;
paytable[99900] = 10;
paytable[99000] = 2;

paytable[77777] = 1000;
paytable[77770] = 500;
paytable[77700] = 500;

paytable[55555] = 100;
paytable[55550] = 50;
paytable[55500] = 5;

paytable[11111] = 500;
paytable[11110] = 100;
paytable[11100] = 10;

//3,4,6,12,14 -->
paytable[33333] = 100;
paytable[33330] = 25;
paytable[33300] = 5;

paytable[44444] = 100;
paytable[44440] = 25;
paytable[44400] = 5;

paytable[66666] = 100;
paytable[66660] = 25;
paytable[66600] = 5;

paytable[1212121212] = 100;
paytable[121212120] = 25;
paytable[12121200] = 5;

paytable[1414141414] = 100;
paytable[141414140] = 25;
paytable[14141400] = 5;


paytable[55555] = 100;

paytable[55550] = 50;
paytable[55505] = 50;
paytable[55055] = 50;
paytable[50555] = 50;
paytable[05555] = 50;

paytable[55500] = 5;
paytable[55050] = 5;
paytable[55005] = 5;

paytable[50550] = 5;
paytable[50505] = 5;
paytable[50055] = 5;

paytable['x'+5550] = 5;
paytable['x'+5505] = 5;
paytable['x'+5055] = 5;


if (s1==0) s1='x';
win = paytable[s1+s2+s3+s4+s5];
trace("result:"+" s1-5:"+s1+s2+s3+s4+s5)

if (win>0) {
trace(" ok k: "+k+"result:"+result+"twin:"+win)
results.push(k+"|"+result+"|"+d1+"|"+d2+"|"+d3+"|"+d4+"|"+d5);
}

}

function countResultCo(){
trace("  countResultCo")
results = new Array();

if (lines>0)  evalline(2,5,8,11,14,1);  //payline1
if (lines>1)  evalline(1,4,7,10,13,2);  //payline2
if (lines>2)  evalline(3,6,9,12,15,3);  //payline3
if (lines>3)  evalline(1,5,9,11,12,4);  //payline4
if (lines>4)  evalline(3,5,7,11,15,5);  //payline5
if (lines>5)  evalline(1,4,8,11,13,6);  //payline6
if (lines>6)  evalline(3,6,8,12,15,7);  //payline7
if (lines>7)  evalline(2,4,7,10,14,8);  //payline8
if (lines>8)  evalline(2,6,9,12,14,9);  //payline9
if (lines>9)  evalline(1,4,8,12,15,10);  //payline10
if (lines>10)  evalline(3,6,8,10,13,11);  //payline11
if (lines>11)  evalline(1,5,8,11,13,12);  //payline12
if (lines>12)  evalline(3,5,8,11,15,13);  //payline13
if (lines>13)  evalline(2,5,7,11,14,14);  //payline14
if (lines>14)  evalline(2,5,9,11,14,15);  //payline15
if (lines>15)  evalline(2,4,8,10,14,16);  //payline16
if (lines>16)  evalline(2,6,8,12,14,17);  //payline17
if (lines>17)  evalline(1,5,7,11,13,18);  //payline18
if (lines>18)  evalline(3,5,9,11,15,19);  //payline19
if (lines>19)  evalline(3,4,9,10,15,20);  //payline20

}




function  showresult() {
var i,k,c,j,f;

trace(" function  showresult() results.length:"+results.length);

if (results.length) {
	for (i=0;i<results.length;i++) {
		setTimeout(winsoundplay,i*500,i)
	}
	
}

k=i; k++;

pyrs = new Array();
pyrs = countpyrkingvalues(10);

if (pyrs.length>2) {
setTimeout(function() {
//trace("winframe pyr:"+pyrs.length)
	for (i=0;i<pyrs.length;i++) {
		g=pyrs[i];
		//trace("pyr g:"+g)
		eval("wf"+g)._visible=true;
		//trace("pyr x:"+eval("wf"+g)._x+" y:"+eval("wf"+g)._y)
		//eval("wf"+g).onPress=function() { trace("wf:"+this.name)}
	}

},k*500);
k++;
}



kings = new Array();
kings = countpyrkingvalues(11);

if (kings.length>2) {
setTimeout(function() {
//trace("winframe king:"+kings.length)
	for (var i=0;i<kings.length;i++) {
		g=kings[i];
		eval("wf"+g)._visible=true;
	}

},k*500);
k++;
}



freespi = new Array();
freespi = countpyrkingvalues(13);

if (freespi.length>2) {
setTimeout(function() {
	for (var i=0;i<freespi.length;i++) {
		g=freespi[i];
		eval("wf"+g)._visible=true;
	}

	createEmptyMovieClip('freespinsound',this.getNextHighestDepth());
	freespinsound.winSound = new Sound;
	freespinsound.winSound.attachSound("TTK_bonus.wav");
	freespinsound.winSound.start(0,1)
	freespinsound.winSound.setVolume(100);
	

},k*500);
}


return k;

}

function winsoundplay(kk) {

	var res = new Array();
	trace("results.len: "+results.length+"lins:"+lines);

	nonviswinframes();

	res = results[kk].split('|');
	var k = Number(res[0]); var j = Number(res[1]);

	//trace("test"+lv.n4)

	if (j != 9) {
		var winSound = new Sound;
		winSound.attachSound("sndwin");
		winSound.start(0,1)
	} else {	
		var winSound = new Sound;
		winSound.attachSound("TTK_scatterwin.wav");
		winSound.start(0,1)
	}
	
	

	eval("line"+k)._visible=true;
		
	//trace("winsound res"+res+" j:"+j+"k:"+k)
	
	firstsy = lv["n"+res[2]]; var counter=0;
	for (var f=1;f<=j;f++) {
		//trace("winframe j:"+j)
		var g = res[1+f];
		eval("wf"+g)._visible=true;
		if (f>1 && firstsy != res[1+f] && f<5) {
		var ch= 0;
		var num = 1+(f-1)*3; if (lv["n"+num]==2) {ch=num;} 	var num = 2+(f-1)*3; if (lv["n"+num]==2) {ch=num;} var num = 3+(f-1)*3; if (lv["n"+num]==2) {ch=num;} 
		if (ch>0) {
		//trace("jokerchange jokerpos" + ch+" change what:"+g)
			counter++;
			var nn = g+k*10; if (_root.freespins > 0) icontype="bsy"; else icontype="sy";
			attachMovie(icontype+firstsy,'s'+nn,100+counter)
			eval('s'+nn)._x=eval("wf"+g)._x+60;	eval('s'+nn)._y = eval("wf"+g)._y+60;
			setTimeout(function(mc) {mc.removeMovieClip()} ,800,eval('s'+nn))
			//trace("sn.x: "+eval('s'+nn)._x+" wf.x:"+eval("wf"+g)._x+" typ:"+typeof(eval('s'+nn)))
			}

		}
	}
	
}


function gotto(par1,par2) {
if (par1 eq 'gamble') gotoAndStop('gamble',par2);
else if (par1 eq 'pyramid') gotoAndStop('pyramid',par2);
else if (par1 eq 'kingbonus') gotoAndStop('kingbonus',par2);
nonvis();
}


		
//
function Stop(stage){
trace("Stop() "+stage)
	if(stage==1){
		wheel1.StopD(lv.n1, lv.n2, lv.n3);
		setTimeout(Stop,500,2);
	}
	else if(stage==2){
		wheel2.StopD(lv.n4, lv.n5, lv.n6);
		setTimeout(Stop,500,3);

	}
	else if(stage==3){

		wheel3.StopD(lv.n7, lv.n8, lv.n9);
		setTimeout(Stop,500,4);

	}
	else if(stage==4){

		wheel4.StopD(lv.n10, lv.n11, lv.n12);
		setTimeout(Stop,500,5);

	}
	else if(stage==5){
		wheel5.StopD(lv.n13, lv.n14, lv.n15);
		countResult();
	}
}
//
function Roll(){
var i;
	removelines();
	ramses.play();
	var i=0;
	for (i=1; i<=num_wheel; i++){
		_root["wheel"+i].Rotate();
	}
}
//
function Spin(){
trace(" spin() ")
	spinSound = new Sound;
	spinSound.attachSound("TTK_spin.wav"); // some click sound
	spinSound.start(0,100);
	spinSound.setVolume(100);
			
	roll=true;
	if (freespins == 0) {
		t_account-=bet;
	}
	t_message="Spinning...";
	Roll(); 
	lv.b=bet;
	lv.l=betcc;
	lv.c=lines;
	lv.uid=u;
	if (freespins) {lv.freespins=1;} else {lv.freespins=0;}
	trace("--> bet:"+bet+" betcc:"+betcc+"lines:"+lines)
	lv.sendAndLoad(uri+"s5jpgen.php", lv, "post");
	
}

function buttons_off() {
	b_1._visible = false;
	b_1.enabled = false;
	b_3._visible = false;
	b_3.enabled = false;
	b_spin._visible = false;
	c_val_down._visible = false;
	c_val_down.enabled = false;
	c_val_up._visible = false;
	c_val_up.enabled = false;
	helpbtn._visible=false
	auto_off._visible=false;
	auto_on._visible=true; 
	
	hidelinebuttons()
}


function buttons_on() {
	b_1._visible = true;
	b_1.enabled = true;
	b_3._visible = true;
	b_3.enabled = true;
	b_spin._visible = true;
	b_spin.enabled = true;
	c_val_down._visible = true;
	c_val_down.enabled = true;
	c_val_up._visible = true;
	c_val_up.enabled = true;
	auto_off._visible=true;  
	auto_on._visible=false; 
	helpbtn._visible=true
	
	enablelinebuttons();
		
}


////// HADLERS //////
lv=new LoadVars();
lv.onLoad=function(){
	if(lv.ans=="res"){
		trace("loadvars")
			trace("okokok lv.onLoad")
		/*	
			
		ub=4981.00
		lv.wn=100
		lv.n1=8
		lv.n2=3
		lv.n3=1
		lv.n4=8
		lv.n5=3
		lv.n6=1
		lv.n7=1
		lv.n8=3
		lv.n9=1
		lv.n10=14
		lv.n11=2
		lv.n12=2
		lv.n13=12
		lv.n14=12
		lv.n15=1
		lv.jp=68.70
		
	*/

		
		setTimeout(Stop,2000,1);
		//intr_S=setInterval(Stop,2000,1);
	}	else{
	//test
	

		
		/*
		//intr_S=setInterval(Stop,2000,1);
		setTimeout(Stop, 2000);
		
	
		wheel1.Stop();
		wheel2.Stop();
		wheel3.Stop();
		wheel4.Stop();
		wheel5.Stop();
		t_message="Server error";
		setTimeout(endGame, 2000);
		//intr_E=setInterval(endGame, 2000);	
		*/
		t_message="Server error";
	
	}
}
b_spin.onPress=function(){
trace("bet:"+bet +" rll:"+roll)
	if(bet&&!roll){ 
		if(t_account<bet){
			t_message="Insufficient Funds"; 
		}else{
			for (i=1;i<=20;i++) {	eval("line"+i)._visible=false;	}
			var mySound = new Sound;
			mySound.attachSound("TTK_lever.wav"); // some click sound
			mySound.start(0,1);
			mySound.setVolume(100);
			auto_off._visible = false;
			auto_on._visible = false;
			Spin();
			buttons_off();
			removelines();
			hidelinebuttons();
		}
	}
}

/*
b_spin.onRollOver=function(){ if(bet&&!roll){ mc_spin.gotoAndStop(2); } }
b_spin.onRollOut=function(){ mc_spin.gotoAndStop(1); }
*/

// Increase chip value
c_val_up.onPress=function(){ 
	if(!roll){ //if the game it not running
	var mySound = new Sound;
	mySound.attachSound("TTK_bet.wav"); // some click sound
	mySound.start(0,1);
	// Decrease chip value and text value on the game screen
	//t_val=c_val++; 
	lines++;
	if (lines == 21) {lines = 0;for (i=1;i<=20;i++) {	eval("line"+i)._visible=false;	}	}
	
	t_val = c_val= lines* 0.25;
	dolines(lines);

		bet=lines*betcc;
	}
}
//


// Decrease chip value
c_val_down.onPress=function(){
	if(!roll){
	var mySound = new Sound;
	mySound.attachSound("click");
	mySound.start(0,1);
		if (c_val==5) {
			c_val_up._visible = true;
			c_val=1;
			t_val="L1";
		} else if (c_val==1) {
			c_val=0.50;
			t_val="50p";
		} else if (c_val==0.50) {
			c_val=0.25;
			t_val="25p";
		} else if (c_val==0.25) {
			c_val=0.05;
			t_val="5p";
			this._visible = false;
		}
	bet=lines*betcc;
	}
}

// Bet one function
b_1.onPress=function(){
	if(!roll){
	var mySound = new Sound;
	mySound.attachSound("TTK_bet.wav"); // some click sound
	mySound.start(0,1);
		if ((betcc==0)||(betcc==10)){
			betcc=1;
			bet=lines*betcc;
			b_3._visible = true;
			b_spin._visible = true;
		}else {
			betcc++;
			bet=lines*betcc;
		}
	}
}

// Bet Max
b_3.onPress=function(){
	dolines(20); 
	lines=20;
	if(!roll){
	var mySound = new Sound;
	mySound.attachSound("TTK_bet.wav"); // some click sound
	mySound.start(0,1);
		betcc=10;
		bet=lines*betcc;
		b_spin._visible = true;
	}
}

helpbtn.onPress=function() {
gotoAndStop("help",1)

}


function payout() {
var mySound = new Sound;
mySound.attachSound("sndcollect"); // some click sound
mySound.start(0,1);
payoutdone=false; 

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
} else if (win==0){ delete onEnterFrame; mySound.stop(); payoutdone=true; }
}
}

////// MAIN //////
c_val = 0.25; // value of coin
t_val = "25p";
if (!betcc) betcc=0;
if (!bet) bet=0;
if (!t_message) t_message="Drop a coin";
if (!t_jackpot) t_jackpot="JACKPOT";
if (!lines)  lines=0;

if (!win) win=0;
roll=false;
num_wheel=5;
if (!constructed)  {
slottype="";
winall=0;
win=0;
w1_mask.swapDepths(101);
w2_mask.swapDepths(102);
w3_mask.swapDepths(103);
w4_mask.swapDepths(104);
w5_mask.swapDepths(105);
Init(110, 230);
auto=false;
auto_on._visible = false;


freespins=0;
constructed=1
buttons_on();
lines=0
}

for (i=1;i<=20;i++)  {
eval("l"+i+"btn").val=i;
eval("l"+i+"btn").onPress = function() {
trace(" btnb"+this.val)
lines=this.val;
dolines(lines)
}
}



stop();


