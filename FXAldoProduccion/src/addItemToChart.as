package
{
	[Bindable]
	public class addItemToChart
	{
		public var idInt:String;
		public var name:String;
		public var estado:String;
		
		
		public function addItemToChart(idInt:String, name:String,estado:String)
		{
			this.idInt = idInt;
			this.name = name;
			this.estado = estado;
		}
	}
}
