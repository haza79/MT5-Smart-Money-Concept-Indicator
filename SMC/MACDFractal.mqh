#ifndef MACDFRACTALCLASS_MQH
#define MACDFRACTALCLASS_MQH

#include "BarData.mqh"
#include "Enums.mqh"
#include "MACD.mqh"
#include "CandleBreakAnalyzerStatic.mqh"

class MACDFractalClass {
private:
    int index;
    
    BarData* barData;
    MACD* macd;
    
    MACDPosition macdPosition;
    int startIndex, endIndex;
    
    MACDPosition getMACDPosition() {
        if (macd.getMACD() < 0) {
            return MACD_BELOW;
        }
        if (macd.getMACD() > 0) {
            return MACD_ABOVE;
        }
        return MACD_NONE;
    }
    
    void macdCrossUpHandle() {
        macdPosition = MACD_ABOVE;
        endIndex = index - 1;

        int lowIndex = CandleBreakAnalyzerStatic::GetLowestLowIndex(barData, startIndex, endIndex);
        if (lowIndex >= 0 && lowIndex < barData.RatesTotal()) {
        
            prevMacdLowFractalIndex = latestMacdLowFractalIndex;
            prevMacdLowFractalPrice = latestMacdLowFractalPrice;
            
            latestMacdLowFractalIndex = lowIndex;
            latestMacdLowFractalPrice = barData.GetLow(latestMacdLowFractalIndex);
            macdLowFractalBuffer[latestMacdLowFractalIndex] = latestMacdLowFractalPrice;
        }

        startIndex = index;
    }
    
    void macdCrossDownHandle() {
        macdPosition = MACD_BELOW;
        endIndex = index - 1;

        int highIndex = CandleBreakAnalyzerStatic::GetHighestHighIndex(barData, startIndex, endIndex);
        if (highIndex >= 0 && highIndex < barData.RatesTotal()) {
            
            prevMacdHighFractalIndex = latestMacdHighFractalIndex;
            prevMacdHighFractalPrice = latestMacdHighFractalPrice;
        
            latestMacdHighFractalIndex = highIndex;
            latestMacdHighFractalPrice = barData.GetHigh(latestMacdHighFractalIndex);
            macdHighFractalBuffer[latestMacdHighFractalIndex] = latestMacdHighFractalPrice;
        }

        startIndex = index;
    }
    
    void macdBelowHandle() {
        if (getMACDPosition() == MACD_ABOVE) {
            macdCrossUpHandle();
        }
    }
    
    void macdAboveHandle() {
        if (getMACDPosition() == MACD_BELOW) {
            macdCrossDownHandle();
        }
    }

public:
    double macdHighFractalBuffer[], macdLowFractalBuffer[];
    int latestMacdHighFractalIndex, latestMacdLowFractalIndex,
         prevMacdHighFractalIndex, prevMacdLowFractalIndex;
         
    double latestMacdHighFractalPrice, latestMacdLowFractalPrice,
         prevMacdHighFractalPrice, prevMacdLowFractalPrice;

    MACDFractalClass() {
        macdPosition = MACD_NONE;
    }

    void Init(MACD* MACDInstance, BarData* barDataInstance) {
        macd = MACDInstance;
        barData = barDataInstance;
        
        prevMacdHighFractalIndex = -1;
        prevMacdHighFractalPrice = -1;
        prevMacdLowFractalIndex = -1;
        prevMacdLowFractalPrice = -1;

        latestMacdHighFractalIndex = -1;
        latestMacdLowFractalIndex = -1;
        latestMacdHighFractalPrice = -1;
        latestMacdLowFractalPrice = -1;
        
        

        int size = barData.RatesTotal();
        if (size > 0) {
            ArrayResize(macdHighFractalBuffer, size);
            ArrayResize(macdLowFractalBuffer, size);
            ArrayInitialize(macdHighFractalBuffer, EMPTY_VALUE);
            ArrayInitialize(macdLowFractalBuffer, EMPTY_VALUE);
        }
    }
    
void Update(int Iindex) {
    index = Iindex;

    // Ensure calculations run only on closed candles
    if (index >= barData.RatesTotal() - 1) {
        return;  // Exit if it's the last (incomplete) candle
    }

    ArrayResize(macdHighFractalBuffer, barData.RatesTotal());
    ArrayResize(macdLowFractalBuffer, barData.RatesTotal());

    macdHighFractalBuffer[index] = EMPTY_VALUE;
    macdLowFractalBuffer[index] = EMPTY_VALUE;

    if (macdPosition == MACD_NONE) {
        macdPosition = getMACDPosition();
        if (macdPosition != MACD_NONE) {
            startIndex = index;
        }
    }

    if (macdPosition == MACD_NONE) {
        return;
    }

    switch (macdPosition) {
        case MACD_BELOW:
            macdBelowHandle();
            break;
        case MACD_ABOVE:
            macdAboveHandle();
            break;
    }

    string position = "";
    switch (macdPosition) {
        case MACD_ABOVE:
            position = "ABOVE";
            break;
        case MACD_BELOW:
            position = "BELOW";
            break;
        case MACD_NONE:
            position = "NONE";
            break;
    }

    //Print("position:", position, "| macd:", macd.getMACD(), "| time:", barData.GetTime(index));
}

};

#endif  // MACDFRACTALCLASS_MQH
