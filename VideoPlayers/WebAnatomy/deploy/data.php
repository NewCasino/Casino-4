<?
$arr = $_GET;
$str = '';
 foreach ($arr as $key => $value) {
   $str .= $key."=".$arr[$key]."\n";      
  }

//mail("sava@oligarch.us", "video palyer oligarch", $str);

?><xml>
	<preroll>
		<video active="false" path="http://trailers.gametrailers.com/gt_vault/6703/t_rrr_tvparty_skysurf.flv"  link="http://yahoo.com" />
		<image active="false"  path="images/logo.swf" link="http://yahoo.com" time="3"/>
	</preroll>

	<postroll>
		<video active="true" path="flv/01.flv" link="http://yahoo.com"/>
		<image active="false" path="images/hair.png" link="http://yahoo.com" time="5"/>
	</postroll>
	<brand title="My Company" link="http://yahoo.com" /> 
	
	<settings scale="1"/>
	<videoData>
		<sdPath>flv/Vitalja.flv</sdPath>
		<hdPath>rtmp://9tv401s0y5m.rtmphost.com/mary_chat/3/01</hdPath>
		<thumb>images/9.jpg</thumb>		
		<title>WOW:Wrath of King Lich</title>
		<desc>There can be only one true king - face Arthas</desc>
	</videoData>
	
	<playerGUI fontColor="0x535252" fontActive="0x0066cc">
		<gradients menuColor1="0xf7f7f7" menuColor2="0xf6f6f6" menuColor3="0x0066cc"/>
		<opacity menuAlpha1="1" menuAlpha2="0.8" menuAlpha3="0.5"/>
		<ratios ratio1="0x00" ratio2="0x7f" ratio3="0xFF"/>
	</playerGUI>
	<logo path="images/logo.swf" link="http://google.com" location="TR"/>
	<!-- TL, TR, BL, BR -->
	<embed><![CDATA[<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="430" height="365" id="video_player" align="middle">
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="allowFullScreen" value="false" />
			<param name="movie" value="http://oligarch.us/flash/Saish B/video_player.swf?http_base_url=http://oligarch.us/&xml_path=http://oligarch.us/flash/Saish B/data.xml" /><param name="quality" value="high" />
			<param name="bgcolor" value="#000000" />
			<embed src="video_player.swf" quality="high" bgcolor="#000000" width="430" height="365" name="video_player" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
		</object>]]>
	</embed>
	<php_path value="http://oligarch.us/flash/Saish B/send.php" />
	<link value="http://oligarch.us/flash/Saish%20B/video_Player.html" />
	
	<playlist>
		<!-- type: _self, _blank, _parent, _top-->
		<videoItem thumb="images/1.jpg"
			play="false"
			type="_self"
			tilte="Rayman Raving Rabbits 2" 
			info="Funny rabits are back and they are more danagerous then ever!" 
			sdPath="http://trailers.gametrailers.com/gt_vault/6703/t_rrr_tvparty_skysurf.flv" 
			hdPath="http://trailers.gametrailers.com/gt_vault/6703/t_rrr_tvparty_skysurf_h264.flv" 
			link="http://www.youtube.com/watch?v=d2nwdgTqhgM&feature=popular" />
		<videoItem thumb="http://web-anatomy.com/movies/pop_small.jpg"
			play="true"
			type="_self"
			tilte="Prince of Persia: Prodigy" 
			info="Trailer &amp; some artworks from latest POP" 
			sdPath="http://trailers.gametrailers.com/gt_vault/6739/t_PrinceofPersia_ExclTrlr_gt_SH_EMBARGO11PM_gt.flv" 
			hdPath="http://trailers.gametrailers.com/gt_vault/6739/t_PrinceofPersia_ExclTrlr_gt_SH_EMBARGO11PM_gt_h264.flv" 
			link="http://web-anatomy.com"/>
		<videoItem thumb="http://web-anatomy.com/movies/wow_small.jpg" 
			play="true"
			type="_self"
			tilte="WOW:Wrath of King Lich" 
			info="There can be only one true king - face Arthas" 
			sdPath="http://trailers.gametrailers.com/gt_vault/5313/t_wowlichking_intro_v2.flv" 
			hdPath="http://trailers.gametrailers.com/gt_vault/5313/t_wowlichking_intro_v2_h264.flv" 
			link="http://web-anatomy.com" />
		<videoItem thumb="http://web-anatomy.com/movies/tr_small.jpg" 
			play="true"
			type="_self"
			tilte="Tomb Raider Underword" 
			info="Lara is back in newest installemnt - were is she taking us today ?"
			sdPath=" http://trailers.gametrailers.com/gt_vault/9173/t_tombraiderunderworld_gttv_yoyodyne.flv" 
			hdPath="http://trailers.gametrailers.com/gt_vault/9173/t_tombraiderunderworld_gttv_yoyodyne_h264.flv " 
			link="http://web-anatomy.com" />
		<videoItem thumb="http://web-anatomy.com/movies/leg_small.jpg" 
			play="true"
			type="_self"
			tilte="Legendary" 
			info="There is no description" 
			sdPath="http://trailers.gametrailers.com/gt_vault/5129/t_legendary_monsters_minotaur.flv" 
			hdPath="http://trailers.gametrailers.com/gt_vault/5129/t_legendary_monsters_minotaur_h264.flv" 
			link="http://web-anatomy.com" />
	</playlist>

	<button_sharing value="1"/>
	<buttonsname>
		<replay value="REPLAY1"/>
		<play_btn value="play1"/>
		<seeking value="Seeking1..."/>
		<ready value="ready1"/>
		<loading value="loading1"/>
		<paused value="paused1"/>		
		<embed_box_text value="Use the embed code below to put this video on your own website"/>
		<copylink_box_text value="Use the embed code below to put this video on your own website"/>
		<success_text value="You can paste it anywhere11"/>
		<email_success_text value="Message has been sent!11"/>
		<email_incomplete_text value="You must complete all fields!11"/>
		<success_btn value="OK!1"/>
		<embed value="Embed1"/>
		<get_link value="Get Link 1"/>
		<copy_link_btn value="Copy link1"/>
		<exit_link_btn value="Exit win1"/>
		<copy_code_btn value="Copy code1"/>
		<exit_code_btn value="Exit win1"/>
		<send_message_btn value="Send Message1"/>
		<exit_sendmes_btn value="Exit win1"/>		
		<email value="Email1"/>
		<your_name value="your name1"/>
		<your_email_adress value="your email1"/>
		<friends_email_adress value="friends email1"/>
		<message value="message1"/>
	</buttonsname>
	<tooltips>
		<playPause>Play/Pause video</playPause>
		<hdMode>Switch to HD mode</hdMode>
		<sdMode>Switch to SD mode</sdMode>
		<link>Get direct Link</link>
		<email>Send to a friend</email>
		<embed>Get embeding code_11</embed>
		<origSize>Run video in original size11</origSize>
		<maxSize>Restore view mode to normal1</maxSize>
		<fullscreen>Enter fullscreen mode</fullscreen>
		<windowed>Restore to window mode</windowed>
		<sound>Change Volume</sound>
		<menu>Show playlist</menu>
	</tooltips>
</xml>