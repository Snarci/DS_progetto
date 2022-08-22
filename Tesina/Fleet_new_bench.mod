/*********************************************
 * OPL 22.1.0.0 Model
 * Author: lucaz
 * Creation Date: 4 lug 2022 at 15:21:41
 *********************************************/
 {string} F = ... ;
 int S[F] = ...;
 {string} C = ...; 
 
 tuple l {
   	string o;
   	string d;
   	int t;
   	};
 {l} L = ...;
 
 range time = 0..30;
 
 tuple t_struct{
   	string f;
   	string o;
   	string d;
   	} 
 {t_struct} t_list = ... ;
 
 int t[t_list] = ...;

 int c[F][L] = ...;

 tuple h{
  	l f1;
  	l f2;
  	}
 {h} H = ...;  

 int t0 = 0;

//variabili decisionali
//chi fa il volo cct
dvar boolean x[F][C][C][time];
//quanti aerei aspettano a terra
dvar int+ y[F][C][time];
//quanti arrivano in c in tempo t
dvar int+ z[F][C][time];



minimize		
	sum (f in F)
	  sum(k in L)
		c[f][k]*x[f][k.o][k.d][k.t];
subject to{
    //siano soddiscfatti i max 1 per ogni volo
  	forall(k in L)
  	  Vincolo_1:
  	  sum(f in F)(
  	  	x[f][k.o][k.d][k.t])==1;
  	//conservation of flow   	
  	forall(f in F,o in C,t_i in time : t_i >=1)
  	  (
  	  z[f][o][t_i]+y[f][o][(t_i-1)]-
  	  sum(d in C : d!=o )(
  	  	x[f][o][d][t_i])-
  	  	y[f][o][t_i]
  	  	
  	  )==0;
  	//non negatività della y e z  
  	forall(f in F,o in C,t_i in time)(
  		y[f][o][t_i]>=0 && z[f][o][t_i]>=0
  	);
  	//condizione per evitare che siano più aerei che potenza della flotta
	forall(f in F)(
		(
			sum(k in L: k.t==(t0+1))(
				x[f][k.o][k.d][k.t]
			)+
			sum(o in C)(
				y[f][o][t0]
			)
		)<=S[f]
	);
	//condizione per segnare gli arrivi z
	forall(f in F, t_i in time, d in C)(	
		sum(<o1,d1,t_part> in L: (t_part+t[<f,o1,d1>])==t_i && d == d1)(
			x[f][o1][d1][t_part]
		)==z[f][d][t_i]
	);
	
	//non scambi a caso quando arivano gli aerei
	forall(f in F,o in C,d in C,t_i in time : <o,d,t_i> not in L)
	    (
		  (x[f][o][d][t_i])==0
		);
		
	//vincolo per H coppie di voli stessa compagnia
	forall(f in F,<f1,f2> in H)(
		
			(x[f][f1.o][f1.d][f1.t]-x[f][f1.d][f2.d][f2.t]
			)==0
	);
	/**/
  }
  
 execute PARAMS {
  cplex.tilim = 25200;
  cplex.LPMethod  = 2; 
}  
//sono le x formattate bene e capibili  
int xf[L][F];  
  execute DISPLAY
{
  // in pratica salvo tutto x in maniera bellina dentro xf
  var f,k;
   for(f in F){
     for(k in L){
       xf[k][f]=x[f][k.o][k.d][k.t];
       }
     }
}
  