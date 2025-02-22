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

enum MarketStructureType {
    MS_NONE,
    MS_BULLISH_BOS,  // Bullish Break of Structure
    MS_BEARISH_BOS,  // Bearish Break of Structure
    MS_BULLISH_CHOCH, // Bullish Change of Character
    MS_BEARISH_CHOCH  // Bearish Change of Character
};

enum MACDPosition {
   MACD_NONE,
   MACD_ABOVE,
   MACD_BELOW
};

enum MACDFractalType {
   MACD_FRACTAL_NONE,
   MACD_FRACTAL_ABOVE,
   MACD_FRACTAL_BELOW
};

enum FiboTopOrBottom{
   FIBO_TOP,
   FIBO_BOTTOM
};

enum FiboLevel {
    Fibo_236 = 236,
    Fibo_382 = 382,
    Fibo_500 = 500,
    Fibo_618 = 618,
    Fibo_786 = 786,
    Fibo_887 = 887,
    Fibo_1130 = 1130,
    Fibo_1272 = 1272,
    Fibo_1618 = 1618,
    Fibo_2618 = 2618,
    Fibo_4236 = 4236
};


#endif
