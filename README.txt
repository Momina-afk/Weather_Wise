Description:
The Weather Monitoring System is a C-based program that fetches real-time weather data, processes it, stores it, and sends alerts for critical conditions. It pulls data from the OpenWeather API, including temperature, humidity, and wind speed, and allows users to track and analyze weather patterns.
Features:
 1-Real-Time Weather Data: Fetches live weather data like temperature, humidity, and wind speed.
 2-Data Storage: Saves both raw and processed weather data in raw_data.json and processed_data.txt.
 3-Real-Time Alerts: Notifies users if the temperature drops below 20°C or if the humidity exceeds 80%.
 4-Automation: A shell script automates the process of fetching and processing data.
 5-Optimized Memory Usage: Uses pointers and dynamic memory management to handle data efficiently.
Prerequisites
This project assumes that you're using a Linux-based operating system (like Ubuntu, Debian, or CentOS). The instructions provided here are intended for a Linux environment
Setup:
1. Install Dependencies
Before running the program, you'll need to install a few dependencies:
command:sudo apt-get install libcurl4-openssl-dev jq bc libnotify-bin
These libraries/tools are necessary for:
    libcurl: Fetching weather data from the OpenWeather API.
    jq: Parsing the JSON response from the API.
    bc: Performing calculations.
    libnotify-bin: Sending desktop notifications.
2. Clone the Repository
Clone the project repository to your local machine:
command:git clone <https://github.com/Momina-afk/Weather_Wise.git>
3. Compile the Program
The project includes C programs (main.c and weather.c) for processing weather data. Compile them using gcc:
command:gcc -o weather_monitor main.c weather.c -lcurl
4. Run the Program
To fetch and process the weather data, execute the compiled program:
command:./weather_monitor
This will fetch the weather data from the OpenWeather API, process it, and display it in the terminal.
Automate the Process with Cron.

You can use a shell script (run_weather.sh) to automate the fetching and processing of weather data. Set up a cron job to run the script at specified times.
1. Configure Cron Jobs
To automatically run the script at specific times (e.g., every day at 12:00 AM, 12:15 AM, 12:30 AM, and 12:45 AM), follow these steps:
a. Edit the crontab:
Open the crontab editor by running:
command:crontab -e
b. Add the following lines to schedule the script:
command:0,15,30,45 0 * * * /home/user/Downloads/run_weather.sh >> /home/user/Downloads/weather_log.txt 2>&1
This will run the run_weather.sh script every day at 12:00 AM, 12:15 AM, 12:30 AM, and 12:45 AM.
2. Enable Notifications for Automated Runs
To ensure that notifications work even when the script is running in the background (e.g., via cron), add the following configuration to your crontab:
command:0,15,30,45 0 * * * DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /home/user/Downloads/run_weather.sh >> /home/user/Downloads/weather_log.txt 2>&1
This ensures that the notifications will be displayed correctly, even if the script is run in a non-interactive environment like cron.
Notifications
The program uses notify-send to alert the user to critical conditions like:
    Temperature falling below 20°C
    Humidity rising above 80%
File Structure
 1-main.c: Contains the main program to fetch and process weather data.
 2-weather.c: Contains functions for interacting with the OpenWeather API and processing the data.
 3-weather.h: Header file with function declarations.
 4-run_weather.sh: Shell script to automate data fetching and processing.
 5-raw_data.json: File that stores the raw weather data from the API.
 6-processed_data.txt: File where processed weather data is stored for analysis.
Future Enhancements
 1-GUI: A graphical user interface (GUI) for a more user-friendly experience.
 2-Multi-City Support: Extend the system to support fetching data for multiple cities.
 3-Database Integration: Store weather data in a database for long-term tracking.
License
 This project is licensed under the MIT License.

