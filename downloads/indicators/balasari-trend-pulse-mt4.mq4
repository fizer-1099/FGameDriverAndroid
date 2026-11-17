//+------------------------------------------------------------------+
//| Balasari Trend Pulse - MT4                                      |
//| EMA 20/50 crossover with RSI confirmation                       |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Tomato
#property indicator_width1 2
#property indicator_width2 2
input int FastEMA=20;
input int SlowEMA=50;
input int RSIPeriod=14;
input double BuyRSIMin=52.0;
input double SellRSIMax=48.0;
input int ArrowGapPoints=20;
double BuyArrow[],SellArrow[];
int OnInit(){
 IndicatorShortName("Balasari Trend Pulse (EMA+RSI)");
 SetIndexBuffer(0,BuyArrow); SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,233); SetIndexLabel(0,"Buy");
 SetIndexBuffer(1,SellArrow); SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,234); SetIndexLabel(1,"Sell");
 ArraySetAsSeries(BuyArrow,true); ArraySetAsSeries(SellArrow,true); return(INIT_SUCCEEDED);
}
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
 if(rates_total<SlowEMA+3) return(0);
 int limit=(prev_calculated==0)?rates_total-SlowEMA-2:MathMin(rates_total-prev_calculated+2,rates_total-SlowEMA-2);
 for(int i=limit;i>=1;i--){
  BuyArrow[i]=EMPTY_VALUE; SellArrow[i]=EMPTY_VALUE;
  double f0=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i), f1=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i+1);
  double s0=iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i), s1=iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i+1);
  double r=iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i);
  if(f1<=s1 && f0>s0 && r>=BuyRSIMin) BuyArrow[i]=low[i]-ArrowGapPoints*_Point;
  if(f1>=s1 && f0<s0 && r<=SellRSIMax) SellArrow[i]=high[i]+ArrowGapPoints*_Point;
 }
 return(rates_total);
}