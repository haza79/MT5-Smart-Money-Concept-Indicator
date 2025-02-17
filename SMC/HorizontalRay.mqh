#ifndef HORIZONTALRAY_MQH
#define HORIZONTALRAY_MQH

#include "LineDrawing.mqh";

class HorizontalRay{

private:
   int startIndex,endIndex;
   double startValue;
   
   

public:
   LineDrawing lineDrawing;
   bool drew;
   
   
   HorizontalRay(){
      ArrayInitialize(lineDrawing.buffer, EMPTY_VALUE);
      drew = false;
      startIndex = -1;
      endIndex = -1;
      startValue = -1;
   }
   
   void drawRay(int iStartIndex,int iEndIndex,double iStartValue){
      startIndex = iStartIndex;
      endIndex = iEndIndex;
      startValue = iStartValue;
      lineDrawing.DrawStraightLine(iStartIndex,iEndIndex,iStartValue);
      drew = true;
   }
   
   void extendeRay(int iEndIndex){
      if(!drew){
         return;
      }
      startIndex = endIndex;
      endIndex = iEndIndex;
      lineDrawing.DrawStraightLine(startIndex,endIndex,startValue);
      
   }
   
   void moveRay(int iStartIndex,int iEndIndex,double iStartValue){
      ArrayInitialize(lineDrawing.buffer,EMPTY_VALUE);
      lineDrawing.DrawStraightLine(iStartIndex,iEndIndex,iStartValue);
   }
   
   void deleteRay(){
      ArrayInitialize(lineDrawing.buffer,EMPTY_VALUE);
      drew = false;
   }
   


}

#endif