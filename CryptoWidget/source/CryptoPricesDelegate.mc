using Toybox.WatchUi as Ui;

class CryptoPricesDelegate extends Ui.BehaviorDelegate {

	hidden var nModel;
	
    function initialize(priceModel) {
    		nModel = priceModel;
    }

    function onMenu() {
    }
    
	function onNextMode() {
	}
	
	function onPreviousMode() {
	}  

    function onSelect() { //When select is pressed, update and change page view.
        Ui.requestUpdate();
    }
}