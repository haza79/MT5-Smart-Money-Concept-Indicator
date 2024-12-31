#define SERIES(name,type)                               \                            
class C##name                                           \
{                                                       \
public:                                                 \
type operator[](const int i){return i##name(NULL,0,i);} \                                                
}name;
SERIES(Open,double)
SERIES(Low,double)
SERIES(High,double)
SERIES(Close,double)
SERIES(Time,datetime)
SERIES(Volume,long)


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
    void Calculate() {
        // Add calculation logic here
        Print("last high:",Time[fractal.latestFractalHighIndex]," : ",High[fractal.latestFractalHighIndex]);
        Print("last low :",Time[fractal.latestFractalLowIndex]," : ",Low[fractal.latestFractalLowIndex]);
        //GetBiasHighAndInducement();
        //Print("bias high:",biasHighIndex,":",High[biasHighIndex],":",Time[biasHighIndex]);
        //Print("inducement:",inducementIndex,":",Low[inducementIndex],":",Time[inducementIndex]);
    }
    
    
    void GetBiasHighAndInducement(){
    if(fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1){
      return;
    }
    
      Print("is have bias high:",biasHighIndex != -1);
      if(biasHighIndex != -1){
         // yes
         Print("is last high fractal > bias high:",fractal.latestFractalHighIndex > biasHighIndex &&
            fractal.latestFractalHighPrice > biasHighPrice);
         if(fractal.latestFractalHighIndex > biasHighIndex &&
            fractal.latestFractalHighPrice > biasHighPrice){
            // yes
            biasHighIndex = fractal.latestFractalHighIndex;
            biasHighPrice = fractal.latestFractalHighPrice;
            inducementIndex = fractal.latestFractalLowIndex;
            inducementPrice = fractal.latestFractalLowPrice;
         }else{
            Print("no bias high");
         }
      }else{
         // no
         Print("is prev major high empty:",prevMajorHighIndex == -1);
         Print(prevMajorHighIndex);
         if(prevMajorHighIndex == -1){
            // yes
            biasHighIndex = fractal.latestFractalHighIndex;
            biasHighPrice = fractal.latestFractalHighPrice;
            inducementIndex = fractal.latestFractalLowIndex;
            inducementPrice = fractal.latestFractalLowPrice;
         }else{
            // no
            Print("is latest high fractal > prev major high:",fractal.latestFractalHighIndex > prevMajorHighIndex &&
               fractal.latestFractalHighPrice > prevMajorHighPrice);
            if(fractal.latestFractalHighIndex > prevMajorHighIndex &&
               fractal.latestFractalHighPrice > prevMajorHighPrice){
               // yes
               
               biasHighIndex = fractal.latestFractalHighIndex;
               biasHighPrice = fractal.latestFractalHighPrice;
               inducementIndex = fractal.latestFractalLowIndex;
               inducementPrice = fractal.latestFractalLowPrice;
            }
         }
      }
      
      Print("---");
    
    }


};

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
