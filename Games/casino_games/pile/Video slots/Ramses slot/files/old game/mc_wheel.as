#initclip



function Wheel(){ 
	this.cell1=0;
	this.cell2=0;
	this.cell3=0;
	_root.icontype="sy";


	this.newSymbol(); 
}
Wheel.prototype=new MovieClip();
//
Wheel.prototype.newSymbol=function(){ // Initial draw


	var n=_root.Generator();
	this.attachMovie(_root.icontype+n,"sym1",1);
	this.sym1._xscale=100;
	this.sym1._yscale=100;
	this.sym1._x=0;
	this.sym1._y=-80;

	n=_root.Generator();
	this.cell1=n;
	this.attachMovie(_root.icontype+n,"sym2",2);
	this.sym2._xscale=100;
	this.sym2._yscale=100;
	this.sym2._x=0;
	this.sym2._y=40;
	

	n=_root.Generator();
	this.cell2=n;
	this.attachMovie(_root.icontype+n,"sym3",3);
	this.sym3._x=0;
	this.sym3._y=165;

	var n=_root.Generator();
	this.cell3=n;
	mc= this.attachMovie(_root.icontype+n,"sym4",4);
	this.sym4._x=0;
	this.sym4._y=-220;
	trace("mc:"+mc)

}

Wheel.prototype.newSymbolD=function(a, b, c){


	this.attachMovie(_root.icontype+a,"sym1",1);
	this.sym1._x=0;
	this.sym1._y=-80;

	
	this.attachMovie(_root.icontype+b,"sym2",2);
	this.sym2._x=0;
	this.sym2._y=40;
	
	
	this.attachMovie(_root.icontype+c,"sym3",3);
	this.sym3._x=0;
	this.sym3._y=165;


	this.sym4.removeMovieClip();
}

Wheel.prototype.Clear=function(){
	this.sym1.removeMovieClip();
	this.sym2.removeMovieClip();
	this.sym3.removeMovieClip();
	this.sym4.removeMovieClip();
	this.sym5.removeMovieClip();
}


function spin_reel(ix)
{

    removeMovieClip (obj[ix * 4 + 4]);
    move_obj = _root[obj[ix * 4 + 3]];
    new mx.transitions.Tween(move_obj, "_y", mx.transitions.easing.Bounce.easeOut, 300, 400, 5, false);
    move_obj = _root[obj[ix * 4 + 2]];
    new mx.transitions.Tween(move_obj, "_y", mx.transitions.easing.Bounce.easeOut, 200, 300, 5, false);
    move_obj = _root[obj[ix * 4 + 1]];
    new mx.transitions.Tween(move_obj, "_y", mx.transitions.easing.Bounce.easeOut, 100, 200, 5, false);
    obj[ix * 4 + 4] = obj[ix * 4 + 3];
    reel[ix * 4 + 4] = reel[ix * 4 + 3];
    obj[ix * 4 + 3] = obj[ix * 4 + 2];
    reel[ix * 4 + 3] = reel[ix * 4 + 2];
    obj[ix * 4 + 2] = obj[ix * 4 + 1];
    reel[ix * 4 + 2] = reel[ix * 4 + 1];
    haal_nieuw_object();
    _root.attachMovie("clip" + nr, "o" + objectnummer, _root.getNextHighestDepth());
    obj[ix * 4 + 1] = "o" + objectnummer;
    reel[ix * 4 + 1] = nr;
    new_obj = _root[obj[ix * 4 + 1]];
    new_obj.swapDepths(frame);
    new_obj._x = ix * 100 + 50;
    new mx.transitions.Tween(new_obj, "_y", mx.transitions.easing.Bounce.easeOut, 0, 100, 5, false);
    ++objectnummer;
} // End of the function




Wheel.prototype.Move = function(pthis, speed){
//trace("move()")

	if (!this.sym4) {
		var n=_root.Generator();
		this.attachMovie(_root.icontype+n,"sym4",4);
		this.sym4._x=0;
		this.sym4._y=-230;
	}
	
	
	var i=0;
	var item=0;
	var n=0;
	for(i=1; i<5; i++){
		item=pthis["sym"+i];
		item._y+=50;

		if(item._y>270) {
			n=_root.Generator();
			pthis.attachMovie(_root.icontype+n,"sym"+i,i);
			pthis["sym"+i]._x=0;
			pthis["sym"+i]._y=-250;
		}
	}
}


//
Wheel.prototype.Rotate=function(){
this.onEnterFrame= function() {
//trace("omomo")
this.Move(this, 125)
}
	//this.intr_m=setInterval(this.Move, 5, this, 125);
}
//
Wheel.prototype.Stop=function(){
	//clearInterval(this.intr_m);
	delete this.onEnterFrame;
	this.newSymbol();
}
//
Wheel.prototype.StopD=function(a, b, c){
	//clearInterval(this.intr_m);
	trace("StopD=function a:"+a+" b:"+b+" c:"+c)
	delete this.onEnterFrame;
	this.newSymbolD(a, b, c);
	mSound = new Sound;
	mSound.attachSound("TTK_stop5.wav"); 
	mSound.start(0,1);
}
//
Object.registerClass("mc_wheel", Wheel);
#endinitclip
