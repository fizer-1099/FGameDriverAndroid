//+------------------------------------------------------------------+
//| Balasari RSI Divergence - MT4                                   |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LimeGreen
#property indicator_color2 Tomato
#property indicator_width1 2
#property indicator_width2 2
input int RSIPeriod=14;
input int PivotLeft=3;
input int PivotRight=3;
input int ScanBars=1500;
input int ArrowGapPoints=25;
double Bull[],Bear[];
int OnInit(){ IndicatorShortName("Balasari RSI Divergence"); SetIndexBuffer(0,Bull); SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,241); SetIndexLabel(0,"Bullish divergence"); SetIndexBuffer(1,Bear); SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,242); SetIndexLabel(1,"Bearish divergence"); ArraySetAsSeries(Bull,true); ArraySetAsSeries(Bear,true); return(INIT_SUCCEEDED); }
bool LowPivot(int i,const double &a[],int n){ for(int k=1;k<=PivotLeft;k++) if(a[i]>=a[i-k]||a[i]>=a[i+k]) return(false); for(int k=1;k<=PivotRight;k++) if(a[i]>=a[i+k]) return(false); return(true); }
bool HighPivot(int i,const double &a[],int n){ for(int k=1;k<=PivotLeft;k++) if(a[i]<=a[i-k]||a[i]<=a[i+k]) return(false); for(int k=1;k<=PivotRight;k++) if(a[i]<=a[i+k]) return(false); return(true); }
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
 if(rates_total<PivotLeft+PivotRight+RSIPeriod+10) return(0); int lim=MathMin(rates_total-PivotLeft-1,ScanBars);
 for(int i=lim;i>=PivotRight+1;i--){ Bull[i]=EMPTY_VALUE; Bear[i]=EMPTY_VALUE; }
 int lastLow=-1,lastHigh=-1;
 for(int i=lim;i>=PivotRight+1;i--){ double rv=iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i);
  if(LowPivot(i,low,rates_total)){ if(lastLow>0){ double oldR=iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,lastLow); if(low[i]<low[lastLow]&&rv>oldR) Bull[i]=low[i]-ArrowGapPoints*_Point; } lastLow=i; }
  if(HighPivot(i,high,rates_total)){ if(lastHigh>0){ double oldR=iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,lastHigh); if(high[i]>high[lastHigh]&&rv<oldR) Bear[i]=high[i]+ArrowGapPoints*_Point; } lastHigh=i; }
 }
 return(rates_total);
}