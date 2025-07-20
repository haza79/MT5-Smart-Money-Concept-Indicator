#ifndef LINEDRAWING_MQH
#define LINEDRAWING_MQH

class LineDrawing{

private:

public:
   double buffer[];
   
   LineDrawing(){
      ArrayInitialize(buffer, EMPTY_VALUE);
   }
   
   void DrawStraightLine(int startIndex, int endIndex, double startValue){
      if(startIndex < 0 || endIndex < 0 || startIndex == -1 || endIndex == -1 || startIndex == EMPTY_VALUE || endIndex == EMPTY_VALUE){
         Print("can't draw line, value is valid,(start index="+startIndex+",end index="+endIndex+")");
         return;
      }
      for (int i = startIndex; i <= endIndex; i++) {
      // Check for a gap in dates
         buffer[i] = startValue; // Set the line value
      }
     
   }
   
   void DeleteLineByRange(int startIndex,int endIndex){
      for (int i = startIndex; i < ArraySize(buffer); i++) {
      // Check for a gap in dates
         buffer[i] = EMPTY_VALUE; // Set the line value
      }
   }
   


}

#endif