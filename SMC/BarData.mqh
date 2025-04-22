#ifndef BARDATA_MQH
#define BARDATA_MQH
class BarData
  {
private:
   int      m_rates_total;
   datetime m_time[];
   double   m_open[];
   double   m_high[];
   double   m_low[];
   double   m_close[];
   bool     m_data_set;

public:
    bool SetData(int rates_total, const datetime& time[], const double& open[],const double& high[], const double& low[], const double& close[])
    {
        m_rates_total = rates_total;
        ArrayResize(m_time, rates_total);
        ArrayResize(m_open, m_rates_total);
        ArrayResize(m_high, m_rates_total);
        ArrayResize(m_low, m_rates_total);
        ArrayResize(m_close, m_rates_total);

        ArrayCopy(m_time, time, 0, 0, WHOLE_ARRAY);
        ArrayCopy(m_open, open, 0, 0, WHOLE_ARRAY);
        ArrayCopy(m_high, high, 0, 0, WHOLE_ARRAY);
        ArrayCopy(m_low, low, 0, 0, WHOLE_ARRAY);
        ArrayCopy(m_close, close, 0, 0, WHOLE_ARRAY);

        m_data_set = true;
        return true;
    }
    
    int GetTimeArrSize(){
      return ArraySize(m_time);
    }
    
    int GetOpenArrSize(){
      return ArraySize(m_open);
    }
    
    int GetHighArrSize() const{
      return ArraySize(m_high);
    }
    
    int GetLowArrSize() const{
      return ArraySize(m_low);
    }
    
    int GetCloseArrSize(){
      return ArraySize(m_close);
    }
    
    int getLowestLowValueByRange(int startIndex){
   return ArrayMinimum(m_low, startIndex, WHOLE_ARRAY);
}


   datetime GetTime(int shift) const
     {
      if(!m_data_set || shift < 0 || shift >= m_rates_total) return 0;
      return m_time[shift];
     }
    double GetOpen(int shift) const
     {
      if(!m_data_set || shift < 0 || shift >= m_rates_total) return 0.0;
      return m_open[shift];
     }
   double GetHigh(int shift) const
     {
      if(!m_data_set || shift < 0 || shift >= m_rates_total) return 0.0;
      return m_high[shift];
     }

   double GetLow(int shift) const
     {
      if(!m_data_set || shift < 0 || shift >= m_rates_total) return 0.0;
      return m_low[shift];
     }
    double GetClose(int shift) const
     {
      if(!m_data_set || shift < 0 || shift >= m_rates_total) return 0.0;
      return m_close[shift];
     }
    int RatesTotal() const
    {
        return m_rates_total;
    }
  };
  #endif
