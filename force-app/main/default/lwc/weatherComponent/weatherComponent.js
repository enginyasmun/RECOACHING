import { LightningElement, track, api } from 'lwc';
import getWeather from '@salesforce/apex/WeatherService.getWeather';
import getUserInfo from '@salesforce/apex/WeatherService.getUserInfo';

export default class WeatherLWC extends LightningElement {
    @api recordId; // Opportunity ID
    @track weatherData;
    @track error;
    @track greeting;
    location;

    connectedCallback() {
        this.setDefaultLocation();
    }

    setDefaultLocation() {
        getUserInfo()
            .then((result) => {
                console.log('User info:', result);
                this.greeting = result.firstName;
                this.location = result.city ? result.city : 'San Francisco';
                this.fetchWeatherData();
            })
            .catch((error) => {
                console.error('Error fetching user info:', error);
                this.location = 'San Francisco';
                this.fetchWeatherData();
            });
    }

    handleLocationChange(event) {
        this.location = event.target.value;
        this.fetchWeatherData();
    }

    fetchWeatherData() {
        console.log('Fetching weather data for location:', this.location);
        getWeather({ location: this.location, opportunityId: this.recordId })
            .then((result) => {
                console.log('Weather data:', result);
                const weatherData = JSON.parse(result);
                this.weatherData = {
                    locationName: weatherData.location.name,
                    locationRegion: weatherData.location.region,
                    locationCountry: weatherData.location.country,
                    temperature: weatherData.current.temp_c,
                    conditionText: weatherData.current.condition.text,
                    conditionIcon: weatherData.current.condition.icon,
                };
                this.error = undefined;
            })
            .catch((error) => {
                console.error('Error fetching weather data:', error);
                this.weatherData = undefined;
                this.error = error.body ? error.body.message : error.message;
            });
    }
}