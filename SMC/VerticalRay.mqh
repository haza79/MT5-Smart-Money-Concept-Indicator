#ifndef VERTICALRAY_MQH
#define VERTICALRAY_MQH

class VerticalRay{

private:
   
public:

   double verticalLineBuffer[];
   
   VerticalRay(){
      ArrayInitialize(verticalLineBuffer, EMPTY_VALUE);
   }
   
   void drawRay(int index,double price){
      
   }
   
   
   void deleteRay(){
      ArrayInitialize(verticalLineBuffer,EMPTY_VALUE);
   }
   


}

#endif