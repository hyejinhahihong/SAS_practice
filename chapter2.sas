
/*CHAPTER2. ANOVA*/

proc print data=sasuser.admit(obs=15);
run;

proc univariate data=sasuser.admit;
class sex;
var weight;
probplot weight / normal
(mu=est sigma=est color=blue w=1);
/*sex=M에 대해선 그려져있는 직선 위에 직선개형의 점들이 그려져있음.. 이건 다른 모수값을 가지는 정규분포를 따를수도 있다고 생각할수있음*/
title 'Univariate Analysis of the admit Data';
run;
proc sort data=sasuser.admit out=admit_sort;
by sex;
run;
proc boxplot data=admit_sort;
plot weight*sex / cboxes=black boxstyle=schematic;
run;

proc glm data=sasuser.admit;
class sex;
model weight=sex ; 
/*여기선 =으로 formula표시해주네*/

proc univariate data=sasuser.admit;
class actlevel;
var weight;
title 'Paint Data: Descriptive Statistics';
run;
proc sort data=sasuser.admit out=admit_sort;
by actlevel;
run;
proc boxplot data=admit_sort;
plot weight*actlevel / cboxes=black boxstyle=schematic;
run;

proc glm data=sasuser.admit;
class actlevel;
model weight=actlevel;
lsmeans actlevel / pdiff=all adjust=t;
title 'Paint Data: Multiple Comparisons';
run;
quit;

proc glm data=sashelp.cars;
class make;
model invoice=make;
lsmeans make / pdiff=all adjust=t;
run;
quit;

proc glm data=sashelp.cars;
class origin;
model invoice=origin;
lsmeans origin / pdiff=all adjust=t ;
means origin / tukey;
run;
/*이 상태를 그림으로 표시해서 볼 수 있는데 class수 너무 많아지니까 보기가 불편*/
/*수치적으로 검정하는게 tukey,duncan*/
quit;

proc glm data=sashelp.cars;
class origin;
model invoice=origin / solution;
/*tukey쓴거랑 같은 결과를 볼 수 있다_ solution은 class값들을 더미변수로 만들어서 변수간 관계 보여주게끔*/
/*linear한 형태로 표현해줬지*/
run;
/*이 상태를 그림으로 표시해서 볼 수 있는데 class수 너무 많아지니까 보기가 불편*/
/*수치적으로 검정하는게 tukey,duncan*/
quit;



proc glm data=sasuser.admit;
class sex;
model weight=sex / solution ; 
/*solution추가시의 의미*/
means sex / hovtest;
/*만약에 등분산성 가정 기각시 hovtest welch*/
output out=check r=resid p=pred;
title 'Testing for Equality of Means with PROC GLM';
run;

proc glm data=sasuser.admit;
class sex;
model weight=sex / solution ; 
/*solution추가시의 의미*/
means sex / hovtest;
output out=check r=resid p=pred;
title 'Testing for Equality of Means with PROC GLM';
run;

proc print data=check;
run;
quit;

proc gplot data=check;
plot resid*pred / haxis=axis1 vaxis=axis2 vref=0;
/*vref=0이면 y=0에서 선그어*/
symbol v=star h=3pct;
axis1 w=2 major=(w=2) minor=none offset=(10pct);
axis2 w=2 major=(w=2) minor=none;
title 'Plot of Residuals vs. Predicted Values for Cereal Data Set';
/*그림 그려진 결과 보면 f,m의 y값 범위가 비슷해 _ 고로 등분산이라 할 수 있겠다*/
run;
quit;

proc univariate data=check normal;
var resid;
histogram / normal;
probplot / normal (mu=est sigma=est color=blue w=1);
title;
run;

