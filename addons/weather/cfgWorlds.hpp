// based on data from weatherspark.com

class CfgWorlds {
    class CAWorld;

    // https://weatherspark.com/y/148550/Average-Weather-at-Limnos-Airport-Greece-Year-Round
    class Altis: CAWorld {
        // probability of mostly cloudy / overcast sky
        // sample first day of each month
        GVARMAIN(cloudCover)[] = {0.54,0.54,0.54,0.58,0.63,0.75,0.93,0.97,0.90,0.73,0.60,0.51};

        // probability of precipitation
        GVARMAIN(precipitation)[] = {0.28,0.25,0.24,0.20,0.14,0.11,0.06,0.04,0.07,0.15,0.18,0.30};
        
        // rainfall amount in inches, {rainfall avg, rainfall min, rainfall max}
        // sample first day of each month
        GVARMAIN(rainfall)[] = {
            {2.9,0.8,5.0}, // January
            {2.5,0.3,5.1}, // February
            {2.1,0.6,4.5}, // March
            {1.7,0.4,3.3}, // April
            {1.1,0.1,2.8}, // May
            {1.0,0.1,2.3}, // June
            {0.3,0.0,1.0}, // July
            {0.4,0.0,1.5}, // August
            {0.5,0.0,1.6}, // September
            {1.5,0.1,3.5}, // October
            {2.3,0.6,4.4}, // November
            {3.5,0.9,6.5} // December
        };
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