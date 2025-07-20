#ifndef FIBORETRACE_MQH
#define FIBORETRACE_MQH

#include "Enums.mqh"

class FiboRetrace {
private:
    double fiboLevel[];
    double fiboValue[];
    double swingRange;

public:
    int swingHighIndex, swingLowIndex;

    // Default constructor
    FiboRetrace() {}

    // Set fibo levels dynamically
    void setLevels(const double &inputLevels[]) {
        int count = ArraySize(inputLevels);
        ArrayResize(fiboLevel, count);
        ArrayResize(fiboValue, count);

        for (int i = 0; i < count; i++)
            fiboLevel[i] = inputLevels[i];
    }

    void calculateFibo(double swingHigh, double swingLow, Trend trend) {
        swingRange = swingHigh - swingLow;
        for (int i = 0; i < ArraySize(fiboLevel); i++) {
            double fiboLevelCalc = 0;
            if (trend == TREND_BULLISH)
                fiboLevelCalc = swingHigh - (swingRange * fiboLevel[i]);
            else if (trend == TREND_BEARISH)
                fiboLevelCalc = swingLow + (swingRange * fiboLevel[i]);

            fiboValue[i] = fiboLevelCalc;
        }
    }
    

    double getFiboLevel(int index) {
        if (index < 0 || index >= ArraySize(fiboValue)) return 0.0;
        return fiboValue[index];
    }

    void printFiboLevels() {
        for (int i = 0; i < ArraySize(fiboLevel); i++) {
            PrintFormat("Level: %.3f, Value: %.5f", fiboLevel[i], fiboValue[i]);
        }
    }
};


#endif
