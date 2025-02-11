#ifndef MACD_CLASS_MQH
#define MACD_CLASS_MQH

class MACD {
private:
    int fastPeriod, slowPeriod, signalPeriod;
    double fastMultiplier, slowMultiplier, signalMultiplier;
    double fastEMA, slowEMA, macd, signal, histogram;
    double macdBuffer[], signalBuffer[], histBuffer[];

public:
    // Constructor - Initializes periods and multipliers
    MACD(int fastP = 12, int slowP = 26, int signalP = 9) {
        fastPeriod = fastP;
        slowPeriod = slowP;
        signalPeriod = signalP;

        fastMultiplier = 2.0 / (fastPeriod + 1);
        slowMultiplier = 2.0 / (slowPeriod + 1);
        signalMultiplier = 2.0 / (signalPeriod + 1);

        fastEMA = slowEMA = macd = signal = histogram = 0.0;

        ArrayResize(macdBuffer, signalPeriod);
        ArrayResize(signalBuffer, signalPeriod);
        ArrayResize(histBuffer, signalPeriod);
        ArrayInitialize(macdBuffer, 0);
        ArrayInitialize(signalBuffer, 0);
        ArrayInitialize(histBuffer, 0);
    }

    // Update MACD with new price
    void update(double closePrice) {
        // Compute Fast & Slow EMA
        if (fastEMA == 0) fastEMA = closePrice;  // Initialize EMA
        else fastEMA = (closePrice * fastMultiplier) + (fastEMA * (1 - fastMultiplier));

        if (slowEMA == 0) slowEMA = closePrice;
        else slowEMA = (closePrice * slowMultiplier) + (slowEMA * (1 - slowMultiplier));

        // Compute MACD Line
        macd = fastEMA - slowEMA;

        // Compute Signal Line (EMA of MACD)
        if (signal == 0) signal = macd;  // Initialize Signal EMA
        else signal = (macd * signalMultiplier) + (signal * (1 - signalMultiplier));

        // Compute Histogram
        histogram = macd - signal;

        // Shift Buffers and Store Values
        for (int i = signalPeriod - 1; i > 0; i--) {
            macdBuffer[i] = macdBuffer[i - 1];
            signalBuffer[i] = signalBuffer[i - 1];
            histBuffer[i] = histBuffer[i - 1];
        }
        macdBuffer[0] = macd;
        signalBuffer[0] = signal;
        histBuffer[0] = histogram;
    }

    // Get Latest Values
    double getMACD() { return macd; }
    double getSignal() { return signal; }
    double getHistogram() { return histogram; }

    // Get Historical Values
    double getMACDHistory(int index) { return macdBuffer[index]; }
    double getSignalHistory(int index) { return signalBuffer[index]; }
    double getHistHistory(int index) { return histBuffer[index]; }
};

#endif
