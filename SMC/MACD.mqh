#ifndef MACDCLASS_MQH
#define MACDCLASS_MQH

class MACDClass {
private:
    double       priceBuffer[];    // Price buffer for calculation
    double       macdLine[];      // MACD Line buffer
    double       signalLine[];    // Signal Line buffer
    double       histogram[];     // MACD Histogram buffer
    double       latestMACD;      // Latest MACD value
    double       latestSignal;    // Latest Signal Line value
    double       latestHistogram; // Latest Histogram value

    int          emaFastPeriod;
    int          emaSlowPeriod;
    int          signalPeriod;
    int          bufferSize;
    double       emaFastPrev;
    double       emaSlowPrev;
    double       signalPrev;

    double CalculateEMA(double price, double prevEMA, int period) {
        double alpha = 2.0 / (period + 1);
        return alpha * price + (1 - alpha) * prevEMA;
    }

public:
    // Constructor
    MACDClass(int fastPeriod, int slowPeriod, int signalPeriod)
        : emaFastPeriod(fastPeriod), emaSlowPeriod(slowPeriod), signalPeriod(signalPeriod),
          emaFastPrev(0), emaSlowPrev(0), signalPrev(0) {
        bufferSize = MathMax(emaSlowPeriod, signalPeriod);
        ArrayResize(priceBuffer, bufferSize);
        ArrayResize(macdLine, bufferSize);
        ArrayResize(signalLine, bufferSize);
        ArrayResize(histogram, bufferSize);
        ArraySetAsSeries(priceBuffer, true);
        ArraySetAsSeries(macdLine, true);
        ArraySetAsSeries(signalLine, true);
        ArraySetAsSeries(histogram, true);
    }

    // Update new price and calculate MACD
    void Update(double price) {
        // Shift price buffer
        for (int i = bufferSize - 1; i > 0; i--) {
            priceBuffer[i] = priceBuffer[i - 1];
        }
        priceBuffer[0] = price;

        // Calculate EMAs
        if (emaFastPrev == 0) {
            emaFastPrev = price;
            emaSlowPrev = price;
        }

        double emaFast = CalculateEMA(price, emaFastPrev, emaFastPeriod);
        double emaSlow = CalculateEMA(price, emaSlowPrev, emaSlowPeriod);
        emaFastPrev = emaFast;
        emaSlowPrev = emaSlow;
        latestMACD = emaFast - emaSlow;

        // Shift MACD line buffer
        for (int i = bufferSize - 1; i > 0; i--) {
            macdLine[i] = macdLine[i - 1];
        }
        macdLine[0] = latestMACD;

        // Calculate Signal Line
        if (signalPrev == 0) {
            signalPrev = latestMACD;
        }
        latestSignal = CalculateEMA(latestMACD, signalPrev, signalPeriod);
        signalPrev = latestSignal;

        // Calculate Histogram
        latestHistogram = latestMACD - latestSignal;
    }

    // Getters for latest values
    double GetLatestMACD() const { return latestMACD; }
    double GetLatestSignal() const { return latestSignal; }
    double GetLatestHistogram() const { return latestHistogram; }
};

#endif