// ActionScript file

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

import spark.components.*;

public var _rpc:RemoteObject;
public var res:ArrayCollection;
public var ctrl:Array = new Array();
public var ctrlJIT:Array = new Array();

public var myAC:ArrayCollection = new ArrayCollection([Object]);
public var snd:Sound;


[Embed(source="assets/accept-icon_24.png")]	[Bindable]	public var iconOk:Class;
[Embed(source="assets/delete-icon_24.png")]	[Bindable]	public var iconDel:Class;
[Embed(source="assets/2519-32.png")]       	[Bindable]  public var iconAlert:Class;

private function initService():void{
	_rpc = new RemoteObject();
	_rpc.makeObjectsBindable = true;
	_rpc.destination = "fluorine";
	_rpc.source = "App_Code.com.r3Take.Core.linker";	
	_rpc.Receive.addEventListener(ResultEvent.RESULT, handleReceiveResult);
	_rpc.Receive.addEventListener(FaultEvent.FAULT, handleReceiveFault);						
}

private function ServiceValidateUser():void{
	_rpc = new RemoteObject();
	_rpc.makeObjectsBindable = true;
	_rpc.destination = "fluorine";
	_rpc.source = "App_Code.com.r3Take.Core.linker";	
	_rpc.validateUser.addEventListener(ResultEvent.RESULT, handleValidateUserResult);
	_rpc.validateUser.addEventListener(FaultEvent.FAULT, handleValidateUserFault);						
}

private function handleValidateUserResult(event:ResultEvent):void{
	var result:Array =  ArrayUtil.toArray(event.result);		
	if(result[0] == "false")
	{
		navigateToURL(new URLRequest('denied.html'),'_blank')
	}		
}

private function handleValidateUserFault(event:FaultEvent):void{		
	Alert.okLabel = "Aceptar";
	Alert.show("Es posible que usted tenga problemas de conexión a internet, favor de verificarlas.","Mensaje - Plataforma r3Take",Alert.OK,null,null, iconAlert);	
}	


private function handleReceiveResult(event:ResultEvent):void{
	var result:Array =  ArrayUtil.toArray(event.result);
	var myVals:Array;
	var operacion:String = "";		
	try{					
		for(var i:int=0; i < result.length; i++)
		{						
			myVals = result[i];
			operacion = myVals[0];
			if (operacion == "TO_FORM"){
				bindForm(myVals);
			} else if (operacion == "CB_DATA"){
				getComboResult(myVals);
			} else if (operacion == "LT_DATA"){
				getListResult(myVals);
			} else if (operacion == "DG_DATA"){
				getGridResult(myVals);
			} else if (operacion == "LBL_DATA"){
				getLabelResult(myVals);
			} else if (operacion == "TREE"){					
				getTree(myVals);
			} else if (operacion == "ID_DATA"){					
				getID(myVals);
			} else if (operacion == "FD_DATA"){					
				getFD(myVals);
			} else if (operacion == "GI_DATA"){					
				getImages(myVals);	
			} else if (operacion == "JS"){
				callJS(myVals);
			} else if (operacion == "LOAD_FORM"){						
				loadSWF2(myVals[1].toString(),myVals[2].toString());
			}  else if (operacion == "MODULE"){
				loadModule(myVals[1].toString());
			}  else if (operacion == "PATH_REPORT"){				
				try{							
					this[myVals[2].toString()].source=myVals[1].toString();							
				} catch (Err:Error){
					Alert.show("No se pudo cargar el archivo seleccionado");
				}	
			}  else if (operacion == "PATH_EXCEL"){					
				var request:URLRequest = new URLRequest(myVals[1].toString());
				request.contentType = "application/excel";
				var fileRef:FileReference = new FileReference();
				navigateToURL(request, '_blank');
			} else if (operacion == "MSG"){
				showMessage(myVals);
			} else if (operacion == "ERROR"){
				showError(myVals);						
			} 
		}
		CursorManager.removeBusyCursor();						
	} catch (e:Error) {	
		Alert.okLabel = "Aceptar";
		Alert.show(e.toString(),"Mensaje - Plataforma Facturaxion",Alert.OK,null,null, iconDel);					
	}
}	

private function handleReceiveFault(event:FaultEvent):void{	
	CursorManager.removeBusyCursor();
	
	var msgError:String = "NetConnection.Call.Failed";
	
	if(event.fault.message.toString().search(msgError) != -1)
	{
		Alert.okLabel = "Aceptar";
		Alert.show("No se puede contactar con el servidor o su conexión a internet no es estable, por favor intente nuevamente.","Mensaje - Plataforma Facturaxion",Alert.OK,null,null, iconDel);
	}
	else
	{
		Alert.okLabel = "Aceptar";
		Alert.show(event.fault.message,"Mensaje - Plataforma Facturaxion",Alert.OK,null,null, iconDel);
	}
}	

private function validateUser(pantalla:String):void{
	if(_rpc==null) {ServiceValidateUser();}		
	_rpc.validateUser(pantalla);
}

private function Get(id:int):void{
	if(_rpc==null) {initService();}
	CursorManager.setBusyCursor();
	
	
	_rpc.Receive(id);
}

private function Send(id:int):void{
	if(_rpc==null) {initService();}
	CursorManager.setBusyCursor();
	controler();
	_rpc.Receive(id, ctrl);		
}


private function controler():void{
	ctrl = null;
	ctrl = new Array();
	controlerIterator(this);
}

private function controlerIterator(myObject:UIComponent):void{
	var elems:int;				
	var p:spark.components.TextInput;
	elems = myObject.numChildren;
	var className:String;
	var auxClass:String;				
	var vals:Array = new Array();
	if(elems >= 1){
		className = myObject.className.toString();			
		if(className=="TextInput"){
			ctrl[myObject.id.toString()]=spark.components.TextInput(myObject).text;
		}
		else if(className=="ComboBox")
		{
			className = flash.utils.getQualifiedClassName(myObject);
			if(className=="mx.controls::ComboBox")
			{
				vals = mx.controls.ComboBox(myObject).selectedItem.valueOf().toString().split(",");
				ctrl[myObject.id.toString()]=vals[0].toString();
			}
			else
			{
				vals = spark.components.ComboBox(myObject).selectedItem.valueOf().toString().split(",");
				ctrl[myObject.id.toString()]=vals[0].toString();
			}
		}
		else if(className=="List"){
			vals = spark.components.List(myObject).selectedItem.valueOf().toString().split(",");
			ctrl[myObject.id.toString()]=vals[0].toString();
		} else if(className=="DateField"){
			ctrl[myObject.id.toString()]=DateField(myObject).text;
		}else if(className=="DataGrid"){
			ctrl[myObject.id.toString()]= ArrayUtil.toArray(mx.controls.DataGrid(myObject).dataProvider.source);
		}else if(className=="TextArea"){							
			ctrl[myObject.id.toString()]=spark.components.TextArea(myObject).text;
		} else if(className=="NumericStepper"){
			ctrl[myObject.id.toString()]=spark.components.NumericStepper(myObject).value;
		} else if(className=="CheckBox"){
			if(spark.components.CheckBox(myObject).selected){
				ctrl[myObject.id.toString()] = "1";
			} else {
				ctrl[myObject.id.toString()] = "0";
			}							
		} else if(className=="RadioButton"){
			auxClass = spark.components.RadioButton(myObject).groupName.toString();						
			if(auxClass!="radioGroup"){							
				ctrl[auxClass] = spark.components.RadioButton(myObject).group.selectedValue;
			} else {
				ctrl[myObject.id.toString()] = spark.components.RadioButton(myObject).value;
			}						
		} else if(className=="Uploader"){
			//ctrl[myObject.id.toString()] = Uploader(myObject).eGobFileName.text;
		}
		else if(className=="Button"){
			
		} else {
			for(var i:int=0; i < elems; i++){
				try{
					controlerIterator(UIComponent(myObject.getChildAt(i)));	
				} catch (Err:Error) {}
			}
		}					
	}					
}

private function replaceExtrengeChars(texto:String):String
{
	var patternSL:RegExp = /[\n+]/gi;	
	var patternRC:RegExp = /[\r+]/gi;	
	var patternTB:RegExp = /[\t+]/gi;	
	var patternPP:RegExp = /[\|+]/gi;
	var patternComillas:RegExp = /[\"+]/gi;
	var patternBlank:RegExp = /([[:space:]]+)([[:space:]]+)/gi;
	
	while (texto.search(patternPP) != -1 )
	{
		texto = texto.replace(patternPP, "");
	}
	while (texto.search(patternSL) != -1 )
	{
		texto = texto.replace(patternSL, " ");
	}
	while (texto.search(patternRC) != -1 )
	{
		texto = texto.replace(patternRC, " ");
	}
	while (texto.search(patternTB) != -1 )
	{
		texto = texto.replace(patternTB, " ");
	} 
	while (texto.search(patternBlank) != -1 )
	{
		texto = texto.replace(patternBlank, " ");
	}
	while (texto.search(patternComillas) != -1 )
	{
		texto = texto.replace(patternBlank, "");
	}
	return texto;
}
private function bindForm(result:Array):void{
	var myData:ArrayCollection;
	var firstObject:Object;
	var fo:String;
	var myObject:UIComponent;
	var className:String;
	var cbValue:String;
	var currValue:String;
	var cbLen:int;
	
	myData = new ArrayCollection(ArrayUtil.toArray(result[1].serverInfo.initialData));
	for(var i:int=0; i < myData.length; i++)
	{
		try{						
			firstObject = this[myData[i][0].toString()];
			fo = firstObject.toString();
			if(fo.indexOf("RadioButtonGroup")>0){
				spark.components.RadioButtonGroup(firstObject).selectedValue=myData[i][1].toString();							
			} else {
				myObject = this[myData[i][0].toString()];
				className = myObject.className.toString();
				if(className=="TextInput"){
					spark.components.TextInput(myObject).text = myData[i][1].toString();								
				} else if(className=="ComboBox"){
					cbValue =  myData[i][1].toString();
					cbLen = mx.controls.ComboBox(myObject).dataProvider.length;
					for(var j:int=0; j<cbLen; j++){
						currValue = mx.controls.ComboBox(myObject).dataProvider[j][0];
						if(currValue == cbValue){
							mx.controls.ComboBox(myObject).selectedIndex = j;
							break;
						}
					}
					if(mx.controls.ComboBox(myObject).selectedIndex==-1){									
						mx.controls.ComboBox(myObject).selectedIndex=0;
					}
				} else if(className=="DateField"){								
					DateField(myObject).text = myData[i][1].toString();
				} else if(className=="Text"){					
					Text(myObject).htmlText = myData[i][1].toString();
				} else if(className=="TextArea"){
					spark.components.TextArea(myObject).text = myData[i][1].toString();
				} else if(className=="Label"){
					spark.components.Label(myObject).text = myData[i][1].toString();
				}  else if(className=="NumericStepper"){
					spark.components.NumericStepper(myObject).value = parseInt(myData[i][1].toString());
				} else if(className=="CheckBox"){
					if(myData[i][1].toString()=="1"||myData[i][1].toString()=="True"){
						spark.components.CheckBox(myObject).selected = true;
					} else {
						spark.components.CheckBox(myObject).selected = false;
					}								
				} else if(className=="Uploader"){
					//Uploader(myObject).eGobFileName.text = myData[i][1].toString();
				}
			}							
		} catch (Err2:Error){
			trace(myData[i][0].toString()+" no encontrado");						
		}
	}
}
private function getComboResult(result:Array):void{				
	var myCombo:String = result[1];					
	var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[2].serverInfo.initialData));										
	try{									
		this[myCombo].dataProvider=res;
		this[myCombo].labelField = "1";		
		this[myCombo].selectedIndex=0;	
	} catch (Err:Error){
		trace(Err.toString());
	}
}	

private function getListResult(result:Array):void{				
	var myList:String = result[1];					
	var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[2].serverInfo.initialData));										
	try{									
		this[myList].dataProvider=res;
		this[myList].labelField = "1";			
	} catch (Err:Error){
		trace(Err.toString());
	}
}

private function getTree(result:Array):void{
	
	var myTree:String = result[1];							
	try{
		this[myTree].dataProvider=result[2];
		validateNow();
		this[myTree].expandChildrenOf(this[myTree].dataProvider.@item,true);	
	} catch (Err:Error){
		trace(Err.toString());
	}
}

import mx.managers.DragManager;
import mx.core.DragSource;
import mx.events.DragEvent;
import flash.events.MouseEvent;
import flash.events.FocusEvent;
import mx.states.AddChild;


private function loadScreen(event:MouseEvent):void 
{       		
	var dragInitiator:Image=Image(event.currentTarget);
	
	var nameImage:String = "";
	var numChildren:Number = parseInt(this["numImages"].text);
	for (var i:int = 0; i < numChildren; i++) {
		ctrlJIT[i.toString()].visible = false;		        
	}
	
	mx.controls.SWFLoader(findObject("globalLoader", "SWFLoader")).source =dragInitiator.name.toString();
	
}

private function cleanAD():void 
{    
	try{        		
		var nameImage:String = "";
		//Go - To: Se deja el 100 de forma dura ya que no se puede determinar el tamaño del array
		var numChildren:Number = 100;
		
		for (var i:int = 0; i < numChildren; i++) {
			ctrlJIT[i.toString()].visible = false;		        
		}
	}
	catch (Err:Error){
		trace(Err.toString());
	}
}



private function mouseMoveHandler(event:MouseEvent):void 
{            
	var dragInitiator:Image=Image(event.currentTarget);
	var ds:DragSource = new DragSource();
	ds.addData(dragInitiator, "img");               
	
	var imageProxy:Image = new Image();
	imageProxy.source = dragInitiator.source;
	imageProxy.height=32;
	imageProxy.width=32;                
	DragManager.doDrag(dragInitiator, ds, event, imageProxy, -15, -13, 1.00);
	
}

private function dragEnterHandler(event:DragEvent):void {
	
	if (event.dragSource.hasFormat("img"))
	{
		DragManager.acceptDragDrop(Application(event.currentTarget));
	}
}


private function dragDropHandler(event:DragEvent):void {
	
	var positionX:Number;
	var positionY:Number;
	positionX = Application(event.currentTarget).mouseX - 33;
	positionY = Application(event.currentTarget).mouseY - 30;
	
	Image(event.dragInitiator).x = positionX;
	Image(event.dragInitiator).y = positionY;
	
	
	this["xPosition"].text = positionX.toString();
	this["yPosition"].text = positionY.toString();
	this["nameImage"].text = Image(event.dragInitiator).id;
	Send(92);
}

private function addJIT(myObj:Object, count:int):void{
	ctrlJIT[count.toString()]=myObj;
}        

private function getID(result:Array):void{
	
	try
	{		
		var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[1].serverInfo.initialData));
		//var i:int;
		import mx.events.*;
		
		//var numChildren:Number = ctrlJIT.length;
		var numChildren:Number = 0;
		
		if(numChildren  > 0)
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				ctrlJIT[i.toString()].visible = false;		        
			}
			ctrlJIT = new Array();
		}
		
		var numImages:int = res.length;
		
		for(i = 0; i < numImages; i++)
		{
			var image:Image=new Image();
			image.source="iconDesktop/" + res[i][0].toString();
			image.id=res[i][4].toString();
			image.name = res[i][3].toString();
			image.height= 64;
			image.width= 64;
			image.x = parseInt(res[i][1]);
			image.y = parseInt(res[i][2]);
			image.toolTip = res[i][5].toString();
			image.addEventListener(MouseEvent.CLICK, loadScreen);
			image.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			addJIT(image, i);
			//spark.components.Group(findObject("globalCanvas","Group")).AddChild(image);
			this["globalCanvas"].addChild(image);
		}          
		
	} catch (Err:Error)
	{
		trace(Err.toString());
	}
}	

private function getFD(result:Array):void{
	
	try
	{		
		var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[1].serverInfo.initialData));
		
		import mx.events.*;
		
		var numChildren:Number = 0;
		
		if(numChildren  > 0)
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				ctrlJIT[i.toString()].visible = false;		        
			}
			ctrlJIT = new Array();
		}
		
		var numImages:int = res.length;
		
		for(i = 0; i < numImages; i++)
		{
			var image:Image=new Image();
			image.source="applicationImages/" + res[i][1].toString();
			image.id=res[i][2].toString();
			image.height= 40;
			image.width= 40;
			image.toolTip = res[i][0].toString();
			image.doubleClickEnabled = true;
			image.addEventListener(MouseEvent.DOUBLE_CLICK, downloadFile);
			image.addEventListener(MouseEvent.CLICK, deleteFile);
			
			addJIT(image, i);
			this["containerFiles"].addChild(image);                
		}          
		
	} catch (Err:Error)
	{
		trace(Err.toString());
	}
}	

private function findObject(handler:String, cn:String):Object{
	var myObject:Object = new Object();
	myObject = parentDocument.parent;
	while(myObject.parent != null){
		myObject = myObject.parent;
		try {
			if(myObject.className == cn){
				if(myObject.id == handler){
					return myObject;
				}
			}
		} catch (Err:Error) { trace(Err.toString()); }	
	}
	return null;
}

private function downloadFile(event:MouseEvent):void {
	var image:Image=Image(event.currentTarget);
	var pathFile:String;
	pathFile = "http://10.32.131.15/compartida/" + 	image.toolTip.toString();
	
	var vals:Array = new Array();
	
	vals = image.toolTip.toString().split(".");
	
	var request:URLRequest = new URLRequest(pathFile);
	
	var fileRef:FileReference = new FileReference();
	navigateToURL(request, '_blank');
	
}

private function deleteFile(event:MouseEvent):void {
	var image:Image=Image(event.currentTarget);
	
	this["idFile"].text = image.id.toString();
	
	
}

private function loadImage(event:MouseEvent):void{
	
	var imageIcon:Image=Image(event.currentTarget);	
	spark.components.TextInput(this["nameImageTW"]).text = imageIcon.id.toString();
}

private function getImages(result:Array):void{
	
	try
	{		
		var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[2].serverInfo.initialData));
		var i:int;
		import mx.events.*;
		this[result[1].toString()].removeAllChildren();
		var numImages:int = res.length;
		for(i = 0; i < numImages; i++)
		{
			var image:Image=new Image();
			image.source="iconDesktop/" + res[i][0].toString();
			image.id=res[i][0].toString();
			image.height= 64;
			image.width= 64;
			image.name = res[i][0].toString();
			image.addEventListener(MouseEvent.CLICK, loadImage);
			
			this[result[1].toString()].addChild(image);
		}          
	} catch (Err:Error){
		trace(Err.toString());
	}
}	


private function getGridResult(result:Array):void{				
	var myGrid:String = result[1];					
	var res:ArrayCollection = new ArrayCollection(ArrayUtil.toArray(result[2].serverInfo.initialData));										
	try{									
		this[myGrid].dataProvider=res;									
	} catch (Err:Error){
		trace(Err.toString());
	}
}			

private function getLabelResult(result:Array):void{				
	var myLabel:String = result[1];					
	var res:String = result[2];										
	try{									
		this[myLabel].text=res;									
	} catch (Err:Error){
		trace(Err.toString());
	}
}
private function callJS(result:Array):void{				
	ExternalInterface.call(result[1].toString(), result[2].toString());
}	

private function loadSWF(result:Array):void{				
	SWFLoader(getChildByName("miSWF")).load(result[0].toString());	
}

private function loadSWF2(handler:String, resource:String):void{
	try{	
		if(resource.toString() == "login.html")
		{
			Send(442);
			var urlRequest:URLRequest = new URLRequest("https://fx.facturaxion.com/facturaxion/fx.html");
			navigateToURL(urlRequest,"_self");
		}	
		else
		{	
			SWFLoader(this[handler.toString()]).load(resource.toString());				
		}
	} catch (Err:Error) {
		try{				
			parentApplication.miSWF.load(resource.toString());
			
		} catch (Err2:Error){
			Alert.okLabel = "Aceptar";
			Alert.show(Err2.message.toString(),"Aviso",Alert.OK,null,null, iconDel);			
		}
	}
}	

private function loadModule(resource:String):void{
	try{			
		ModuleLoader(this["mainLoader"]).url = resource;
		spark.components.Panel(this["mainPanel"]).visible = true;
	} catch (Err:Error) {
		Alert.okLabel = "Aceptar";
		Alert.show(Err.message.toString(),"Aviso",Alert.OK,null,null, iconDel);
	}
}	


private function showMessage(result:Array):void{				
	var myMsg:String = result[1];		
	try{
		Alert.okLabel = "Aceptar";
		Alert.show(myMsg,"Aviso",Alert.OK,null,null, iconOk);						
	} catch (Err:Error){
		
	}
}

private function showError(result:Array):void{				
	var myMsg:String = result[1];		
	try{
		Alert.okLabel = "Aceptar";
		Alert.show(myMsg,"Aviso",Alert.OK,null,null, iconDel);								
	} catch (Err:Error){
		
	}
}


private function DCInit(control:String):void {
	this[control].dayNames=['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];
	this[control].monthNames=['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
	this[control].firstDayOfWeek = 1;
	this[control].setStyle("headerColor", 0xff0000);
	this[control].selectableRange = {rangeStart: new Date(2000,0,1), rangeEnd: new Date(2050,0,1)};
}


private static function btnSound():void{
	var snd:Sound = new Sound(new URLRequest("assets/UI_Button0.mp3"));
	snd.play();
}

