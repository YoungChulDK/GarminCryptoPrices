using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;

class CryptoWidgetView extends Ui.View {
	//Fields:
	
	//Communication
		hidden var commConf = false; // Confirm communication
		
	//Data storage
		hidden var mCurrency = new [10]; //Initializing array for top 5 currencies
		hidden var mCurPrice = new [10]; //Initializing array for current price of top 5 currencies (USD $)
		hidden var mCurPriceEur = new [10]; //Initializing array for current price of top 5 currencies (EUR €)
		hidden var curCurrencyPrice = new [10]; //Temporary Array (For changing currency)
		var bmapDict = {}; //Hash table for storing Bitmaps/drawables
	
	//Graphics parameters
		var dcHeight, dcWidth, dcWidthBM; //Device screen dimensions
		hidden var heightSplitter = [8.72, 3.633, 2.29473, 1.67692, 1.32121, 8.72, 3.633, 2.29473, 1.67692, 1.32121, 1.12953, 1.12953]; //For splitting screen height into 5
    		hidden var textFont = Graphics.FONT_TINY; //Font size
    		var idx, dh, l; //For draw height function
	
	//For page mode (Changing between page 1 and 2)
		var today, dateString, titleStr; //Timestamp variables
		var pg = 1, k = 0; //Page 0: Top 5, Page 1: Top 5-10. Initially 0.
		var currIt = 0, currSymbol; //$/€ Currency iterator and Symbol

    // Load resources here
    function onLayout(dc) {        
        //Get device screen width and height to avoid too many function calls
    		dcHeight = dc.getHeight();
    		dcWidth = dc.getWidth()/3; //Divide by tree to right align text
    		dcWidthBM = dc.getWidth()/8; //Left align bitmap icons
        
        //Loading coin icons as Bitmaps into hash table
        bmapDict = {
    					"BTC" => Ui.loadResource( Rez.Drawables.BTC ),
    					"ETH" => Ui.loadResource( Rez.Drawables.ETH ),
    					"BCH" => Ui.loadResource( Rez.Drawables.BCH ),
    					"XRP" => Ui.loadResource( Rez.Drawables.XRP ),
    					"LTC" => Ui.loadResource( Rez.Drawables.LTC ),
    					"ADA" => Ui.loadResource( Rez.Drawables.ADA ),
    					"MIOTA" => Ui.loadResource( Rez.Drawables.MIOTA ),
    					"XEM" => Ui.loadResource( Rez.Drawables.XEM ),
    					"DASH" => Ui.loadResource( Rez.Drawables.DASH ),
    					"XLM" => Ui.loadResource( Rez.Drawables.XLM ),
    					"XMR" => Ui.loadResource( Rez.Drawables.XMR ),
    					"TRX" => Ui.loadResource( Rez.Drawables.TRX ),
		};
    }
		
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK); //Keep Bg color
        dc.clear();//Clear screen
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK); //Set text color
    		if(commConf == true){
        		drawLastPrice(dc, pg); //Draw prices and logos on screen
        		pg = -pg;
        		return;
    		}else{
    		    //If data is not fetched yet, write out message
        		dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, "Waiting for data", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    // Find height to draw coin icon at
    function drawHeight(dcHeight,index) {
    		dh = (dcHeight/heightSplitter[index])-2; //Base = 23 pixels. Pixel height of logo
    		return dh; //Return height to draw logo at
    	}    
        
    //Draw current prices and logos for top 5 cryptocurrencies
    function drawLastPrice(dc, pg) {
    		//Timestamp of data collection
    		today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); //Get time
		dateString = Lang.format("$1$:$2$:$3$", [today.hour.format("%02d"), today.min.format("%02d"), today.sec.format("%02d")]); //Create timestamp string
		
		//Draw page 1 (initial) or 2 (If page 2, k = 5, this is to find index + 5)
		//Page 1 = 1, Page 2 = -1
		if (pg == -1) {
			k = 5;
			pg = -pg; //Switch page
			titleStr = "Top 6-10";
		} else {
			k = 0;
			pg = -pg; //Switch page
			titleStr = "Top 1-5";
		}
		
		//Set currency ($/€) to show
		currIt += 1;
		if (currIt < 3) {
			currSymbol = ": $";
			curCurrencyPrice = mCurPrice;
		}else if (currIt < 4) {
			currSymbol = ": €";
			curCurrencyPrice = mCurPriceEur;
		}else {
			currIt = 0;
		}
		
		//Draw title (Top)
		dc.drawText(dc.getWidth()/2, 
    					5, 
    					Graphics.FONT_XTINY, 
    					titleStr, 
    					Graphics.TEXT_JUSTIFY_CENTER);
		
		//Draw timestamp (Bottom)
		dc.drawText(dc.getWidth()/2, 
    					dc.getHeight()/heightSplitter[10], 
    					Graphics.FONT_XTINY, 
    					dateString, 
    					Graphics.TEXT_JUSTIFY_CENTER);
		
    		for( var i = 0; i < 5; i++ ) {
    			l = i+k; //Inner iterator plus page index padding (Page 2 = i+5, else i+0)
    			//Draw symbol and price for each coin
    			dc.drawText(dcWidth, 
    			dcHeight/heightSplitter[i], 
    			textFont,
    			mCurrency[l] + currSymbol + curCurrencyPrice[l], 
    			Graphics.TEXT_JUSTIFY_LEFT);
   			//Draw icons for each coin	
			drawIcon(dc, mCurrency[l]); //Call draw icon function
		}
    		
    }
    
    //Draw icon using hashtable of bitmaps.
    //Find the index/position of coin, then draw bitmap to the left of the coin symbol + price.
    function drawIcon(dc, str) {
    		if (mCurrency.indexOf(str) != -1) { //Make sure currency exists
    			idx = mCurrency.indexOf(str); //Find index of currency
    			if (bmapDict.hasKey(str) != false) { //Make sure currency icon exists
    				dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), bmapDict.get(str) ); //Draw bitmap
    			}
    		}
    }
    
    //Get prices and save symbol and price array
    function onPrice(cp) {
        if (cp instanceof CryptoPrice) {        	
			
			//Get prices and coins, and save in array
			for( var i = 0; i < 10; i++ ) {
				mCurPrice[i] = cp.curPrice[i].format("%.2f");
				mCurPriceEur[i] = cp.curPriceEur[i].format("%.2f");
				mCurrency[i] = cp.curSymbol[i];
			}
        		//If current prices are fetched, communication is confirmed. By default, false.
        		if (mCurPrice[0] != null) {
        			commConf = true;
        		}
        	//If data is not fetched yet, throw waiting for data msg.
        }else if (cp instanceof Lang.String) {
        		commConf = false;
       	}
        Ui.requestUpdate(); //Request an update
    }

}
