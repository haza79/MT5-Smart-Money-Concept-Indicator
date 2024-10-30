// Enums.mqh
#ifndef ENUMS_MQH
#define ENUMS_MQH

// Enum to represent different candle types
enum CandleType {
    CANDLE_NONE,
    CANDLE_BULLISH,
    CANDLE_BEARISH,
    CANDLE_DOJI
};

// Enum to represent swing types
enum SwingType {
    SWING_NONE,
    SWING_HIGH,
    SWING_LOW
};

// Enum to represent fractal types
enum FractalType {
    FRACTAL_HIGH,  // For checking Fractal Highs
    FRACTAL_LOW    // For checking Fractal Lows
};

// Enum to represent trend direction
enum Trend {
    TREND_NONE,
    TREND_BULLISH,
    TREND_BEARISH
};

#endif
