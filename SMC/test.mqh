#define SERIES(name,type)                               \                            
class C##name                                           \
{                                                       \
public:                                                 \
type operator[](const int i){return i##name(NULL,0,i);} \                                                
}name;                                                  
SERIES(Open,double)
SERIES(Low,double)
SERIES(High,double)
SERIES(Close,double)
SERIES(Time,datetime)
SERIES(Volume,long)