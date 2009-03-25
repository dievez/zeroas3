﻿package com.dmotiko.selu {
	import com.general.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
		
	public class SeluSite
	extends WebSite {
		
		public static const HOME:String = "SELU_HOME";
		public static const COLECCION:String = "SELU_COLECCION";
		public static const BACKSTAGE:String = "SELU_BACKSTAGE";
		public static const PUNTOVENTA:String = "SELU_PUNTOVENTA";
		public static const NOVEDADES:String = "SELU_NOVEDADES";
		public static const SEXIES:String = "SELU_SEXIES";
		public static const PRENSA:String = "SELU_PRENSA";
		public static const CONTACTO:String = "SELU_CONTACTO";
		public static const NOCASTING:String = "SELU_NOCASTING";
		private var mainContent:Sprite;
		private var topClip:Sprite;
		private var seluLoader:SeluLoader;
		private var collectionXMLList:XMLList;
		private var collection_loaderXML:URLLoader;
		private var lastCollection_loaderXML:URLLoader;
		private var lastCollectionXMLList:XMLList;
				
		public static function getApp():SeluSite {
			return SeluSite(app);
		}
						
		public function SeluSite() {
			super();
			getChildByName("mcCenter").visible = false;
			setCenterClip(getChildByName("mcCenter"));
			isFullFlash();
		}
				
		override protected function initSite():void {
			mainContent = this.addChild( new Sprite() ) as Sprite;
			topClip = this.addChild( new Sprite() ) as Sprite;
			this.sSection = SeluSite.HOME;
			super.initSite();
			
		}
		
		override protected function loadExternalContent():void {
			collection_loaderXML = new URLLoader();
			collection_loaderXML.dataFormat = URLLoaderDataFormat.TEXT;
			collection_loaderXML.addEventListener( Event.COMPLETE, collectionLoaded );
			collection_loaderXML.load( new URLRequest( "collection.xml" ) );
			
			lastCollection_loaderXML = new URLLoader();
			lastCollection_loaderXML.dataFormat = URLLoaderDataFormat.TEXT;
			lastCollection_loaderXML.addEventListener( Event.COMPLETE, lastCollectionLoaded );
			lastCollection_loaderXML.load( new URLRequest( "lastCollection.xml" ) );
		}
		
		private function lastCollectionLoaded(e:Event):void {
			try{
				//Convert the downloaded text into an XML
				var myXML:XML = new XML(e.target.data)
				lastCollectionXMLList = myXML.children()[0].child("photo");
				checkXML();
												
			} catch (e:TypeError){
				//Could not convert the data, probavlu because is not formated correctly
				trace("Could not parse the XML")
				trace(e.message)
			}
		}
		
		private function checkXML():void {
			if ( lastCollectionXMLList && collectionXMLList ) {
				externalContentLoaded( undefined );
			}
		}
		
		private function collectionLoaded(e:Event):void {
			try{
				//Convert the downloaded text into an XML
				var myXML:XML = new XML(e.target.data)
				collectionXMLList = myXML.children()[0].child("photo");
				checkXML();
								
			} catch (e:TypeError){
				//Could not convert the data, probavlu because is not formated correctly
				trace("Could not parse the XML")
				trace(e.message)
			}
		}
		
		override protected function externalContentLoaded( evnt:Event = undefined):void {
			getChildByName("mcSeluLoader").addEventListener( Event.CHANGE, hideLoader);
			var mLoader:Loader = new Loader(); 
			var mRequest:URLRequest = new URLRequest("mainContent.swf"+getNoCache()); 
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler); 
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
			
		}
		
		private function hideLoader(e:Event):void {
			//getChildByName("mcSeluLoader").visible = false;
			removeChild( getChildByName("mcSeluLoader") );
		}
		
		private function onProgressHandler(evnt:ProgressEvent) {         
			var nP:Number = Math.round( evnt.bytesLoaded * 100 / evnt.bytesTotal );
			(getChildByName("mcSeluLoader") as SeluLoader).setPos( nP );
		}
		
		private function onCompleteHandler(loadEvent:Event) {         
			mainContent.addChild(loadEvent.currentTarget.content);
		}
		
		public function getTopClip():Sprite { return topClip; }
		
		public function getCollectionData():XMLList { return collectionXMLList;	}
		public function getLastCollectionData():XMLList { return lastCollectionXMLList;	}
		
	}
	
}