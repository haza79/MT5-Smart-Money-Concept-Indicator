#ifndef BALANCEOFPOWER_MQH
#define BALANCEOFPOWER_MQH

class BalanceOfPower {

private:
    
public:
    double balanceOfPowerBuffer[];
    double emaBuffer[];
    
    double prev2Bop, prevBop, latestBop,
         prev2BopEma,prevBopEma,latestBopEma;

    // Constructor
    BalanceOfPower() {
        ArrayInitialize(balanceOfPowerBuffer, EMPTY_VALUE);
        ArrayInitialize(emaBuffer, EMPTY_VALUE);
    }

    // Update BOP & EMA Calculation in One Function
    void update(const int &index, const double &open, const double &high, const double &low, 
            const double &close, const int &rates_total, int emaPeriod) 
{
    if (index >= rates_total - 1) {
        return;  // Exit if it's the last (incomplete) candle
    }

    // Resize Buffers
    ArrayResize(balanceOfPowerBuffer, rates_total);
    ArrayResize(emaBuffer, rates_total);

    // Calculate BOP
    double bop = (high != low) ? (close - open) / (high - low) : 0;
    balanceOfPowerBuffer[index] = bop;
    addBop(bop);

    // EMA Calculation (Ensure EMA Period is valid)
    if (emaPeriod > 1) {
        double multiplier = 2.0 / (emaPeriod + 1);

        if (index == 0) {
            emaBuffer[index] = bop;  // First value is just BOP itself
            addBopEma(bop);
        } else {
            // Ensure previous EMA value exists
            double previousEma = (index > 1) ? emaBuffer[index - 1] : bop;
            double bopEmaCalc = (bop * multiplier) + (previousEma * (1 - multiplier));

            emaBuffer[index] = bopEmaCalc;
            addBopEma(bopEmaCalc);
        }
    }
}


    // Store Previous BOP Values
    void addBop(double bop) {
        prev2Bop = prevBop;
        prevBop = latestBop;
        latestBop = bop;
    }
    
    void addBopEma(double bopEma) {
        prev2BopEma = prevBopEma;
        prevBopEma = latestBopEma;
        latestBopEma = bopEma;
    }

};

#endif // BALANCEOFPOWER_MQH
