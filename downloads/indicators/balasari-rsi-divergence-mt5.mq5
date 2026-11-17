//+------------------------------------------------------------------+
//| Balasari RSI Divergence - MT5                                   |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_label1 "Bullish divergence"
#property indicator_type1 DRAW_ARROW
#property indicator_color1 clrLimeGreen
#property indicator_label2 "Bearish divergence"
#property indicator_type2 DRAW_ARROW
#property indicator_color2 clrTomato
input int RSIPeriod=14;
input int PivotLeft=3;
input int PivotRight=3;
input int ScanBars=1500;
input int ArrowGapPoints=25;
double Bull[],Bear[]; int hRSI;
bool IsLow(int i,const double &low[]){ for(int k=1;k<=PivotLeft;k++) if(low[i]>=low[i-k]||low[i]>=low[i+k]) return false; for(int k=1;k<=PivotRight;k++) if(low[i]>=low[i+k]) return false; return true; }
bool IsHigh(int i,const double &high[]){ for(int k=1;k<=PivotLeft;k++) if(high[i]<=high[i-k]||high[i]<=high[i+k]) return false; for(int k=1;k<=PivotRight;k++) if(high[i]<=high[i+k]) return false; return true; }
int OnInit(){ SetIndexBuffer(0,Bull,INDICATOR_DATA); SetIndexBuffer(1,Bear,INDICATOR_DATA); PlotIndexSetInteger(0,PLOT_ARROW,241); PlotIndexSetInteger(1,PLOT_ARROW,242); ArraySetAsSeries(Bull,true); ArraySetAsSeries(Bear,true); hRSI=iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE); if(hRSI==INVALID_HANDLE) return INIT_FAILED; IndicatorSetString(INDICATOR_SHORTNAME,"Balasari RSI Divergence"); return INIT_SUCCEEDED; }
void OnDeinit(const int reason){ IndicatorRelease(hRSI); }
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
 if(rates_total<PivotLeft+PivotRight+RSIPeriod+10) return 0; double r[]; ArraySetAsSeries(r,true); if(CopyBuffer(hRSI,0,0,rates_total,r)<=0) return prev_calculated;
 int lim=MathMin(rates_total-PivotLeft-1,ScanBars), lastLow=-1,lastHigh=-1;
 for(int i=lim;i>=PivotRight+1;i--){ Bull[i]=EMPTY_VALUE; Bear[i]=EMPTY_VALUE; if(IsLow(i,low)){ if(lastLow>0&&low[i]<low[lastLow]&&r[i]>r[lastLow]) Bull[i]=low[i]-ArrowGapPoints*_Point; lastLow=i; } if(IsHigh(i,high)){ if(lastHigh>0&&high[i]>high[lastHigh]&&r[i]<r[lastHigh]) Bear[i]=high[i]+ArrowGapPoints*_Point; lastHigh=i; } }
 return rates_total;
}