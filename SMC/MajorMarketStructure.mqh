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
    
    
    void GetBiasHighAndInducement(){
    if(fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1){
      return;
    }
    
      if(biasHighIndex != -1){
         // yes
         if(fractal.latestFractalHighIndex > biasHighIndex &&
            fractal.latestFractalHighPrice > biasHighPrice){
            // yes
            biasHighIndex = fractal.latestFractalHighIndex;
            biasHighPrice = fractal.latestFractalHighPrice;
            
            if(biasHighIndex == fractal.latestFractalLowIndex){
               inducementIndex = fractal.prevFractalLowIndex;
               inducementPrice = fractal.prevFractalLowPrice;
            }else{
               inducementIndex = fractal.latestFractalLowIndex;
               inducementPrice = fractal.latestFractalLowPrice;
            }
            
         }
      }else{
         // no
         if(prevMajorHighIndex == -1){
            // yes
            biasHighIndex = fractal.latestFractalHighIndex;
            biasHighPrice = fractal.latestFractalHighPrice;
            
            if(biasHighIndex == fractal.latestFractalLowIndex){
               inducementIndex = fractal.prevFractalLowIndex;
               inducementPrice = fractal.prevFractalLowPrice;
            }else{
               inducementIndex = fractal.latestFractalLowIndex;
               inducementPrice = fractal.latestFractalLowPrice;
            }
         }else{
            // no
            if(fractal.latestFractalHighIndex > prevMajorHighIndex &&
               fractal.latestFractalHighPrice > prevMajorHighPrice){
               // yes
               biasHighIndex = fractal.latestFractalHighIndex;
               biasHighPrice = fractal.latestFractalHighPrice;
               
               if(biasHighIndex == fractal.latestFractalLowIndex){
               inducementIndex = fractal.prevFractalLowIndex;
               inducementPrice = fractal.prevFractalLowPrice;
            }else{
               inducementIndex = fractal.latestFractalLowIndex;
               inducementPrice = fractal.latestFractalLowPrice;
            }
            }
         }
      }
      
    
    }


};

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
