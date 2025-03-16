#ifndef FIBORETRACE_MQH
#define FIBORETRACE_MQH

#include "Enums.mqh";

class FiboRetrace {

private:
    double fiboLevel[Fibo_Count];
    double fiboValue[Fibo_Count];
    double swingRange;

public:
    // Constructor
    int swingHighIndex,swingLowIndex;
    FiboRetrace() {
        // Initialize fiboValues
        static const double tempFiboValues[Fibo_Count] = {
            0.5, 0.618, 0.786, 0.887
        };

        ArrayCopy(fiboLevel, tempFiboValues);
    }
   
    // Calculate Fibonacci Circle levels
    void calculateFibo(double swingHigh, double swingLow, Trend trend) {
        swingRange = swingHigh - swingLow;
        
        for (int i = 0; i < Fibo_Count; i++) {
            double fiboLevelCalc = 0;
            if(trend == TREND_BULLISH){
               fiboLevelCalc = swingHigh - (swingRange*fiboLevel[i]);
            }else if(trend == TREND_BEARISH){
               fiboLevelCalc = swingLow + (swingRange*fiboLevel[i]);
            }
            fiboValue[i] = fiboLevelCalc;
        }
    }
    
    // Add this function inside the FiboCircle class
double getFiboLevel(FiboLevel level) {
    if (level < 0 || level >= Fibo_Count) {
        Print("Invalid FiboLevel enum value.");
        return 0.0;
    }

    // Return the top or bottom value based on the 'isTop' flag
    return fiboValue[level];
}


    // Print all Fibonacci levels with their values
    void printFiboLevels() {
        Print("Fibonacci Circle Levels:");
        for (int i = 0; i < Fibo_Count; i++) {
            PrintFormat("Level: %f, Value: %f", fiboLevel[i], fiboValue[i]);
        }
    }

};

#endif
