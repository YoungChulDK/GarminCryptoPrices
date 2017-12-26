using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class CryptoPricesDelegate extends Ui.BehaviorDelegate {

	hidden var nModel;
    function initialize(priceModel) {
    		nModel = priceModel;
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new CryptoPricesMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
	function onNextMode() {
	   	// Callback not working in SIMULATOR, move to onNextMode for testing	
	}
	
	function onPreviousMode() {
	}  

}