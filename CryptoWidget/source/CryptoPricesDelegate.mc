using Toybox.WatchUi as Ui;

class CryptoPricesDelegate extends Ui.BehaviorDelegate {

	hidden var Model;
	
    function initialize(priceModel) {
    		Model = priceModel;
    }

    function onSelect() { //When Select is pressed, update and change page view.
        Ui.requestUpdate();
    }
}