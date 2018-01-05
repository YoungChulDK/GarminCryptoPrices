using Toybox.Communications as Comm;
using Toybox.System as Sys;

class CryptoPrice {	//Data of top 10 market cap coins
	var curPrice = new [10]; //Current $USD price of top 10
	var curPriceEur = new [10]; //Current €EUR price of top 10
	var curSymbol = new [10]; //Currencies in top 10
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
		//Check if Communications is allowed for Widget usage
		if (Toybox has :Communications) {
			cp = null; 
			// Get current price and coin symbol from API
			Comm.makeWebRequest(cryptoPriceURL,
		         				 {}, 
		         				 {}, 
		         				 method(:onReceiveData));
		}else { //If communication fails
      		Sys.println("Communication\nnot\npossible");
      	} 
    }

	function onReceiveData(responseCode, data) {
        if(responseCode == 200) {
        		if(cp == null) {
            		cp = new CryptoPrice();
			}
			//Load data from JSON into arrays of USD prices, EUR prices and coin symbols.
         	for( var i = 0; i < 10; i++ ) {
    				cp.curPrice[i] = data[i]["price_usd"].toFloat();
    				cp.curPriceEur[i] = data[i]["price_eur"].toFloat();
    				cp.curSymbol[i] = data[i]["symbol"];
			}
           	notify.invoke(cp);
        }else { //If error in getting data from JSON API
        		Sys.println("Data request failed\nWith response: ");
        		Sys.println(responseCode);
        }
    }
}