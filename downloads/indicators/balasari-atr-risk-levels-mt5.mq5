//+------------------------------------------------------------------+
//| Balasari ATR Risk Levels - MT5                                  |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
input int ATRPeriod=14;
input double StopATR=1.5;
input double Target1ATR=1.5;
input double Target2ATR=3.0;
input int Direction=1; // 1 = long guide, -1 = short guide
input color StopColor=clrTomato;
input color TargetColor=clrSeaGreen;
input color EntryColor=clrDodgerBlue;
string P="BATR5_"; int hATR;
void HLine(string name,double price,color clr,ENUM_LINE_STYLE style){ if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_HLINE,0,0,price); ObjectSetDouble(0,name,OBJPROP_PRICE,price); ObjectSetInteger(0,name,OBJPROP_COLOR,clr); ObjectSetInteger(0,name,OBJPROP_STYLE,style); ObjectSetInteger(0,name,OBJPROP_WIDTH,1); }
int OnInit(){ hATR=iATR(_Symbol,_Period,ATRPeriod); if(hATR==INVALID_HANDLE)return INIT_FAILED; IndicatorSetString(INDICATOR_SHORTNAME,"Balasari ATR Risk Levels"); return INIT_SUCCEEDED; }
void OnDeinit(const int reason){ IndicatorRelease(hATR); ObjectDelete(0,P+"Entry"); ObjectDelete(0,P+"Stop"); ObjectDelete(0,P+"Target1"); ObjectDelete(0,P+"Target2"); }
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){ if(rates_total<ATRPeriod+3)return 0; double a[]; ArraySetAsSeries(a,true); if(CopyBuffer(hATR,0,0,2,a)<2)return prev_calculated; double entry=close[1],atr=a[1]; if(atr<=0)return rates_total; int d=(Direction>=0?1:-1); HLine(P+"Entry",entry,EntryColor,STYLE_DOT); HLine(P+"Stop",entry-d*StopATR*atr,StopColor,STYLE_SOLID); HLine(P+"Target1",entry+d*Target1ATR*atr,TargetColor,STYLE_DASH); HLine(P+"Target2",entry+d*Target2ATR*atr,TargetColor,STYLE_SOLID); return rates_total; }