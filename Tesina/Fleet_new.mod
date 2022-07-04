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
 
 int c[F][L] = ...;
 
 range time = 0..15;
 
 tuple t_struct{
   string f;
   string o;
   string d;
   }
    
{t_struct} t_list = ... ;
 
int t[t_list] = ...;

int t0 = 0;

{l} O = {l | l in L : l.t == t0}; 

dvar boolean x[F][C][C][time];
dvar int y[F][C][time];
dvar int z[F][C][time];

minimize		
	sum (f in F)
	  sum(k in L)
		c[f][k]*x[f][k.o][k.d][k.t];
subject to{
  
  	forall(k in L)
  	  Vincolo_1:
  	  sum(f in F)(
  	  	x[f][k.o][k.d][k.t])==1;
  	  	
  	  	
  	forall(f in F,o in C,t_i in time : t_i >=1)
  	  (
  	  z[f][o][t_i]+y[f][o][(t_i-1)]-
  	  sum(d in C : d!=o )(
  	  	x[f][o][d][t_i])-y[f][o][t_i]
  	   
  	  )==0;
  	  
  	  
  	forall(f in F,o in C,t_i in time)(
  		y[f][o][t_i]>=0 && z[f][o][t_i]>=0
  	);
  	
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
	
	
	forall(f in F, t_i in time, d in C)(
		
		sum(<o1,d1,t_part> in L: (t_part+t[<f,o1,d1>])==t_i && d == d1)(
			x[f][o1][d1][t_part]
		)==z[f][d][t_i]
	);

	forall(f in F,o in C,d in C,t_i in time,k in L: k.d!=d && k.o != o && k.t!=t_i )(
		  (x[f][o][d][t_i])==0
	);
		/**/
  }