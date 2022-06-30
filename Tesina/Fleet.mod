/*********************************************
 * OPL 22.1.0.0 Model
 * Author: lucaz
 * Creation Date: 27 giu 2022 at 16:33:53
 *********************************************/
/*
{string} alimenti = ...;
{string} valori_nutrizionali = ...;
float costo[alimenti] = ...;
float quant_max[alimenti] = ...;
float val_nutr_min[valori_nutrizionali] = ...;
float val_nutr_unitari[valori_nutrizionali][alimenti] = ...;
*/
{string} C    = ...;
{string} F    = ...;
int      S[F] = ...;

tuple l {
		  string  	o;
		  string	d;
		  int       t;
	};

{l} L    = ...;

int c[F][L]    = ...;

int t[F][C][C]    = ...;

range time = 1..10;
int t0=2;
// per fare un filtraggio
{l} myPs={k | k in L : k.t < 2};
{l} test={k |k in L: (k.t+t["Alitalia"][k.o][k.d]) > t0 && t0 > k.t};

//parte dvar

dvar boolean x[F][L];
dvar int y[F][C][time] ;
dvar int z[F][C][time];
/*
execute{
  var f,o,t_iter;
  for (f in F){for (o in C){ for (t_iter in time){
     ma=z[f][o][t_iter]+y[f][o][((t_iter-1) == 0)?1 : (t_iter-1)];
     writeln("\n",ma);
    }}}
  }  

execute{
  var f,o,t_iter;
   for (f in F, o in C,t_iter in time   ){
	  			((z[f][o][t_iter]+y[f][o][((t_iter-1) == 0)?1 : (t_iter-1)] - 
	  			sum (d in C,k in L : k.d == d) 
	  			(x[f][k]))-y[f][o][t_iter])== 0;
           }	
  }*/
//parte costraints
constraint Vincolo1[L];
//successiva
	minimize
		sum (f in F)
		  sum(l in L)
			c[f][l]*x[f][l];
	subject to{
	  //primo vincolo
	        forall(f in F, t_iter in time, o in C){
        sum(k in L : (k.t+t[f][k.o][k.d])==t_iter)
          (x[f][k])==z[f][o][t_iter];
        }
	   
	  forall (l in L)
	    Vincolo1[l]:
	  			sum (f in F)
	  	  		x[f][l]==1;
	  //secondo vincolo	  		

     //terzo vincolo

     forall(f in F)
       Vincolo3:
       
	       sum(k in L: (k.t+t[f][k.o][k.d]) >= t0 && t0 >= k.t)
	         	(x[f][k])+
	       sum(o in C)
	         	y[f][o][t0]
       <=S[f];        
           
         
         	
      forall (f in F, o in C,t_iter in time   ){
	      y[f][o][t_iter]>=0;
       }         
 
 	  forall (f in F,k in L){
 		Vincolo2:
		(z[f][k.o][k.t]    +   y[f][k.o][((k.t-1) == 0)?1 : (k.t-1)] - 
		sum (d in C : k.d==d) (
			
				(x[f][k]))-
				y[f][k.o][k.t])== 0;
           }
        /*

        */ 
    }      	 
	       	  			  		
	  
 

/*
dvar float+ x[alimenti];
constraint Vincolo1[valori_nutrizionali];
//constraint Vincolo2[alimenti];


	subject to
	{
		forall (i in valori_nutrizionali)
			Vincolo1[i]:
				sum (j in alimenti)
					val_nutr_unitari[i][j] * x[j] >= val_nutr_min[i];
		forall(j in alimenti)
			Vincolo2:	  
				x[j] <= quant_max[j];
	}
 */
 execute PARAMS {
  cplex.tilim = 3600.000;
}

execute DISPLAY
{
    //writeln("\n",time);
    //writeln("\n",x);
    //writeln("\n",y);
    writeln("\n",test);
    /*
  	writeln ("\r\n\r\n Valore funzione obiettivo: ", cplex.getObjValue());
	writeln("\n\n Variabili decisionali: \n");
	
	for(a in alimenti)
	if(x[a] != 0)
	writeln("\t x[", a,"]: ", x[a]);
	
	writeln("\n\n Costi ridotti: \n");
    for(a in alimenti)
    writeln("Costo ridotto di x[",a,"] = ", x[a].reducedCost);
	
	var a, b, c;
    writeln("\n\n Scarti del primo gruppo di vincoli: \n");
    for(b in Vincolo1)
    writeln("Scarto del vincolo [",b,"] = ", Vincolo1[b].slack);
    
    writeln("\n\n Scarti del secondo gruppo di vincoli: \n");
    for(a in Vincolo2)
    writeln("Scarto del vincolo [",a,"] = ", Vincolo2[a]);
    
    writeln("\n\n Scarti del secondo gruppo di vincoli: \n");
    for(c in Vincolo3)
    writeln("Scarto del vincolo [",c,"] = ", Vincolo3[c].slack);
    /*
    writeln("\n\n Scarti del secondo gruppo di vincoli: \n");
    for(b in Vincolo2)
    writeln("Scarto del vincolo [",b,"] = ", Vincolo2[b].slack);
    
    writeln("\n\n Variabili duali del primo gruppo di vincoli: \n");
    for(c in Vincolo1)
    writeln("Variabile duale del vincolo1[",c,"] = ", Vincolo1[c].dual);
    
    writeln("\n\n Variabili duali del secondo gruppo di vincoli: \n");
    for(c in Vincolo2)
    writeln("Variabile duale del vincolo1[",c,"] = ", Vincolo2[c].dual);
    */
}
 