#ifndef BUYERSELLERPRESSURE_MQH
#define BUYERSELLERPRESSURE_MQH

class BuyerSellerPressure{

private:

   double open,high,low,close;
   
   
   void calcRange(){
      range = high-low+0.00001;
   }

   double calcSellerPressure(){
      return (high-close) / range;
   }
   
   double calcBuyerPressure(){
      return (close-low)/range;
   }

public:

   double sellerPressureBuffer[],buyerPressureBuffer[];
   double range;
   
   void update(double Iopen,double Ihigh,double Ilow,double Iclose,int index,int rate_total){
      ArrayResize(sellerPressureBuffer,rate_total);
      ArrayResize(buyerPressureBuffer,rate_total);
      
      open = Iopen;
      high = Ihigh;
      low = Ilow;
      close = Iclose;
      
      if (index >= rate_total - 1) {
        return;
      }
      
      calcRange();
      sellerPressureBuffer[index] = calcSellerPressure();
      buyerPressureBuffer[index] = calcBuyerPressure();
   }
   
   int getSellerPressureArraySize(){
      return ArraySize(sellerPressureBuffer);
   }

}

#endif