//
// Author: Sher Ali
// Website: http://www.kabulinteractive.com
// Creation Date: 02-04-2008

package com.kabulinteractive {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	dynamic public class FlashCalendar extends MovieClip {
		
		//craete the date Class object and relative variables
		private var date_object:Date;
		private var year:Number;
		private var month:Number;
		private var day:Number;
		private var date:Number;
		private var current_date:Number;
		
		
		//create months and week_days arrays to store the names of the months and week' days
		//as flash use numbers for both months and week days
		private var months:Array;
		private var week_days:Array;
		
		public function FlashCalendar(){
			//this._visible = false;
			date_object = new Date();
			this.months = ['January','February','March','April','May','Jun','July','August','September','Octobor','November','December'];
			this.week_days = ['','Su','Mo','Tu','We','Th','Fr','Sa'];
			
			//initialize the date's,month's, year's values here
			setMonth();
			setYear();
			setDate();
			//initialize the calendar
			initDateChooser();
			
			//When one of the 4 arrows buttons is clicked
			//then update the calendar
			this.prevMonth_btn.addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent){ event.currentTarget.gotoAndStop("over"); });
			this.prevMonth_btn.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent){ event.currentTarget.gotoAndStop("up"); });
			//.onRollOver = nextMonth_btn.onRollOver = prevYear_btn.onRollOver = nextYear_btn.onRollOver = function(){ this.gotoAndStop("over"); }
			//prevMonth_btn.onRollOut = nextMonth_btn.onRollOut = prevMonth_btn.onDragOut = nextMonth_btn.onDragOut = prevYear_btn.onRollOut = nextYear_btn.onRollOut = prevYear_btn.onDragOut = nextYear_btn.onDragOut = function(){ this.gotoAndStop("up"); }
			this.prevMonth_btn.buttonMode = true;
			this.prevMonth_btn.addEventListener(MouseEvent.CLICK, function(){
				month--;
				if( month < 0 ){
					month = 11;
					year--;
				}
				initDateChooser();
				
			});
			
			this.nextMonth_btn.buttonMode = true;
			this.nextMonth_btn.addEventListener(MouseEvent.CLICK, function(){
				month++;
				if( month > 11 ){
					month = 0;
					year++;
				}
				initDateChooser();
			});
			
			this.prevYear_btn.buttonMode = true;
			this.prevYear_btn.addEventListener(MouseEvent.CLICK, function(){
				year--;
				initDateChooser();	
			});
			
			this.nextYear_btn.buttonMode = true;
			this.nextYear_btn.addEventListener(MouseEvent.CLICK, function(){
				year++;
				initDateChooser();
			});
			
			
			this.visible = false;
		}
		//var root:MovieClip = this;
		
		
		//store the reference of the text field which is being used for
		//displaying the selected date in the target_text_field variable
		//var target_text_field:TextField = _parent.current_date_display;
		
		//this function is responsible for displaying the full calendar
		public function initDateChooser(){
			//when user clicks the month's or year's buttons to navigate
			//then first we clear the previous data using this for loop
			var j:uint;
			for( j=1;j<=31;j++ ){
				try{
					this.dates_container_mc.removeChildAt(0);
				}
				catch(error:Error){
					//
				}
			}
			//re-initialized the data_object variable based on the new month and year values
			date_object = new Date(getYear(),getMonth(),1);
			//call setDay function
			setDay();
			
			//show the month and year in the top text field of the calendar
			this.month_year_mc.month_year_field.text = months[getMonth()]+", "+getYear();
			
			//display the week days in short form
			//and use the week_days array to show in characters rather than digits
			for(var i=1;i<week_days.length;i++){
				MovieClip(this.week_days_mc.getChildByName(("week_day_" + i))).theLabel.text = this.week_days[i];
			}
			
			//these will help to layout the date's grid
			var x_offset:Number = getDay();
			var y_offset:Number = 0;
			
			for ( j = 1; j <= getCurrentMonthDays(month + 1); j++ ) {
				//grab a date_mc movieclip from the library and place it on the calendar object
				//and set its various properties
				var dateMC:DateMC = new DateMC();
				//var dateMC:MovieClip = dates_container_mc.attachMovie("date_mc","date_mc"+j,dates_container_mc.getNextHighestDepth());
				if( (x_offset)%7 == 0 ){
					x_offset = 0;
					if( j != 1 ){
						y_offset++;
					}
				}
				dateMC.x = x_offset*28;
				dateMC.y = y_offset*28;
				
				dateMC.dateLabel.theLabel.text = j;
				x_offset++;
				
				dateMC.id = j;
				
				this.dates_container_mc.addChild(dateMC);
				
				//Show the today's date in selected state
				var temp_date_obj:Date = new Date();
				if( j == getDate() && temp_date_obj.getMonth() == getMonth() && temp_date_obj.getFullYear() == getYear() ){
					dateMC.gotoAndStop("over");
				}
				
				dateMC.dateLabel.theLabel.mouseEnabled = false;
				dateMC.buttonMode = true;
				dateMC.addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent){
					event.currentTarget.gotoAndStop("over");
				});
				dateMC.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent){
					if( event.currentTarget.id != getDate() ){
						event.currentTarget.gotoAndStop("up");
					}
				});
				dateMC.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {					
					dispatchEvent(new FlashCalendarEvent(getYear() + "-" + (getMonth() + 1) + "-" + event.currentTarget.id, FlashCalendarEvent.DATE_SELECTED));
				});
			}
		}
		
		//This function calculates the correct number of days in the supplied month
		private function getCurrentMonthDays(month:Number):Number{
			var numOfDaysInMonth:Number;
			if( (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) ){
				numOfDaysInMonth = 31;
			}
			else if( (month == 4) || (month == 6) || (month == 9) || (month == 11)  ){
				numOfDaysInMonth = 30;
			}
			else if( month == 2 && ((year%4) != 0) ){
				numOfDaysInMonth = 28;
			}
			else{
				numOfDaysInMonth = 29;
			}
			return numOfDaysInMonth;
		}
		
		//These functions set and get various date related variables
		private function setMonth(){
			month = date_object.getMonth();
		}
		
		private function getMonth():Number{
			return month;
		}
		private function setYear(){
			year = date_object.getFullYear();
		}
		
		private function getYear():Number{
			return year;
		}
		private function setDate(){
			date = date_object.getDate();
		}
		
		private function getDate():Number{
			return date;
		}
		private function setDay(){
			day = date_object.getDay();
		}
		
		private function getDay():Number{
			return day;
		}
	}
}