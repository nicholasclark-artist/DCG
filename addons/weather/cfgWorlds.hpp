/*
fog reference:
    https://en.wikipedia.org/wiki/Fog
    https://www.weather.gov/safety/fog-radiation 
    http://www.theweatherprediction.com/fog/
*/

class CfgWorlds {
    class CAWorld;
    class Altis: CAWorld {
        // temperature in degrees celsius
        // https://weatherspark.com/y/148550/Average-Weather-at-Limnos-Airport-Greece-Year-Round
        GVARMAIN(tempDay)[] = {11,10,11,15,19,25,29,30,27,23,18,14};
        GVARMAIN(tempNight)[] = {5,4,5,8,11,15,19,21,19,15,11,7};

        // relative humidity
        // https://www.weather-atlas.com/en/greece/myrina-climate
        GVARMAIN(humidity)[] = {0.77,0.75,0.75,0.73,0.68,0.61,0.57,0.62,0.66,0.72,0.77,0.78};

        // probability of clear conditions
        // https://weatherspark.com/y/148550/Average-Weather-at-Limnos-Airport-Greece-Year-Round
        GVARMAIN(clouds)[] = {0.54,0.54,0.54,0.58,0.63,0.75,0.93,0.97,0.90,0.73,0.60,0.51};
        // probability of precipitation
        GVARMAIN(precipitation)[] = {0.28,0.25,0.24,0.20,0.14,0.11,0.06,0.04,0.07,0.15,0.18,0.30};
        // rainfall amount in millimeters, {min, max, avg}
        GVARMAIN(rainfall)[] = {{20,127,73},{8,130,63},{15,114,55},{11,84,44},{2,72,31},{2,58,25},{0,26,10},{0,39,10},{0,41,14},{3,89,38},{16,112,57},{24,164,89}};
    };

    class Stratis: CAWorld {
        // https://weatherspark.com/y/90554/Average-Weather-in-%C3%81gios-Efstr%C3%A1tios-Greece-Year-Round
        GVARMAIN(tempDay)[] = {12,11,12,15,19,24,27,28,26,22,18,14};
        GVARMAIN(tempNight)[] = {7,7,7,10,13,17,21,22,20,17,13,9};

        // https://www.weather-atlas.com/en/greece/myrina-climate
        GVARMAIN(humidity)[] = {0.77,0.75,0.75,0.73,0.68,0.61,0.57,0.62,0.66,0.72,0.77,0.78};

        // https://weatherspark.com/y/90554/Average-Weather-in-%C3%81gios-Efstr%C3%A1tios-Greece-Year-Round
        GVARMAIN(clouds)[] = {0.52,0.52,0.54,0.58,0.64,0.76,0.93,0.97,0.90,0.73,0.59,0.50};
        GVARMAIN(precipitation)[] = {0.29,0.28,0.26,0.21,0.14,0.11,0.06,0.03,0.07,0.16,0.20,0.32};
        GVARMAIN(rainfall)[] = {{24,160,85},{11,161,75},{18,130,64},{11,103,51},{5,75,33},{1,67,26},{9,29,9},{0,23,7},{1,54,17},{1,108,45},{18,143,70},{28,204,106}};
    };

    class Tanoa: CAWorld {
        // http://www.iten-online.ch/klima/australien/fidschi/suva.htm
        GVARMAIN(tempDay)[] = {30,31,30,29,28,27,26,26,27,27,28,29};
        GVARMAIN(tempNight)[] = {23,23,23,23,21,21,20,20,20,21,22,23};

        // https://weather-and-climate.com/average-monthly-Humidity-perc,suva,Fiji
        GVARMAIN(humidity)[] = {0.81,0.83,0.85,0.84,0.80,0.80,0.78,0.76,0.77,0.78,0.79,0.80};

        // https://weatherspark.com/y/144952/Average-Weather-in-Suva-Fiji-Year-Round
        GVARMAIN(clouds)[] = {0.22,0.21,0.19,0.27,0.37,0.46,0.56,0.61,0.61,0.50,0.37,0.30};
        GVARMAIN(precipitation)[] = {0.48,0.52,0.53,0.52,0.37,0.26,0.19,0.23,0.22,0.27,0.28,0.39};
        GVARMAIN(rainfall)[] = {{77,350,201},{80,399,229},{89,398,233},{86,396,231},{41,306,168},{23,207,108},{9,152,70},{10,187,80},{11,188,82},{16,224,108},{31,239,116},{51,310,167}};
    };

    class Takistan: CAWorld {

    };
    class Kunduz: CAWorld {

    };
    class Mountains_ACR: CAWorld {

    };
    class Chernarus: CAWorld {

    };
};