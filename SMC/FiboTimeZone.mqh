#ifndef FIBOTIMEZONE_MQH
#define FIBOTIMEZONE_MQH

#include "Enums.mqh";

class FiboTimeZone {

private:
    double fiboLevel[Fibo_Count];
    double fiboValue[Fibo_Count];
    int baseInterval;

public:
    // Constructor
    int swingHighIndex,swingLowIndex;
    FiboTimeZone() {
        // Initialize fiboValues
        static const double tempFiboLevels[Fibo_Count] = {
            0,1,2,3,5,8
        };

        ArrayCopy(fiboLevel, tempFiboLevels);
    }
   
    // Calculate Fibonacci Circle levels
    void calculateFibo(int firstSwing, int secondSwing) {
        baseInterval = secondSwing - firstSwing;


        for (int i = 0; i < Fibo_Count; i++) {
            double fiboLevelCalc = firstSwing + (baseInterval*fiboLevel[i]);
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
    return fiboLevel[level];
}


    // Print all Fibonacci levels with their values
    void printFiboLevels() {
        Print("Fibonacci Circle Levels:");
        for (int i = 0; i < Fibo_Count; i++) {
            PrintFormat("Level: %f, value: %f", fiboLevel[i], fiboValue[i]);
        }
    }

};

#endif
