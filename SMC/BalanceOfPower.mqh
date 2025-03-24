#ifndef BALANCEOFPOWER_MQH
#define BALANCEOFPOWER_MQH

class BalanceOfPower {

private:
    double prev2Bop, prevBop, latestBop;
    
public:
    double balanceOfPowerBuffer[];
    double emaBuffer[];

    // Constructor
    BalanceOfPower() {
        ArrayInitialize(balanceOfPowerBuffer, EMPTY_VALUE);
        ArrayInitialize(emaBuffer, EMPTY_VALUE);
    }

    // Update BOP & EMA Calculation in One Function
    void update(const int &index, const double &open, const double &high, const double &low, 
                const double &close, const int &rates_total, int emaPeriod) 
    {
        if (index >= rates_total) return;

        // Resize Buffers
        ArrayResize(balanceOfPowerBuffer, rates_total);
        ArrayResize(emaBuffer, rates_total);

        // Calculate BOP
        double bop = (high != low) ? (close - open) / (high - low) : 0;
        balanceOfPowerBuffer[index] = bop;
        addBop(bop);

        // Calculate EMA
        if (emaPeriod > 1) {
            double multiplier = 2.0 / (emaPeriod + 1);
            if (index == 0) {
                emaBuffer[index] = bop;  // First value is just BOP itself
            } else {
                emaBuffer[index] = (bop * multiplier) + (emaBuffer[index - 1] * (1 - multiplier));
            }
        }
    }

    // Store Previous BOP Values
    void addBop(double bop) {
        prev2Bop = prevBop;
        prevBop = latestBop;
        latestBop = bop;
    }

};

#endif // BALANCEOFPOWER_MQH
