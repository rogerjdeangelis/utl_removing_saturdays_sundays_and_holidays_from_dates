Removing Saturdays, Sundays and Holidays from dates

Same results in WPS and SAS

see
https://tinyurl.com/yaa5aomz
https://github.com/rogerjdeangelis/utl_removing_saturdays_sundays_and_holidays_from_dates

see
https://goo.gl/bsVpkN
https://communities.sas.com/t5/General-SAS-Programming/Append-5-consecutive-data-set-in-a-library/m-p/421470


see
https://tinyurl.com/y9uhyhh8
https://communities.sas.com/t5/Base-SAS-Programming/exploring-code-to-calculate-working-days/m-p/450578


INPUTS
======

  FORMAT

    proc format;
      value utl_holidays
         '25DEC2017'd = '1'
         '09OCT2017'd = '1'
         '17APR2017'd = '1'
         '19JUN2017'd = '1'
         '31OCT2017'd = '1'
         '04SEP2017'd = '1'
         '16JAN2017'd = '1'
         '29MAY2017'd = '1'
         '15MAY2017'd = '1'
         '01JAN2017'd = '1'
         '23NOV2017'd = '1'
         '04JUL2017'd = '1'
         '20FEB2017'd = '1'
         '14FEB2017'd = '1'
         '13NOV2017'd = '1'
          other       = '0'
      ;
    run;quit;

  WORK.HAVE total obs=365

    Obs         DATE    PERCENT

      1    01JAN2017        2
      2    02JAN2017       57
      3    03JAN2017       39
    ...
    357    23DEC2017        9
    358    24DEC2017       65
    359    25DEC2017       10
    360    26DEC2017       25
    361    27DEC2017       70
    362    28DEC2017       76
    363    29DEC2017       12
    364    30DEC2017       20
    365    31DEC2017       51


PROCESS (ALL THE CODE)
======================

  proc sql;
    create
      table want as
    select
      date
     ,weekday(date) as day
     ,percent
    from
      have
    where
      put(date,utl_holidays.) eq '0' and
      weekday(date) not in (1,7)  /* 2-6 mon-fri */
  ;quit;


OUTPUT
======

  WORK.WANT  obs=246

    Obs         DATE    PERCENT

                               Jan 1st Holiday
      2    02JAN2017       57
      3    03JAN2017       39
    ...

    242    22DEC2017       83
                               Dec 23rd Saturday
                               Dec 24th Sunday
                               Dec 25th Holiday
    243    26DEC2017       25
    244    27DEC2017       70
    245    28DEC2017       76
    246    29DEC2017       12
                               Dec 30 Saturday
                               Dec 31 Sunday

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

proc format;
  value utl_holidays
     '25DEC2017'd = '1'
     '09OCT2017'd = '1'
     '17APR2017'd = '1'
     '19JUN2017'd = '1'
     '31OCT2017'd = '1'
     '04SEP2017'd = '1'
     '16JAN2017'd = '1'
     '29MAY2017'd = '1'
     '15MAY2017'd = '1'
     '01JAN2017'd = '1'
     '23NOV2017'd = '1'
     '04JUL2017'd = '1'
     '20FEB2017'd = '1'
     '14FEB2017'd = '1'
     '13NOV2017'd = '1'
      other       = '0'
  ;
run;quit;

data have;
  do date='01JAN2017'd to '31DEC2017'd;
    percent=int(100*uniform(5731));
    output;
  end;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

*SAS;

proc sql;
  create
    table want as
  select
    date
   ,weekday(date) as day
   ,percent
  from
    have
  where
    put(date,utl_holidays.) eq '0' and
    weekday(date) not in (1,7)  /* monday-saturday */
;quit;


*WPS;

%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc format;
  value utl_holidays
     "25DEC2017"d = "1"
     "09OCT2017"d = "1"
     "17APR2017"d = "1"
     "19JUN2017"d = "1"
     "31OCT2017"d = "1"
     "04SEP2017"d = "1"
     "16JAN2017"d = "1"
     "29MAY2017"d = "1"
     "15MAY2017"d = "1"
     "01JAN2017"d = "1"
     "23NOV2017"d = "1"
     "04JUL2017"d = "1"
     "20FEB2017"d = "1"
     "14FEB2017"d = "1"
     "13NOV2017"d = "1"
      other       = "0"
  ;
run;quit;
data have;
  do date="01JAN2017"d to "31DEC2017"d;
    percent=int(100*uniform(5731));
    output;
  end;
run;quit;
  proc sql;
    create
      table wrk.want as
    select
      date
     ,weekday(date) as day
     ,percent
    from
      have
    where
      put(date,utl_holidays.) eq "0" and
      weekday(date) not in (1,7)  /* monday-saturday */
  ;quit;
');

