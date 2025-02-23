#ifndef FIBOCIRCLE_MQH
#define FIBOCIRCLE_MQH

#include "Enums.mqh";

class FiboCircle {

private:
    double fiboValues[Fibo_Count];
    double fiboTopValue[Fibo_Count], fiboBottomValue[Fibo_Count];
    double center, radius;

public:
    // Constructor
    FiboCircle() {
        // Initialize fiboValues
        static const double tempFiboValues[Fibo_Count] = {
            0.236, 0.382, 0.5, 0.618, 0.786, 0.887, 
            1.13, 1.272, 1.618, 2.618, 4.236
        };

        ArrayCopy(fiboValues, tempFiboValues);
    }
   
    // Calculate Fibonacci Circle levels
    void calculateFibo(double swingHigh, double swingLow) {
        center = (swingHigh + swingLow) / 2;
        radius = (swingHigh - swingLow) / 2;


        for (int i = 0; i < Fibo_Count; i++) {
            double fiboLevelCalc = radius * fiboValues[i];
            fiboTopValue[i] = center + fiboLevelCalc;
            fiboBottomValue[i] = center - fiboLevelCalc;
        }
    }
    
    // Add this function inside the FiboCircle class
double getFiboLevel(FiboLevel level, bool isTop = true) {
    if (level < 0 || level >= Fibo_Count) {
        Print("Invalid FiboLevel enum value.");
        return 0.0;
    }

    // Return the top or bottom value based on the 'isTop' flag
    if (isTop) {
        return fiboTopValue[level];
    } else {
        return fiboBottomValue[level];
    }
}


    // Print all Fibonacci levels with their values
    void printFiboLevels() {
        Print("Fibonacci Circle Levels:");
        for (int i = 0; i < Fibo_Count; i++) {
            PrintFormat("Level: %f, Top: %f, Bottom: %f", fiboValues[i], fiboTopValue[i], fiboBottomValue[i]);
        }
    }

};

#endif
