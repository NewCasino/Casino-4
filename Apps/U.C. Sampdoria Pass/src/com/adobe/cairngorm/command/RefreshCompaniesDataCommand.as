package com.adobe.cairngorm.command {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.model.ApplicationModelLocator;
	import com.peterelst.air.sqlite.Query;
	
	import mx.rpc.IResponder;
	
	
	public class RefreshCompaniesDataCommand implements IResponder, ICommand {
		
		[Bindable]
		private var model:ApplicationModelLocator = ApplicationModelLocator.getInstance();
		
		public function RefreshCompaniesDataCommand() {
			
		}
		
		public function result(data:Object):void {
			
		}
		
		public function fault(info:Object):void {
			
		}
		
		public function execute(event:CairngormEvent):void {
			var query:Query = new Query();
			query.connection = model.dbHandler.connection;
			query.sql = "SELECT * FROM users"
		}
		
	}
}