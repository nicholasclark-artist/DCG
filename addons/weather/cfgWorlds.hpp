// based on data from weatherspark.com

class CfgWorlds {
    class CAWorld;

    // https://weatherspark.com/y/148550/Average-Weather-at-Limnos-Airport-Greece-Year-Round
    class Altis: CAWorld {
        // cloud cover data, {mostly clear, partly cloudy, mostly cloudy, overcast}
        // sample first day of each month
        GVARMAIN(cloudCover)[] = {
            {0.33,0.44,0.54,0.64}, // January
            {0.33,0.45,0.54,0.66}, // February
            {0.35,0.45,0.54,0.64}, // March
            {0.38,0.48,0.58,0.78}, // April
            {0.43,0.54,0.63,0.73}, // May
            {0.56,0.66,0.75,0.84}, // June
            {0.82,0.88,0.93,0.95}, // July
            {0.91,0.95,0.97,0.99}, // August
            {0.79,0.86,0.90,0.94}, // September
            {0.53,0.63,0.73,0.83}, // October
            {0.40,0.50,0.60,0.70}, // November
            {0.31,0.41,0.51,0.62} // December
        };

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
        
        // precipitation probability
        GVARMAIN(precipitation)[] = {0.28,0.25,0.24,0.20,0.14,0.11,0.06,0.04,0.07,0.15,0.18,0.30};
    };
    class Stratis: CAWorld {
        GVARMAIN(overcast)[] = {0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62};
    };
    class Tanoa: CAWorld {
        GVARMAIN(overcast)[] = {0.80,0.78,0.70,0.63,0.57,0.55,0.48,0.49,0.57,0.64,0.71,0.79};
    };
    class Takistan: CAWorld {
        GVARMAIN(overcast)[] = {0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41};
    };
    class Kunduz: CAWorld {
        GVARMAIN(overcast)[] = {0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41};
    };
    class Mountains_ACR: CAWorld {
        GVARMAIN(overcast)[] = {0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41};
    };
    class Chernarus: CAWorld {
        GVARMAIN(overcast)[] = {0.98,0.94,0.85,0.76,0.70,0.74,0.70,0.64,0.73,0.84,0.93,0.97};
    };
    class Chernarus_Summer: CAWorld {
        GVARMAIN(overcast)[] = {0.73,0.72,0.70,0.72,0.74,0.70,0.68,0.65,0.64,0.69,0.70,0.75};
    };
};