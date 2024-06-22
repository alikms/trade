//+------------------------------------------------------------------+59-80
//|                                                MySignalPrice.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
#include "..\ExpertSignal.mqh"
class MySignalPrice:public CExpertSignal
  {
public:
                     MySignalPrice(void);
                    ~MySignalPrice(void);
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);
   void              findExt(int pos,int barsfrom);
   void              checkBrOut(bool bs);
   bool              checkExtClose(void);
protected:
   int                  m_pattern_1;
   int                  m_pattern_2;
   int                  m_pattern_3;
   int               depth,backstep;
   int                  lasthigh_ind,BrUpCandle_ind;
   int                  lastlow_ind,BrDownCandle_ind;
   int                  barsFromBrUp,barsFromBrDown;
   bool                 BrUp,BrDown,CloseUpper,CloseLower;
   datetime             BrUptime,BrDowntime;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MySignalPrice::MySignalPrice(void):depth(8),backstep(5),m_pattern_3(100) {};
MySignalPrice::~MySignalPrice(void) {};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//In bar 0 extremum=ihighest(,,d+b,start+b)
//Check if xtremum ==ihighest(,,d+b,extremum)
//if i high0 to high[d] ->brup True start=d-i
//if i close0 to close[d] brup False start = 0
//return brup for bs false

















void MySignalPrice::findExt(int pos,int barsfrom) ////add finding minimum
  {
   int ind;
   int start;
   start=pos+barsfrom-backstep>0?pos+barsfrom-backstep:0;
   ind=iHighest(_Symbol,_Period,MODE_HIGH,depth+backstep,start);
   if(BrUp)
     {
      lasthigh_ind++;
     }
   else
     {
      if(ind==iHighest(_Symbol,_Period,MODE_HIGH,depth+backstep,ind)&&ind!=lasthigh_ind)
        {
         lasthigh_ind=ind;
         CloseUpper=false;
        }
      else
        {
         findExt(ind,depth+backstep);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MySignalPrice::checkBrOut(bool bs)
  {
   if(bs) {}
   else
     {
        {
         if(BrUp&&!CloseUpper)
           {
            barsFromBrUp++;
           }
         else
           {
            if(High(0)>High(lasthigh_ind)&&!CloseUpper)
              {
               BrUp=true;
               BrUptime=iTime(_Symbol,_Period,0);
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MySignalPrice::checkExtClose(void)
  {
   if(Close(0)>High(lasthigh_ind)||Bars(_Symbol,_Period,BrUptime,iTime(_Symbol,_Period,0)))
     {
      CloseUpper=true;
      BrUp=false;
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
int MySignalPrice::LongCondition(void)
  {
   if(IS_PATTERN_USAGE(3))
     {
      //int ind=BrUpCandle_ind==0?1:BrUpCandle_ind;
      ////findExt(ind);
      //return m_pattern_3;
     }

   return 0;
  };
//-------------------------------------------------
int MySignalPrice::ShortCondition(void)
  {
   int result=0;
   findExt(1,barsFromBrUp);
   checkBrOut(false);
   if(IS_PATTERN_USAGE(3) &&!CloseUpper && BrUp&&checkExtClose())
     {
      //////
      //m_pa
      result=m_pattern_3;
     }


   return result;
  }
//+------------------------------------------------------------------+
