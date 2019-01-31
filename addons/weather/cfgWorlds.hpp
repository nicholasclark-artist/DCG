/*
based on data from weatherspark.com

fog reference:
    https://www.weather.gov/safety/fog-radiation 
    http://www.theweatherprediction.com/fog/
    https://www.metoffice.gov.uk/learning/clouds/fog
*/

class CfgWorlds {
    class CAWorld;

    // https://weatherspark.com/y/148550/Average-Weather-at-Limnos-Airport-Greece-Year-Round
    // https://www.weather-atlas.com/en/greece/myrina-climate
    class Altis: CAWorld {
        // temperature in degrees celsius
        // sample first day of each month
        GVARMAIN(tempDay)[] = {11,10,11,15,19,25,29,30,27,23,18,14};
        GVARMAIN(tempNight)[] = {5,4,5,8,11,15,19,21,19,15,11,7};

        // relative humidity
        // monthly averages
        GVARMAIN(humidity)[] = {0.77,0.75,0.75,0.73,0.68,0.61,0.57,0.62,0.66,0.72,0.77,0.78};

        // probability of clear conditions
        // sample first day of each month
        GVARMAIN(clouds)[] = {0.54,0.54,0.54,0.58,0.63,0.75,0.93,0.97,0.90,0.73,0.60,0.51};

        // probability of precipitation
        GVARMAIN(precipitation)[] = {0.28,0.25,0.24,0.20,0.14,0.11,0.06,0.04,0.07,0.15,0.18,0.30};
        
        // rainfall amount in millimeters, {min, max, avg}
        // sample first day of each month
        GVARMAIN(rainfall)[] = {{20,127,73},{8,130,63},{15,114,55},{11,84,44},{2,72,31},{2,58,25},{0,26,10},{0,39,10},{0,41,14},{3,89,38},{16,112,57},{24,164,89}};
    };
    class Stratis: CAWorld {

    };
    class Tanoa: CAWorld {

    };
    class Takistan: CAWorld {

    };
    class Kunduz: CAWorld {

    };
    class Mountains_ACR: CAWorld {

    };
    class Chernarus: CAWorld {

    };
    class Chernarus_Summer: CAWorld {

    };
};