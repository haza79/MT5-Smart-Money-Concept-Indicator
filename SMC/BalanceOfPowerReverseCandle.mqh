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
      if (index >= rate_total) {
        return;  // Ensure we don't process out-of-bounds indices
    }

    // Resize arrays properly before assigning values
    ArrayResize(bearishReverse, rate_total);
    ArrayResize(bullishReverse, rate_total);

    bearishReverse[index] = EMPTY_VALUE;
    bullishReverse[index] = EMPTY_VALUE;

    // Ensure there are at least 3 valid values before checking reversal logic
    if (index < 2) {
        return;
    }
      
      if(balanceOfPower.prev2BopEma >= 0 && balanceOfPower.latestBopEma <= 0 && balanceOfPower.latestBopEma <= -0.1 &&
         balanceOfPower.latestBopEma < balanceOfPower.prevBopEma && balanceOfPower.prevBopEma < balanceOfPower.prev2BopEma){
         // bearish reverse
         if(bearishReverse[index-1] == EMPTY_VALUE){
            bearishReverse[index] = barData.GetHigh(index);
         }
         
      }
      
      if(balanceOfPower.prev2BopEma <= 0 && balanceOfPower.latestBopEma >= 0 && balanceOfPower.latestBopEma >= 0.1 &&
         balanceOfPower.latestBopEma > balanceOfPower.prevBopEma && balanceOfPower.prevBopEma > balanceOfPower.prev2BopEma){
         // bearish reverse
         if(bullishReverse[index-1] == EMPTY_VALUE){
            bullishReverse[index] = barData.GetLow(index);
         }
         
      }
      
   }
   


}

#endif