using Toybox.Communications as Comm;
using Toybox.Time.Gregorian as Gre;
using Toybox.System as Sys;

class CryptoPrice {	//Data of top 5 market cap coins
	var curPrice = new [10]; //Current priceof top 10 (USD $)
	var curPriceEur = new [10]; //Current priceof top 10 (EUR €)
	var currency = new [10]; //Currencies in top 10
}

class PriceModel {
	var cp = null;
	//CoinMarketCap JSON API
	hidden var cryptoPriceURL = "https://api.coinmarketcap.com/v1/ticker/?limit=10&convert=EUR";
	hidden var notify;

  	function initialize(handler)	{
  	   	notify = handler;
        makePriceRequests();    				 
    }
    
    function makePriceRequests() {
    		//Get device specific settings
		var settings = Sys.getDeviceSettings();
		
		//Check if Communications is allowed for app usage
		if (Toybox has :Communications) {
			cp = null; 
			// Get current price and coins from API
			Comm.makeWebRequest(cryptoPriceURL,
		         				 {}, 
		         				 {}, 
		         				 method(:onReceivePrice));
		}else { //If communication fails
      		Sys.println("Communication\nnot\npossible");
      	} 
    }

	function onReceivePrice(responseCode, data) {
        if(responseCode == 200) {
        		if(cp == null) {
            		cp = new CryptoPrice();
			}
			//Remove outer brackets of API call using data[0] if single call for BTC only
         	for( var i = 0; i < 10; i++ ) {
    				cp.curPrice[i] = data[i]["price_usd"].toFloat();
    				cp.curPriceEur[i] = data[i]["price_eur"].toFloat();
    				cp.currency[i] = data[i]["symbol"];
			}
           	notify.invoke(cp);
        }else { //If error in getting data from JSON API
        		Sys.println("Data request failed\nWith response: ");
        		Sys.println(responseCode);
        		Sys.println(data);
        }
    }
}