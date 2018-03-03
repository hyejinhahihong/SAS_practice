proc print data=sashelp.cars;
run;

proc univariate data=sashelp.cars;
var invoice --  length;
histogram invoice -- length / normal;
probplot invoice -- length / normal (mu=est sigma=est color=red w=2);
run;



proc gplot data=sashelp.cars;
plot invoice * (enginesize cylinders horsepower mpg_city mpg_highway weight wheelbase length);
symbol1 v=dot h=1 w=1 color=red;
title h=3 color=green'Plot of invoice by Other Variables';
run;
quit;



/*145쪽*/
proc corr data=sashelp.cars;
var invoice enginesize cylinders;
/*3*3테이블 나와*/
run;

proc corr data=sashelp.cars nosimple;
var enginesize cylinders;
with invoice;
run;

proc corr data=sashelp.cars;
/*nosimple사용시 기초통계량은 안뽑아줌*/
var enginesize cylinders;
with invoice;
/*invoice 중심으로 구함*/
/*enginesize cylinders 각각에 대해선 안구함*/
/*1*2*/
run; 

proc reg data=sashelp.cars;
model invoice=length;
run;

data need_predictions;
input enginesize @@;
datalines;
2 2.5 3 3.5 4
;
run;
data predeng;
set sashelp.cars
need_predictions;
run;
proc reg data=predeng;
model invoice=enginesize / clm cli alpha=.05;
id model;
title 'invoice=enginesize with Predicted Values';
run;
quit;

proc reg data=predeng;
model invoice=enginesize / p clm;
id model;
title 'invoice=enginesize with Predicted Values';
run;
quit;

proc reg data=sashelp.cars;
model invoice=enginesize horsepower ;
id model;
title 'multiple linear regression';
run;
quit;

proc reg data=sashelp.cars;
model invoice=enginesize horsepower mpg_city mpg_highway weight wheelbase length
/selection =rsquare adjrsq cp best=4;
plot cp.*np./ nomodel nostat
cmallows=red
chocking=blue;
symbol v=plus color=green h=2;
/*근데 이코드로는 그림이 이상하게 나와서 어떻게 해석해야하는지 모르겠어*/
run;
quit;


proc reg data=sashelp.cars;
model invoice=enginesize horsepower mpg_city mpg_highway weight wheelbase length
/selection =forward;
run;
quit;

/*practice*/
/*regression에서 outest이용해서 beta0,1값들을 매크로 변수로 생성해
(단순회귀_아무데이터셋에서 estimate값을 받아와서 할 수 있게끔)*/

/*OUTEST=
outputs a data set that contains parameter estimates and other 
model fit summary statistics*/

proc reg data=sashelp.cars outest=a;
model invoice=enginesize;
quit;
run;

data b;
input engine @@;
set a;
call symputx('beta0',intercept);
call symputx('beta1',enginesize);
%put &beta0 and &beta1;
invoice2=&beta0+&beta1*engine;
put engine= invoice2=;
datalines;
1 2 3 4 5 6 7 8 9 10
;
run;
