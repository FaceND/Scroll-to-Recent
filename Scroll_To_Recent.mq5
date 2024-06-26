//+------------------------------------------------------------------+
//|                                             Scroll_To_Recent.mq5 |
//|                                         Copyright © 2024, FaceND |
//|                       https://github.com/FaceND/Scroll_To_Recent |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2024, FaceND"
#property link      "https://github.com/FaceND/Scroll_To_Recent"

#property description "The ScrollToRecentButton indicator provides a convenient button"
#property description "for quickly scrolling to the most recent data on the chart. It"
#property description "enhances the user experience by allowing traders to easily"
#property description "navigate to the latest price action without manually scrolling"
#property description "through historical data." 

#property indicator_plots 0
#property indicator_chart_window

#define BUTTON_NAME "ScrollToRecentButton"

#define BUTTON_X_POSITION 50
#define BUTTON_Y_POSITION 50
#define BUTTON_WIDTH      25
#define BUTTON_HEIGHT     25

input group "POSITION"
input ENUM_BASE_CORNER   positon       = CORNER_RIGHT_LOWER;   // Position

input group "STYLE"
input color              text_color    = clrBlack;             // Text Color
input color              button_color  = clrWhite;             // Button Color

bool autoScroll;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!CreateButton())
     {
      return(INIT_FAILED);
     }
   autoScroll = ChartGetInteger(0, CHART_AUTOSCROLL);
   UpdateButtonVisibility();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ChartSetInteger(0, CHART_AUTOSCROLL, autoScroll);
   ObjectDelete(0, BUTTON_NAME);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int           rates_total,
                const int       prev_calculated,
                const datetime          &time[],
                const double            &open[],
                const double            &high[],
                const double             &low[],
                const double           &close[],
                const long       &tick_volume[],
                const long            &volume[],
                const int             &spread[])
  {
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Chart event handler function                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTON_NAME)
     {   
      ChartNavigate(0, CHART_END);
      
      ObjectDelete(0, BUTTON_NAME);
     }
   if(id == CHARTEVENT_CHART_CHANGE || id == CHARTEVENT_MOUSE_WHEEL)
     {
      UpdateButtonVisibility();
     }
  }
//+------------------------------------------------------------------+
//| Function to create a button                                      |
//+------------------------------------------------------------------+
bool CreateButton()
  {
   if(!ObjectCreate(0, BUTTON_NAME, OBJ_BUTTON, 0, 0, 0))
     {
      Print("Failed to create the button object: ", BUTTON_NAME);
      return(false);
     }
   //-- Set button properties
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_XDISTANCE, BUTTON_X_POSITION);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_YDISTANCE, BUTTON_Y_POSITION);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BACK, false);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BGCOLOR, button_color);
   
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BORDER_COLOR, button_color);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_CORNER, positon);

   //-- Set text properties
   ObjectSetString (0, BUTTON_NAME, OBJPROP_TEXT, ">>");
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_COLOR, text_color);
   ObjectSetString (0, BUTTON_NAME,OBJPROP_FONT, "Arial Bold");
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_FONTSIZE, 12);

   return(true);
  }
//+------------------------------------------------------------------+
//| Function to update button visibility based on chart position     |
//+------------------------------------------------------------------+
void UpdateButtonVisibility()
  {
   ChartSetInteger(0, CHART_AUTOSCROLL, false);
   Timeout(150);
   long firstVisibleBarIndex = ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
   long visibleBarsCount = ChartGetInteger(0, CHART_VISIBLE_BARS)-1;
   if(firstVisibleBarIndex == visibleBarsCount)
     {
      ObjectDelete(0, BUTTON_NAME);
     }
   else
     {
      if(ObjectFind(0, BUTTON_NAME) == -1)
        {
         CreateButton();
        }
     }
  }
//+------------------------------------------------------------------+
//| Function to execution for the given number of milliseconds       |
//+------------------------------------------------------------------+
void Timeout(double ms)
  {
   double timeWait = GetTickCount() + ms;
   while(GetTickCount() < timeWait);
  }
//+------------------------------------------------------------------+