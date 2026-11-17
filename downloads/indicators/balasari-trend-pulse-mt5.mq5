//+------------------------------------------------------------------+
//| Balasari Trend Pulse - MT5                                      |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_label1 "Buy"
#property indicator_type1 DRAW_ARROW
#property indicator_color1 clrLimeGreen
#property indicator_width1 2
#property indicator_label2 "Sell"
#property indicator_type2 DRAW_ARROW
#property indicator_color2 clrTomato
#property indicator_width2 2
input int FastEMA=20;
input int SlowEMA=50;
input int RSIPeriod=14;
input double BuyRSIMin=52.0;
input double SellRSIMax=48.0;
input int ArrowGapPoints=20;
double BuyBuffer[],SellBuffer[];
int hFast,hSlow,hRSI;
int OnInit(){
 SetIndexBuffer(0,BuyBuffer,INDICATOR_DATA); SetIndexBuffer(1,SellBuffer,INDICATOR_DATA);
 PlotIndexSetInteger(0,PLOT_ARROW,233); PlotIndexSetInteger(1,PLOT_ARROW,234);
 ArraySetAsSeries(BuyBuffer,true); ArraySetAsSeries(SellBuffer,true);
 hFast=iMA(_Symbol,_Period,FastEMA,0,MODE_EMA,PRICE_CLOSE); hSlow=iMA(_Symbol,_Period,SlowEMA,0,MODE_EMA,PRICE_CLOSE); hRSI=iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE);
 if(hFast==INVALID_HANDLE||hSlow==INVALID_HANDLE||hRSI==INVALID_HANDLE) return(INIT_FAILED);
 IndicatorSetString(INDICATOR_SHORTNAME,"Balasari Trend Pulse (EMA+RSI)"); return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){ IndicatorRelease(hFast); IndicatorRelease(hSlow); IndicatorRelease(hRSI); }
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
 if(rates_total<SlowEMA+3) return(0);
 double f[],s[],r[]; ArraySetAsSeries(f,true); ArraySetAsSeries(s,true); ArraySetAsSeries(r,true);
 int need=rates_total; if(CopyBuffer(hFast,0,0,need,f)<=0||CopyBuffer(hSlow,0,0,need,s)<=0||CopyBuffer(hRSI,0,0,need,r)<=0) return(prev_calculated);
 int limit=(prev_calculated==0)?rates_total-2:MathMin(rates_total-prev_calculated+2,rates_total-2);
 for(int i=limit;i>=1;i--){ BuyBuffer[i]=EMPTY_VALUE; SellBuffer[i]=EMPTY_VALUE;
  if(f[i+1]<=s[i+1]&&f[i]>s[i]&&r[i]>=BuyRSIMin) BuyBuffer[i]=low[i]-ArrowGapPoints*_Point;
  if(f[i+1]>=s[i+1]&&f[i]<s[i]&&r[i]<=SellRSIMax) SellBuffer[i]=high[i]+ArrowGapPoints*_Point;
 }
 return(rates_total);
}