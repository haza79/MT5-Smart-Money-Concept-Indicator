#ifndef MACD_CLASS_MQH
#define MACD_CLASS_MQH

class MACD {
private:
    int fastPeriod, slowPeriod, signalPeriod;
    double fastMultiplier, slowMultiplier, signalMultiplier;

    // Current & Previous EMA Values
    double fastEMA, slowEMA, macd, signal, histogram;
    double prevFastEMA, prevSlowEMA, prevMACD, prevSignal, prevHistogram;

    // Buffers for historical values
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
        prevFastEMA = prevSlowEMA = prevMACD = prevSignal = prevHistogram = 0.0;

        ArrayResize(macdBuffer, signalPeriod);
        ArrayResize(signalBuffer, signalPeriod);
        ArrayResize(histBuffer, signalPeriod);
        ArrayInitialize(macdBuffer, 0);
        ArrayInitialize(signalBuffer, 0);
        ArrayInitialize(histBuffer, 0);
    }

    // Update MACD with new price
void update(double closePrice, int index, int totalBars) {
    // Ensure calculations run only on closed candles
    if (index >= totalBars - 1) {
        return;  // Exit if it's the last (incomplete) candle
    }

    // Store previous values
    prevFastEMA = fastEMA;
    prevSlowEMA = slowEMA;
    prevMACD = macd;
    prevSignal = signal;
    prevHistogram = histogram;

    // Compute Fast & Slow EMA
    if (fastEMA == 0) fastEMA = closePrice;
    else fastEMA = (closePrice * fastMultiplier) + (prevFastEMA * (1 - fastMultiplier));

    if (slowEMA == 0) slowEMA = closePrice;
    else slowEMA = (closePrice * slowMultiplier) + (prevSlowEMA * (1 - slowMultiplier));

    // Compute MACD Line
    macd = fastEMA - slowEMA;

    // Compute Signal Line (EMA of MACD)
    if (signal == 0) signal = macd;
    else signal = (macd * signalMultiplier) + (prevSignal * (1 - signalMultiplier));

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

    // Get Previous Values
    double getPrevMACD() { return prevMACD; }
    double getPrevSignal() { return prevSignal; }
    double getPrevHistogram() { return prevHistogram; }

    // Get Historical Values
    double getMACDHistory(int index) { return macdBuffer[index]; }
    double getSignalHistory(int index) { return signalBuffer[index]; }
    double getHistHistory(int index) { return histBuffer[index]; }
};

#endif // MACD_CLASS_MQH
