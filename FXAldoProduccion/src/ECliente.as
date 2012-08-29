package
{
	public class ECliente
	{
		public function ECliente()
		{
			private var sucursalId:int;
			private var empresaId:int;
			private var nombreSucursal:String;
			private var pais:String;
			private var cP:int;
			private var estado:String;
			private var ciudad:String;
			private var municipio:String;
			private var colonia:String;
			private var calle:String;
			private var numeroExt:String;
			private var numeroInt:String;
			private var correo:String;
			private var impuestoDetalleId:int;
			
			public function get SucursalId():int{
				return this.sucursalId;
			}
			public function set SucursalId(value:int):void{
				this.sucursalId = value;
			}
			
			public function get EmpresaIdId():int{
				return this.empresaId;
			}
			public function set EmpresaId(value:int):void{
				this.empresaId = value;
			}
			
			public function get NombreSucursal():String{
				return this.nombreSucursal;
			}
			public function set NombreSucursal(value:String):void{
				this.nombreSucursal = value;
			}
			
			public function get Pais():String{
				return this.pais;
			}
			public function set Pais(value:String):void{
				this.pais = value;
			}
			
			public function get CodigoPostal():String{
				return this.cP;
			}
			public function set CodigoPostal(value:int):void{
				this.cP = value;
			}
			
			public function get Estado():String{
				return this.estado;
			}
			public function set Estado(value:String):void{
				this.estado = value;
			}
			
			public function get Ciudad():String{
				return this.ciudad;
			}
			public function set Ciudad(value:String):void{
				this.ciudad = value;
			}
			
			public function get Municipio():String{
				return this.municipio;
			}
			public function set Municipio(value:String):void{
				this.municipio = value;
			}
			
			public function get Colonia():int{
				return colonia;
			}
			public function set Colonia(value:int):void{
				colonia = value;
			}
			
			public function get Calle():String{
				return this.calle;
			}
			public function set Calle(value:String):void{
				this.calle = value;
			}
			
			public function get NumeroExterior():String{
				return this.numeroExt;
			}
			public function set NumeroExterior(value:String):void{
				this.numeroExt = value;
			}
			
			public function get NumeroInterior():String{
				return this.numeroInt;
			}
			public function set NumeroInterior(value:String):void{
				this.numeroInt = value;
			}
			
			public function get Correo():String{
				return this.correo;
			}
			public function set Correo(value:String):void{
				this.correo = value;
			}
			
			public function get ImpuestoDetalleId():int{
				return this.impuestoDetalleId;
			}
			public function set ImpuestoDetalleId(value:int):void{
				this.impuestoDetalleId = value;
			}
		}
	}
}