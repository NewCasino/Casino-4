nonvis();
scene="help"

e1btn.onPress = function() {
	exittomain()
}

r1btn.onPress = function() {
	gotoAndStop(2);
}

function exittomain() {
gotoAndStop("main",1);
vis();
helpint = setInterval(function() { if (scene eq "main") {clearInterval(helpint);  if (!roll) { buttons_on(); }  } },200);
}

/*
e2btn.onPress = function() {
	gotoAndStop("main",1);
}

r2btn.onPress = function() {
trace("r2btn")
	gotoAndStop(3);
}

l2btn.onPress = function() {
	gotoAndStop(1);
}


e3btn.onPress = function() {
	gotoAndStop("main",1);
}

r3btn.onPress = function() {
	gotoAndStop(4);
}

l3btn.onPress = function() {
	gotoAndStop(2);
}

e4btn.onPress = function() {
	gotoAndStop("main",1);
}

r4btn.onPress = function() {
	gotoAndStop(5);
}

l4btn.onPress = function() {
	gotoAndStop(3);
}

e5btn.onPress = function() {
	gotoAndStop("main",1);
}


l5btn.onPress = function() {
	gotoAndStop(4);
}

*/
