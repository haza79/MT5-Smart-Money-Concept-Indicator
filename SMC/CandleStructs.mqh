#ifndef CANDLE_MQH
#define CANDLE_MQH

struct Candle {
    double open;
    double high;
    double low;
    double close;

    Candle(double o = 0.0, double h = 0.0, double l = 0.0, double c = 0.0)
        : open(o), high(h), low(l), close(c) {}
        
    void setValue(double o, double h, double l, double c) {
        open = o;
        high = h;
        low = l;
        close = c;
    }
};

#endif