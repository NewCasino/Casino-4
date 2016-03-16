insert into transactions set userid=1, gameid=1, amount=5000, type="53" ;
insert into jackpot set type=53, amount=25;
insert into users values (1,"test",'tlast','test','test',1,0,'mail','ip','ch','ctr','state','zip','phone','addr',212312212,3223232)
 
insert into transactions set userid=1, gameid=1, amount=15000, type="53" ; 

drop table pyramid;
create table pyramid (
id int  auto_increment,
gameid int default Null,
type int default Null,
winarr varchar(255)  default Null,
selectablearr varchar(255)  default Null,
uid int default Null,
won int default 0,
date int default Null,
nulls int default 0,
counter  int default 0,
PRIMARY KEY	 id (id)
);


drop table kingbonus;
create table  kingbonus (
id int  auto_increment,
gameid int default Null,
type int default Null,
winarr varchar(255)  default Null,
selectablearr varchar(255)  default Null,
uid int default Null,
won int default 0,
date int default Null,
counter  int default 0,
PRIMARY KEY	 id (id)
);



drop table if exists freespins;
create table freespins (
id int  auto_increment,
gameid int default Null,
uid int default Null,
date int default Null,
counter int default 0,
won int default 0,
jackpotcounter int default 0,
PRIMARY KEY	 id (id)
);



drop table gamble;
create table gamble (
id int  auto_increment,
gameid int default Null,
date int default Null,
cardnum int default 0,
amount int default null,
PRIMARY KEY	 id (id)
);


DROP TABLE IF EXISTS `games`;
CREATE TABLE `games` (
  `gameid` int(8) NOT NULL auto_increment,
  `userid` int(8) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  `bet` tinytext NOT NULL,
  `betl` tinytext NOT NULL,
  `win_number` int(2) NOT NULL default '0',
  `result` char(1) NOT NULL default '',
  `amount` double(10,2) NOT NULL default '0.00',
  `type` int(2) NOT NULL default '0',
  PRIMARY KEY  (`gameid`),
  KEY `gameid` (`gameid`),
  KEY `userid` (`userid`),
  KEY `result` (`result`)
) ENGINE=MyISAM AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `transid` int(8) NOT NULL auto_increment,
  `userid` int(8) NOT NULL default '0',
  `gameid` int(8) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  `type` varchar(10) NOT NULL default '',
  `amount` double(10,2) NOT NULL default '0.00',
  `comments` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`transid`),
  KEY `transid` (`transid`),
  KEY `userid` (`userid`),
  KEY `type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `userid` int(8) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL default '',
  `lastname` varchar(255) NOT NULL default '',
  `login` varchar(200) NOT NULL default '',
  `passwd` varchar(255) NOT NULL default '',
  `ref` int(10) NOT NULL default '0',
  `suspend` int(1) NOT NULL default '0',
  `email` varchar(255) NOT NULL default '',
  `ip` varchar(30) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `state` varchar(20) NOT NULL default '',
  `zip` varchar(20) NOT NULL default '',
  `city` varchar(100) NOT NULL default '',
  `phone` varchar(100) NOT NULL default '',
  `address` mediumtext NOT NULL,
  `reg_date` int(11) NOT NULL default '0',
  `lplay_date` int(10) NOT NULL default '0',
  PRIMARY KEY  (`userid`),
  UNIQUE KEY `login` (`login`,`email`),
  KEY `ref` (`ref`)
) ENGINE=MyISAM AUTO_INCREMENT=10000 DEFAULT CHARSET=latin1;

