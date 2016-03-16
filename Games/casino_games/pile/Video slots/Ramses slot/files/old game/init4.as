lv=new LoadVars();
lv.onLoad=function(){
	if(lv.rbl=="valid"){
		t_account=lv.bln;
		u=lv.uid;
		nextScene();
	}
	else{ 
	nextScene();
		getURL("../login.php"); 
	}
}
lv.uid=u;
lv.sendAndLoad("init.php",lv,"post");
stop();