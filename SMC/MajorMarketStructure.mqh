#ifndef MAJORMARKETSTRUCTURECLASS_MQH
#define MAJORMARKETSTRUCTURECLASS_MQH

#include "Enums.mqh"
#include "Fractal.mqh"
#include "MinorMarketStructureClass.mqh"
#include "MajorMarketStructureStruct.mqh"

class MajorMarketStructureClass {

private:
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
    void Init(FractalClass *fractalInstance) {
        fractal = fractalInstance;

        prevMajorHighIndex = prevMajorLowIndex = latestMajorHighIndex = latestMajorLowIndex = -1;
        biasHighIndex = biasLowIndex = -1;

        prevMajorHighPrice = prevMajorLowPrice = latestMajorHighPrice = latestMajorLowPrice = -1;
        biasHighPrice = biasLowPrice = -1;

        // No need to initialize arrays since we reference external arrays
    }

    // Calculate method which works with references to the external arrays
    void Calculate(const double &open[],
                   const double &high[],
                   const double &low[],
                   const double &close[]) {
        // Use references to avoid copying the data
         void GetBiasHighAndInducement(&open,&high,&low,&close);
        // Add calculation logic here
    }
    
    
    void GetBiasHighAndInducement(const double &open[],const double &high[],const double &low[],const double &close[]){
    bool isSet = false;
      if(biasHighIndex != -1){
         
         if(fractal.latestFractalHighIndex > biasHighIndex && fractal.latestFractalHighPrice > biasHighPrice){
            isSet = true;
         }else{
            isSet = false;
         }
         
      }else{
      
         if(prevMajorHighIndex == -1){
            // is prev major high EMPTY
            isSet = true;
         }else if(fractal.latestFractalHighIndex > prevMajorHighIndex && fractal.latestFractalHighPrice > prevMajorHighPrice){
            isSet = true;
         }else{
            isSet = false;
         }
         
      }
      
      if(isSet){
         biasHighIndex = fractal.latestFractalHighIndex;
         biasHighPrice = fractal.latestFractalHighPrice;
         
         if(fractal.latestFractalLowIndex == fractal.latestFractalHighIndex){
            inducementIndex = fractal.prevFractalLowIndex;
            inducementPrice = fractal.prevFractalLowPrice;
         }else{
            inducementIndex = fractal.latestFractalLowIndex;
            inducementPrice = fractal.latestFractalLowPrice;
         }
         
      }
      
      
      
    }


};

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
