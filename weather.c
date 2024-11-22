#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <curl/curl.h>

size_t write_callback(void *buffer, size_t size, size_t nmemb, void *userp) {
    size_t total_size = size * nmemb;
    FILE *file = fopen("raw_data.json", "w"); 
    if (file) {
        fwrite(buffer, 1, total_size, file);
        fclose(file);
    }
    return total_size;
}

void process_data(const char *raw_file, const char *processed_file_path) {
    FILE *raw_data = fopen(raw_file, "r");
    FILE *processed_file = fopen(processed_file_path, "a");
    char line[1024];

    if (!raw_data || !processed_file) {
        perror("Error opening file");
        return;
    }

    fprintf(processed_file, "Data Recorded on: %s\n", __DATE__);

    while (fgets(line, sizeof(line), raw_data)) {
        if (strstr(line, "\"temp\":")) {
            fprintf(processed_file, "Temperature: %s", strchr(line, ':') + 1);
        }
        if (strstr(line, "\"humidity\":")) {
            fprintf(processed_file, "Humidity: %s", strchr(line, ':') + 1);
        }
        if (strstr(line, "\"pressure\":")) {
            fprintf(processed_file, "Pressure: %s", strchr(line, ':') + 1);
        }
        if (strstr(line, "\"speed\":")) {
            fprintf(processed_file, "Wind Speed: %s", strchr(line, ':') + 1);
        }
        if (strstr(line, "\"deg\":")) {
            fprintf(processed_file, "Wind Direction: %s", strchr(line, ':') + 1);
        }
        if (strstr(line, "\"description\":")) {
            fprintf(processed_file, "Description: %s", strchr(line, ':') + 1);
        }
    }

    fprintf(processed_file, "------------------------\n");
    fclose(raw_data);
    fclose(processed_file);
}

int main() {
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if (curl) {
        const char *url = "http://api.openweathermap.org/data/2.5/weather?q=London&appid=4e095b67f35009fbcc6f055e6598c8c0";
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        res = curl_easy_perform(curl);

        if (res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        } else {
            process_data("raw_data.json", "processed_data.txt");
        }

        curl_easy_cleanup(curl);
    }
    return 0;
}

