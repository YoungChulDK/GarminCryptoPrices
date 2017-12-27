using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.Math as Math;
using Toybox.System as Sys;

class CryptoWidgetView extends Ui.View {

	//Fields
	hidden var commConf = false; // Confirm communication
	hidden var mCurrency = new [5]; //Initializing array for top 5 currencies
	hidden var mCurPrice = new [5]; //Initializing array for current price of top 5 currencies
	hidden var dcHeight, dcWidth, dcWidthBM; //Device screen height and width
	hidden var heightSplitter = [8.72, 3.633, 2.29473, 1.67692, 1.32121]; //For splitting screen height into 5
    hidden var textFont = Graphics.FONT_TINY; //Font size
    var btcBmp, ethBmp, bchBmp, xrpBmp, ltcBmp; //Storing bitmaps
    var idx, dh; //For draw height function

    // Load your resources here
    function onLayout(dc) {
    		//Text and BG color
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        
        //Load bitmap from resources/drawables
        btcBmp = Ui.loadResource( Rez.Drawables.BTC );
        ethBmp = Ui.loadResource( Rez.Drawables.ETH );
        bchBmp = Ui.loadResource( Rez.Drawables.BCH );
        xrpBmp = Ui.loadResource( Rez.Drawables.XRP );
        ltcBmp = Ui.loadResource( Rez.Drawables.LTC );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        
    		if(commConf == true){
        		dc.clear(); //Clear screen
        		drawLastPrice(dc); //Draw prices and logos on screen
            	return;
    		}else{
    		    dc.clear(); //Clear screen
    		    //If data is not fetched yet, write out message
        		dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, "Waiting for data", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    // Find height to draw logo at
    function drawHeight(dcHeight,index) {
    		dh = (dcHeight/heightSplitter[index])-2; //Base = 23 pixels. Pixel height of logo
    		return dh; //Return height to draw logo at
    	}    
        
    //Draw current prices and logos for top 5 currencies
    function drawLastPrice(dc) {
    		//Get device screen width and height to avoid too many function calls
    		dcHeight = dc.getHeight();
    		dcWidth = dc.getWidth()/3; //Divide by tree to right align text
    		dcWidthBM = dc.getWidth()/8; //To left align bitmap icons
    
		dc.drawText(dcWidth, 
    					dcHeight/heightSplitter[0], 
    					textFont, 
    					mCurrency[0] + ": $" + mCurPrice[0], 
    					Graphics.TEXT_JUSTIFY_LEFT);
    					
    		dc.drawText(dcWidth, 
    					dcHeight/heightSplitter[1], 
    					textFont, 
    					mCurrency[1] + ": $" + mCurPrice[1], 
    					Graphics.TEXT_JUSTIFY_LEFT);
    
		dc.drawText(dcWidth, 
    					dcHeight/heightSplitter[2], 
    					textFont, 
    					mCurrency[2] + ": $" + mCurPrice[2], 
    					Graphics.TEXT_JUSTIFY_LEFT);
    					
		dc.drawText(dcWidth, 
    					dcHeight/heightSplitter[3], 
    					textFont, 
    					mCurrency[3] + ": $" + mCurPrice[3], 
    					Graphics.TEXT_JUSTIFY_LEFT);

		dc.drawText(dcWidth, 
    					dcHeight/heightSplitter[4], 
    					textFont, 
    					mCurrency[4] + ": $" + mCurPrice[4], 
    					Graphics.TEXT_JUSTIFY_LEFT);
    		
    		//Change the logos, or add more in case other coins move up into top 5 in Market Cap.
    		
    		//Update this later for more efficient code
    		if (mCurrency.indexOf("BTC") != -1) {
    			idx = mCurrency.indexOf("BTC");
    			dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), btcBmp );
    		}
    		if (mCurrency.indexOf("ETH") != -1) {
    			idx = mCurrency.indexOf("ETH");
    			dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), ethBmp );
    		}
    		if (mCurrency.indexOf("BCH") != -1) {
    			idx = mCurrency.indexOf("BCH");
    			dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), bchBmp );
    		}
    		if (mCurrency.indexOf("XRP") != -1) {
    			idx = mCurrency.indexOf("XRP");
    			dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), xrpBmp );
    		}
    		if (mCurrency.indexOf("LTC") != -1) {
    			idx = mCurrency.indexOf("LTC");
    			dc.drawBitmap( dcWidthBM, drawHeight(dcHeight, idx), ltcBmp );
    		}
    }
        if (cp instanceof CryptoPrice) {        	
			
			//Get prices and coins, and save in array
			for( var i = 0; i < 5; i++ ) {
				mCurPrice[i] = cp.curPrice[i].format("%.2f");
				mCurrency[i] = cp.currency[i];
			}
        		
        		//If current prices are fetched, communication is confirmed. By default, false.
        		if (mCurPrice[0] != null) {
        			commConf = true;
        		}
        	//If data is not fetched yet, throw waiting for data msg.
        }else if (cp instanceof Lang.String) {
        		commConf = false;	 
       	}
        Ui.requestUpdate();
    }

}
