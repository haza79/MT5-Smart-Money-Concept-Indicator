#ifndef BALANCEOFPOWERREVERSECANDLE_MQH
#define BALANCEOFPOWERREVERSECANDLE_MQH

#include "BalanceOfPower.mqh";
#include "BarData.mqh";


class BalanceOfPowerReverseCandle{

private:

   BalanceOfPower* balanceOfPower;
   BarData* barData;
   

public:
   
   double bullishReverse[],bearishReverse[];
   
   BalanceOfPowerReverseCandle(){
      ArrayInitialize(bullishReverse,EMPTY_VALUE);
      ArrayInitialize(bearishReverse,EMPTY_VALUE);
   }
   
   void init(BalanceOfPower* balanceOfPowerInstance,BarData* barDataInstance){
      balanceOfPower = balanceOfPowerInstance;
      barData = barDataInstance;
   }
   
   void update(const int &index,const int &rate_total){
      ArrayResize(bullishReverse,rate_total);
      ArrayResize(bearishReverse,rate_total);
      if (index >= rate_total - 1) {
        return;
      }
      
      if(balanceOfPower.prev2Bop >= 0 && balanceOfPower.latestBop <= 0 &&
         balanceOfPower.latestBop < balanceOfPower.prevBop && balanceOfPower.prevBop < balanceOfPower.prev2Bop){
         // bearish reverse
         bearishReverse[index] = barData.GetHigh(index);
      }
      
   }
   


}

#endif