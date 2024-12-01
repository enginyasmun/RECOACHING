public class AlphaVantageAPI {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> fetchStockData(String symbol) {
        // Your Alpha Vantage API key
        String apiKey = 'GELPJEH607UZWP79';
        String function = 'TIME_SERIES_DAILY';
        
        // Construct the API URL
        String url = 'https://www.alphavantage.co/query?function=' + function + 
                     '&symbol=' + symbol + '&apikey=' + apiKey;
        
        // Initialize the result map to store stock data
        Map<String, String> stockData = new Map<String, String>();
        
        // Perform the HTTP callout
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setTimeout(60000); // Set timeout to 60 seconds
        
        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                // Parse the JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                // Extract time series data
                Map<String, Object> timeSeries = (Map<String, Object>) jsonResponse.get('Time Series (Daily)');
                
                // Process and return the first data point
                if (timeSeries != null && !timeSeries.isEmpty()) {
                    String latestDate = (String) timeSeries.keySet().iterator().next();
                    Map<String, Object> dailyData = (Map<String, Object>) timeSeries.get(latestDate);
                    
                    stockData.put('date', latestDate);
                    stockData.put('open', String.valueOf(dailyData.get('1. open')));
                    stockData.put('high', String.valueOf(dailyData.get('2. high')));
                    stockData.put('low', String.valueOf(dailyData.get('3. low')));
                    stockData.put('close', String.valueOf(dailyData.get('4. close')));
                    stockData.put('volume', String.valueOf(dailyData.get('5. volume')));
                } else {
                    stockData.put('error', 'No time series data found.');
                }
            } else {
                stockData.put('error', 'HTTP error: ' + response.getStatus());
            }
        } catch (Exception e) {
            stockData.put('error', 'Exception: ' + e.getMessage());
        }
        
        return stockData;
    }
}










// public class AlphaVantageAPI {
//     @AuraEnabled

//     // Method to fetch stock data from Alpha Vantage
//     public static void fetchStockData(String symbol) {
//         // Your Alpha Vantage API key
//         String apiKey = 'GELPJEH607UZWP79';
//         String function = 'TIME_SERIES_DAILY';
        
//         // Construct the API URL
//         String url = 'https://www.alphavantage.co/query?function=' + function + 
//                      '&symbol=' + symbol + '&apikey=' + apiKey;
        
//         // Perform the HTTP callout
//         Http http = new Http();
//         HttpRequest request = new HttpRequest();
//         request.setEndpoint(url);
//         request.setMethod('GET');
//         request.setTimeout(60000); // Set timeout to 60 seconds
        
//         try {
//             HttpResponse response = http.send(request);
            
//             if (response.getStatusCode() == 200) {
//                 // Parse the JSON response
//                 Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
//                 // Extract time series data
//                 Map<String, Object> timeSeries = (Map<String, Object>) jsonResponse.get('Time Series (Daily)');
                
//                 // Process and log the first few data points
//                 if (timeSeries != null) {
//                     for (String date1 : timeSeries.keySet()) {
//                         Map<String, Object> dailyData = (Map<String, Object>) timeSeries.get(date1);
//                         System.debug('Date: ' + date1);
//                         System.debug('Open: ' + (String) dailyData.get('1. open'));
//                         System.debug('High: ' + (String) dailyData.get('2. high'));
//                         System.debug('Low: ' + (String) dailyData.get('3. low'));
//                         System.debug('Close: ' + (String) dailyData.get('4. close'));
//                         System.debug('Volume: ' + (String) dailyData.get('5. volume'));
//                         break; // Log only the first data point for simplicity
//                     }
//                 } else {
//                     System.debug('No time series data found.');
//                 }
//             } else {
//                 System.debug('Error: ' + response.getStatus());
//             }
//         } catch (Exception e) {
//             System.debug('Exception: ' + e.getMessage());
//         }
//     }
// }