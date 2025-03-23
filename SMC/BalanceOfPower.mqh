#ifndef BALANCEOFPOWER_MQH
#define BALANCEOFPOWER_MQH

class BalanceOfPower{

private:



public:
   
   double balanceOfPowerBuffer[];
   double prev2Bop,prevBop,latestBop;
   
   BalanceOfPower(){
      ArrayInitialize(balanceOfPowerBuffer,EMPTY_VALUE);
   }
   
   void update(const int &index,const double &open,const double &high,const double &low,const double &close,const int &rate_total){
      ArrayResize(balanceOfPowerBuffer,rate_total);
      if (index >= rate_total - 1) {
        return;
      }
      double bop = (close-open)/(high-low);
      balanceOfPowerBuffer[index] = bop;
      addBop(bop);
   }
   
   void addBop(double bop){
      prev2Bop = prevBop;
      prevBop = latestBop;
      latestBop = bop;
   }

}

#endif