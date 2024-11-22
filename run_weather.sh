#!/bin/bash

PROCESSED_FILE="processed_data.txt"
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
log_data() {
    echo "Data Recorded on: $(date)" >> $PROCESSED_FILE
    echo "Temperature: $1°C" >> $PROCESSED_FILE
    echo "Humidity: $2%" >> $PROCESSED_FILE
    echo "Pressure: $3 hPa" >> $PROCESSED_FILE
    echo "Wind Speed: $4 m/s" >> $PROCESSED_FILE
    echo "Wind Direction: $5°" >> $PROCESSED_FILE
    echo "Description: $6" >> $PROCESSED_FILE
    echo "------------------------" >> $PROCESSED_FILE
}

calculate_averages() {
    local temp_sum=0
    local humidity_sum=0
    local count=0

    while IFS= read -r line; do
        if [[ "$line" == Temperature:* ]]; then
            temp_value=$(echo "$line" | grep -o -E '[0-9.+-]+')
            temp_sum=$(echo "$temp_sum + $temp_value" | bc)
            count=$((count + 1))
        elif [[ "$line" == Humidity:* ]]; then
            humidity_value=$(echo "$line" | grep -o -E '[0-9.+-]+')
            humidity_sum=$(echo "$humidity_sum + $humidity_value" | bc)
        fi
    done < "$PROCESSED_FILE"

    if (( count > 0 )); then
        avg_temp=$(echo "scale=2; $temp_sum / $count" | bc)
        avg_humidity=$(echo "scale=2; $humidity_sum / $count" | bc)
        echo "Average Temperature: $avg_temp°C"
        echo "Average Humidity: $avg_humidity%"
        notify-send "Weather Averages" "Avg Temp: $avg_temp°C, Avg Humidity: $avg_humidity%"
    else
        echo "No data available for averages."
        notify-send "Weather Averages" "No data available for averages."
    fi
}

echo "Fetching data from OpenWeather API..."
curl -s "http://api.openweathermap.org/data/2.5/weather?q=London&appid=4e095b67f35009fbcc6f055e6598c8c0" -o raw_data.json

if [ $? -ne 0 ]; then
    echo "Error fetching data from OpenWeather API. Exiting."
    notify-send "Weather Script Error" "Failed to fetch data from OpenWeather API."
    exit 1
fi

echo "Processing data..."
TEMP=$(jq '.main.temp' raw_data.json)
HUMIDITY=$(jq '.main.humidity' raw_data.json)
PRESSURE=$(jq '.main.pressure' raw_data.json)
WIND_SPEED=$(jq '.wind.speed' raw_data.json)
WIND_DIR=$(jq '.wind.deg' raw_data.json)
DESCRIPTION=$(jq -r '.weather[0].description' raw_data.json)

TEMP_C=$(echo "$TEMP - 273.15" | bc)

echo "Temperature: $TEMP_C°C"
echo "Humidity: $HUMIDITY%"
echo "Pressure: $PRESSURE hPa"
echo "Wind Speed: $WIND_SPEED m/s"
echo "Wind Direction: $WIND_DIR°"
echo "Description: $DESCRIPTION"

echo "Checking for critical conditions..."

if (( $(echo "$TEMP_C < 20" | bc -l) )); then
    echo "Temperature is below 20°C! Triggering alert."
    notify-send "Weather Alert" "Temperature is below 20°C!"
fi

if (( $HUMIDITY > 80 )); then
    echo "Humidity is above 80%! Triggering alert."
    notify-send "Weather Alert" "Humidity is above 80%!"
fi

# Log data to the processed file
log_data "$TEMP_C" "$HUMIDITY" "$PRESSURE" "$WIND_SPEED" "$WIND_DIR" "$DESCRIPTION"

echo "Calculating averages..."
calculate_averages

echo "Automation completed."

