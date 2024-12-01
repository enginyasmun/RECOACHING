import { LightningElement, track } from 'lwc';
import fetchStockData from '@salesforce/apex/AlphaVantageAPI.fetchStockData';

export default class LwcStockData extends LightningElement {
    @track stockData = {};
    @track error;
    symbol = 'AAPL'; // Default stock symbol

    connectedCallback() {
        this.loadStockData();
    }

    loadStockData() {
        fetchStockData({ symbol: this.symbol })
            .then((data) => {
                if (data.error) {
                    this.error = data.error;
                    this.stockData = {};
                } else {
                    this.stockData = data;
                    this.error = undefined;
                }
            })
            .catch((error) => {
                this.error = error.body ? error.body.message : error.message;
                this.stockData = {};
            });
    }

    handleSymbolChange(event) {
        this.symbol = event.target.value;
        this.loadStockData();
    }
}
