package com.events
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		public static const ZOOM_EVENT:String = "zoomEvent";
		public var state:Boolean;
		
		public function CustomEvent(type:String, state:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.state = state;
		}
		public override function clone():Event
		{
			return new CustomEvent(type, state);
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "state");
		}
	}
}