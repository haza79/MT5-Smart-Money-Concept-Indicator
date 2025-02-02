#ifndef EMACLASS_MQH
#define EMACLASS_MQH

class EMAClass {
private:
  int m_period;
  double m_alpha;
  double m_ema;
  double m_buffer[];
  int m_bufferSize;
  int m_lastIndex;
  int m_dataCount; // Counter for received data points

public:
  EMAClass(int period) : m_period(period), m_lastIndex(-1), m_bufferSize(0), m_dataCount(0) {
    if (period <= 0) {
      Print("Error: Invalid EMA period.");
      m_period = 1;
    }
    m_alpha = 2.0 / (m_period + 1);
    ArrayResize(m_buffer, 0);
  }

  double Update(double newPrice) {
    m_dataCount++; // Increment data counter

    if (m_dataCount <= m_period) {
      // Collect data until period is reached
      m_lastIndex++;
      if (m_lastIndex >= m_bufferSize) {
        m_bufferSize += 100;
        ArrayResize(m_buffer, m_bufferSize);
      }
      m_buffer[m_lastIndex] = newPrice; // Store the price temporarily

      if (m_dataCount == m_period) {
        // Initialize EMA when enough data is collected
        double sum = 0;
        for (int i = 0; i < m_period; i++) {
          sum += m_buffer[i];
        }
        m_ema = sum / m_period;

        //Now that EMA is initialized, overwrite the temporary price data with the EMA
        for(int i = 0; i < m_period; i++){
            m_buffer[i] = m_ema;
        }
      } else {
        return 0.0; // Or NaN, depending on your needs. Indicate that EMA is not yet initialized.
      }
    } else {
      // Update EMA after initialization
      m_ema = m_alpha * newPrice + (1 - m_alpha) * m_ema;
      m_lastIndex++;
      if (m_lastIndex >= m_bufferSize) {
        m_bufferSize += 100;
        ArrayResize(m_buffer, m_bufferSize);
      }
      m_buffer[m_lastIndex] = m_ema;
    }

    return m_ema;
  }

  double GetEMA() const {
    return m_ema;
  }

    double GetEMA(int index) const {
      if (index < 0 || index > m_lastIndex) {
          Print("Error: Index out of range.");
          return 0.0; // Or NaN
      }
      return m_buffer[index];
  }

    int GetLastIndex() const {
        return m_lastIndex;
    }


};

#endif
