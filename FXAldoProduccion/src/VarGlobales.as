// ActionScript file
package {
	import mx.collections.ArrayCollection;
	import mx.messaging.channels.StreamingAMFChannel;
	
	import org.hamcrest.mxml.collection.InArray;
	
	public class VarGlobales{	
		
		public var rutaImagen:String;
		public var ClienteId:String;
		
		private static var instancia:VarGlobales;
		
		public function VarGlobales(){
		}
		
		public static function variables():VarGlobales{
			if (!instancia){
				instancia = new VarGlobales();
			}
			
			return instancia;
		}
		
	}
}