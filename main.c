#include <stdio.h>
#include "weather.h"

int main() {
    fetch_and_process_weather_data("http://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY"); #replace it with your api key
    return 0;
}

