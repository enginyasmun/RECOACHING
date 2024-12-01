public class WeatherService {
    private static final String API_KEY = '7a07848f5d084b8e83c140132240906';
    private static final String ENDPOINT = 'http://api.weatherapi.com/v1/current.json';

    @AuraEnabled
    public static String getWeather(String location, Id opportunityId) {
        String url = ENDPOINT + '?key=' + API_KEY + '&q=' + EncodingUtil.urlEncode(location, 'UTF-8');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        
        System.debug('Request URL: ' + url);
        
        try {
            HttpResponse response = http.send(request);
            System.debug('Response status: ' + response.getStatus());
            System.debug('Response body: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                // Deserialize the weather data
                WeatherData weatherData = (WeatherData) JSON.deserialize(response.getBody(), WeatherData.class);
                System.debug('Deserialized weather data: ' + weatherData);

                // Serialize weatherData to JSON string
                String weatherDataJson = JSON.serialize(weatherData);

                // Save the weather data to the opportunity
                Opportunity opp = [SELECT Id, Weather_Data__c FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
                opp.Weather_Data__c = weatherDataJson;
                update opp;

                return weatherDataJson;
            } else {
                throw new AuraHandledException('Error from Weather API: ' + response.getStatus() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new AuraHandledException('Error fetching weather data: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static UserInfoWrapper getUserInfo() {
        User currentUser = [SELECT FirstName, City, State, Country FROM User WHERE Id = :UserInfo.getUserId()];
        System.debug('Current user: ' + currentUser);
        return new UserInfoWrapper(currentUser.FirstName, currentUser.City);
    }

    public class UserInfoWrapper {
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String city;

        public UserInfoWrapper(String firstName, String city) {
            this.firstName = firstName;
            this.city = city;
        }
    }

    public class WeatherData {
        public Current current;
        public Location location;
    }

    public class Current {
        public double temp_c;
        public Condition condition;
    }

    public class Condition {
        public String text;
        public String icon;
    }

    public class Location {
        public String name;
        public String region;
        public String country;
    }
}