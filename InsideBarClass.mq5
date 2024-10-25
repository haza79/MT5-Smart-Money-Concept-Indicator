class InsideBarClass
{

public:

    double motherBarTopBuffer[];
    double motherBarBottomBuffer[];
    double motherBarBuffer[];
    double insideBarBuffer[];

    int motherBarIndex;
    double motherBarHigh, motherBarLow;

    // Initialization method
    void Init()
    {
        motherBarIndex = -1;
        motherBarHigh = 0;
        motherBarLow = 0;

        ArrayInitialize(motherBarTopBuffer, EMPTY_VALUE);
        ArrayInitialize(motherBarBottomBuffer, EMPTY_VALUE);
        ArrayInitialize(motherBarBuffer, EMPTY_VALUE);
        ArrayInitialize(insideBarBuffer, EMPTY_VALUE);
    }

    // Main calculation method
    void Calculate(int i,const int rates_total, const double &high[], const double &low[])
    {
      ArrayResize(motherBarTopBuffer, rates_total);
      ArrayResize(motherBarBottomBuffer, rates_total);
      ArrayResize(motherBarBuffer, rates_total);
      ArrayResize(insideBarBuffer, rates_total);
      
      if(i < 1){
         return;
      }
      
      if (i == rates_total - 1) return;
      
      if(motherBarIndex==-1){
         if(IsInsideBar(i,high,low)){
            motherBarIndex = i-1;
            motherBarHigh = high[i-1];
            motherBarLow = low[i-1];
            
            motherBarTopBuffer[i-1]    = motherBarHigh;
            motherBarBottomBuffer[i-1] = motherBarLow;
            motherBarTopBuffer[i]      = motherBarHigh;
            motherBarBottomBuffer[i]   = motherBarLow;
         }
      }else{
         if(IsInsideMotherBar(i,high,low)){
            motherBarTopBuffer[i] = motherBarHigh;
            motherBarBottomBuffer[i] = motherBarLow;
         }else{
            motherBarIndex = -1;
         }
      }
      
      
    }
   
   int GetMotherBarIndex(){
      return motherBarIndex;
   }
   
    double GetMotherBar(int index) { return motherBarBuffer[index]; }
    double GetInsideBar(int index) { return insideBarBuffer[index]; }
    
    

private:
    // Helper function to detect if the current bar is an inside bar
    bool IsInsideBar(int index, const double &high[], const double &low[])
    {
        return (high[index] < high[index - 1] && low[index] > low[index - 1]);
    }

    // Helper function to detect if the current bar is still within the mother bar's range
    bool IsInsideMotherBar(int index, const double &high[], const double &low[])
    {
        return (high[index] < motherBarHigh && low[index] > motherBarLow);
    }
};
