import com.r3Take.utils.*;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.Image;
import mx.controls.SWFLoader;
import mx.controls.Text;
import mx.core.UIComponent;
import mx.managers.CursorManager;
import mx.messaging.messages.ErrorMessage;
import mx.modules.ModuleLoader;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;
import mx.utils.ArrayUtil;
import mx.controls.*;

[Embed(source="assets/2519-32.png")]		[Bindable]	public var Not:Class;

public function validar(ctrlArray:Array):String
{
	var nctrlArray:int=ctrlArray.length;
	var className:String;
	var mError:String = "";
	var err:int = 0;
	
	for(var i:int=0;i<nctrlArray;i++)
	{
		className = UIComponent(ctrlArray[i]).className.toString()
		
		if(className=="TextInput")
		{
			if(mx.utils.StringUtil.trim(spark.components.TextInput(ctrlArray[i]).text).length == 0)
			{//EL CONTROL ESTÁ VACÍO?
				//if(mx.utils.StringUtil.trim(TextInput(ctrlArray[i]).name).length == 0){//NO TIENE LA PROPIEDAD name
				if(spark.components.TextInput(ctrlArray[i]).name == spark.components.TextInput(ctrlArray[i]).id)
				{//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control TextInput vacío.\n";
				}
				else
				{	
					mError+= spark.components.TextInput(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(spark.components.TextInput(ctrlArray[i]).errorString).length == 0)
				{//NO TIENE errorString
					spark.components.TextInput(ctrlArray[i]).errorString = spark.components.TextInput(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;	
			}
			else
			{
				spark.components.TextInput(ctrlArray[i]).errorString="";
			}
		} 
		else if(className=="ComboBox")
		{
			//if(ComboBox(ctrlArray[i]).selectedItem == null)//NO HAY NINGÚN ELEMENTO SELECCIONADO
			if(spark.components.ComboBox(ctrlArray[i]).selectedIndex == 0 || spark.components.ComboBox(ctrlArray[i]).selectedItem == null)//NO HAY NINGÚN ELEMENTO SELECCIONADO
			{	
				if(spark.components.ComboBox(ctrlArray[i]).name == spark.components.ComboBox(ctrlArray[i]).id)
				{//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control ComboBox vacío.\n";
				}
				else
				{
					mError+=spark.components.ComboBox(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(spark.components.ComboBox(ctrlArray[i]).errorString).length == 0)
				{//NO TIENE errorString
					spark.components.ComboBox(ctrlArray[i]).errorString = spark.components.ComboBox(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;
			}
			else
			{
				spark.components.ComboBox(ctrlArray[i]).errorString="";
			}
		} 
		else if(className=="DateField")
		{
			if(mx.utils.StringUtil.trim(DateField(ctrlArray[i]).text).length==0)
			{//EL CONTROL ESTÁ VACÍO?
				if(DateField(ctrlArray[i]).name == DateField(ctrlArray[i]).id)
				{
					//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control DateField vacío.\n";
				}
				else
				{
					mError+="No existe una fecha asociada a la " + DateField(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(DateField(ctrlArray[i]).errorString).length == 0)
				{//NO TIENE errorString
					DateField(ctrlArray[i]).errorString = DateField(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;
			}
			else
			{
				DateField(ctrlArray[i]).errorString="";
			}
		} 
		else if(className=="TextArea")
		{
			if(mx.utils.StringUtil.trim(spark.components.TextArea(ctrlArray[i]).text).length == 0)
			{//EL CONTROL ESTÁ VACÍO?
				if(spark.components.TextArea(ctrlArray[i]).name == spark.components.TextArea(ctrlArray[i]).id)
				{//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control TextArea vacío.\n";
				}
				else
				{
					mError += spark.components.TextArea(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(spark.components.TextArea(ctrlArray[i]).errorString).length == 0){//NO TIENE errorString
					spark.components.TextArea(ctrlArray[i]).errorString = spark.components.TextArea(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;
			}
			else
			{
				spark.components.TextArea(ctrlArray[i]).errorString="";
			}			
		} 
		else if(className=="NumericStepper")
		{
			if(spark.components.NumericStepper(ctrlArray[i]).value == 0)
			{//EL CONTROL ESTÁ VACÍO?
				if(spark.components.NumericStepper(ctrlArray[i]).name == spark.components.NumericStepper(ctrlArray[i]).id)
				{//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control NumericStepper sin valor numérico asociado.\n";
				}
				else
				{
					mError += spark.components.NumericStepper(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(spark.components.NumericStepper(ctrlArray[i]).errorString).length == 0)
				{//NO TIENE errorString
					spark.components.NumericStepper(ctrlArray[i]).errorString = spark.components.NumericStepper(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;
			}
			else
			{
				spark.components.NumericStepper(ctrlArray[i]).errorString="";
			}
		} 
		else if(className=="CheckBox")
		{
			if(!mx.controls.CheckBox(ctrlArray[i]).selected)
			{//EL CONTROL NO ESTÁ SELECCIONADO?
				if(mx.controls.CheckBox(ctrlArray[i]).name == mx.controls.CheckBox(ctrlArray[i]).id)
				{//EL NAME DEL CONTROL == AL ID DEL MISMO CONTROL
					mError+="Existe un control CheckBox sin ser seleccionado.\n";
				}
				else
				{
					mError += spark.components.CheckBox(ctrlArray[i]).name +", ";
				}
				if(mx.utils.StringUtil.trim(mx.controls.CheckBox(ctrlArray[i]).errorString).length == 0)
				{//NO TIENE errorString
					mx.controls.CheckBox(ctrlArray[i]).errorString = spark.components.CheckBox(ctrlArray[i]).name + " es un campo obligatorio.";
				}
				err++;
			}
			else
			{
				mx.controls.CheckBox(ctrlArray[i]).errorString="";
			}
		}
	}
	if(err > 0)
	{
		if(mx.utils.StringUtil.trim(mError).length > 0)
		{
			var valMSG:Array = new Array();
			valMSG   = mError.toString().split(",");
			
			if(valMSG.length == 2)
			{
				Alert.okLabel = "Aceptar";
				Alert.show(mError + "es un campo Obligatorio.","Alerta",Alert.OK, null, null, Not);	
			}
			else
			{
				Alert.okLabel = "Aceptar";
				Alert.show("Los campos: \n" + mError + "son obligatorios.","Alerta",Alert.OK, null, null, Not);
			}
		}
		else
		{
			Alert.show("Existen campos vacíos que son obligatorios.","Alerta",Alert.OK, null, null, Not);
		}
		return "0";
	}
	else
	{
		return "1";
	}	
}