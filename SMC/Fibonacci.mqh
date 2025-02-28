#ifndef FIBONACCI_MQH
#define FIBONACCI_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";

class Fibonacci {
private:
    BarData* barData;
    MacdMarketStructureClass* macdMarketStructure;
    
    int index;
    int macdSwingHigh, macdSwingLow;
    double macdSwingHighPrice, macdSwingLowPrice;

    void fiboCircleHandle() {
        Print("High Time: ", barData.GetTime(macdSwingHigh), " | Low Time: ", barData.GetTime(macdSwingLow));
        fiboCircle.calculateFibo(macdSwingHighPrice, macdSwingLowPrice);
    }

public:
   
   FiboCircle fiboCircle;
   
    void init(BarData* barDataInstance, MacdMarketStructureClass* macdMarketStructureInstance) {
        barData = barDataInstance;
        macdMarketStructure = macdMarketStructureInstance;
        fiboCircle = new FiboCircle();
        macdSwingHigh = -1;
        macdSwingLow = -1;
        macdSwingHighPrice = 0;
        macdSwingLowPrice = 0;
    }

    void update(int iIndex, int rates_total) {
        if (iIndex >= rates_total - 1) return;

        int newHigh = macdMarketStructure.getLatestMajorHighIndex();
        int newLow = macdMarketStructure.getLatestMajorLowIndex();

        if (newHigh == -1 || newLow == -1 || (newHigh == macdSwingHigh && newLow == macdSwingLow)) return;

        macdSwingHigh = newHigh;
        macdSwingLow = newLow;
        macdSwingHighPrice = macdMarketStructure.getLatestmajorHighPrice();
        macdSwingLowPrice = macdMarketStructure.getLatestMajorLowPrice();

        if (macdMarketStructure.latestMarketStructure != MS_NONE) {
            fiboCircleHandle();
        }
    }
};

#endif
