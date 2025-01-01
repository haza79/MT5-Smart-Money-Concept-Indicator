#ifndef MAJORMARKETSTRUCTTURECLASS_MQH
#define MAJORMARKETSTRUCTTURECLASS_MQH

#include "BarData.mqh"
#include "Enums.mqh"
#include "Fractal.mqh"
#include "MinorMarketStructureClass.mqh"
#include "MajorMarketStructureStruct.mqh"

class MajorMarketStructureClass {

private:
   
   BarData *barData;
    FractalClass *fractal;
    MinorMarketStructureClass *minorMarketStructure;
    int oneTimeRun;
    MajorMarketStruct prevMarketStruct, latestMarketStruct;

    int prevMajorHighIndex, prevMajorLowIndex, latestMajorHighIndex, latestMajorLowIndex;
    int biasHighIndex, biasLowIndex;
    int inducementIndex;

    double prevMajorHighPrice, prevMajorLowPrice, latestMajorHighPrice, latestMajorLowPrice;
    double biasHighPrice, biasLowPrice;
    double inducementPrice;

    struct BiasSwingAndInducement {
        int biasSwingIndex;
        int inducementIndex;
    };

public:


    // Constructor to initialize variables
    void Init(BarData *barDataInstance,FractalClass *fractalInstance) {
      barData = barDataInstance;
        fractal = fractalInstance;

        prevMajorHighIndex = prevMajorLowIndex = latestMajorHighIndex = latestMajorLowIndex = -1;
        biasHighIndex = biasLowIndex = -1;

        prevMajorHighPrice = prevMajorLowPrice = latestMajorHighPrice = latestMajorLowPrice = -1;
        biasHighPrice = biasLowPrice = -1;

        // No need to initialize arrays since we reference external arrays
    }

    // Calculate method which works with references to the external arrays
    void Calculate() {
      GetBiasHighAndInducement();
      Print("bias H     : ",barData.GetTime(biasHighIndex));
      Print("inducement : ",barData.GetTime(inducementIndex));
    }
    
    
    void GetBiasHighAndInducement() {
    if (fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1) {
        return;
    }

    int newBiasHighIndex = -1;
    double newBiasHighPrice = 0.0;
    
    if (biasHighIndex != -1) {
        if (fractal.latestFractalHighIndex > biasHighIndex &&
            fractal.latestFractalHighPrice > biasHighPrice) {
            newBiasHighIndex = fractal.latestFractalHighIndex;
            newBiasHighPrice = fractal.latestFractalHighPrice;
        }
    } else {
        if (prevMajorHighIndex == -1 ||
            (fractal.latestFractalHighIndex > prevMajorHighIndex &&
             fractal.latestFractalHighPrice > prevMajorHighPrice)) {
            newBiasHighIndex = fractal.latestFractalHighIndex;
            newBiasHighPrice = fractal.latestFractalHighPrice;
        }
    }
    
    if(newBiasHighIndex != -1)
    {
        biasHighIndex = newBiasHighIndex;
        biasHighPrice = newBiasHighPrice;
        inducementIndex = (biasHighIndex == fractal.latestFractalLowIndex) ?
                          fractal.prevFractalLowIndex : fractal.latestFractalLowIndex;
        inducementPrice = (biasHighIndex == fractal.latestFractalLowIndex) ?
                          fractal.prevFractalLowPrice : fractal.latestFractalLowPrice;
    }
}



void GetBiasLowAndInducement() {
    if (fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1) {
        return;
    }

    int newBiasLowIndex = -1;
    double newBiasLowPrice = 0.0;

    if (biasLowIndex != -1) {
        if (fractal.latestFractalLowIndex > biasLowIndex &&
            fractal.latestFractalLowPrice < biasLowPrice) { // Note the '<' for lows
            newBiasLowIndex = fractal.latestFractalLowIndex;
            newBiasLowPrice = fractal.latestFractalLowPrice;
        }
    } else {
        if (prevMajorLowIndex == -1 ||
            (fractal.latestFractalLowIndex > prevMajorLowIndex &&
             fractal.latestFractalLowPrice < prevMajorLowPrice)) { // Note the '<' for lows
            newBiasLowIndex = fractal.latestFractalLowIndex;
            newBiasLowPrice = fractal.latestFractalLowPrice;
        }
    }

    if (newBiasLowIndex != -1) {
        biasLowIndex = newBiasLowIndex;
        biasLowPrice = newBiasLowPrice;

        inducementIndex = (biasLowIndex == fractal.latestFractalHighIndex) ?
                          fractal.prevFractalHighIndex : fractal.latestFractalHighIndex;
        inducementPrice = (biasLowIndex == fractal.latestFractalHighIndex) ?
                          fractal.prevFractalHighPrice : fractal.latestFractalHighPrice;
    }
}


};

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
