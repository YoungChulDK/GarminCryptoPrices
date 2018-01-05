using Toybox.Application as App;

class CryptoWidgetApp extends App.AppBase {

    hidden var View;
    	hidden var Model;
    hidden var Delegate;
    
    //Called on application start up
    function onStart(state) {
    		View = new CryptoWidgetView();
    		Model = new PriceModel(View.method(:onPrice));
    		Delegate = new CryptoPricesDelegate(Model);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ View, Delegate ];
    }

}