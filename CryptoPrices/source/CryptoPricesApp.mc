using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class CryptoPricesApp extends App.AppBase {

    hidden var nView;
    	hidden var nModel;
    hidden var nDelegate;
    
    // onStart() is called on application start up
    function onStart(state) {
    		nView = new CryptoPricesView();
    		nModel = new PriceModel(nView.method(:onPrice));
    		nDelegate = new CryptoPricesDelegate(nModel);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        //return [ new CryptoPricesView(), new CryptoPricesDelegate() ];
        return [ nView, nDelegate ];
    }
}
