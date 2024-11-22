#include <stdio.h>
#include "weather.h"

int main() {
    fetch_and_process_weather_data("http://api.openweathermap.org/data/2.5/weather?q=London&appid=4e095b67f35009fbcc6f055e6598c8c0");
    return 0;
}

