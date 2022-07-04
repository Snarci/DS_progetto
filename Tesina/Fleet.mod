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
int t0=3;
// per fare un filtraggio
//{l} myPs={k | k in L : k.t < 2};
{l} test={k |k in L: (k.t<t0 && k.t+t["Alitalia"][k.o][k.d]>t0)};

//parte dvar

dvar boolean x[F][C][C][time];
dvar int y[F][C][time] ;
dvar int z[F][C][time];

//parte costraints

//successiva
	minimize
		sum (f in F)
		  sum(k in L)
			c[f][k]*x[f][k.o][k.d][k.t];
	subject to{
	  
	  //init
		
  	  //primo vincolo
  	  forall (k in L)
      	Vincolo1:(
  			sum (f in F)
  	  			x[f][k.o][k.d][k.t])==1;
  	  
	  //secondo vincolo	 x+yi 		
      forall (f in F, o in C, t_i in time )
        Vincolo2:(
        	z[f][o][t_i]	+	y[f][o][((t_i-1) <= 0)?1 : (t_i-1)] - 
        		sum(d in C)(
        			x[f][o][d][t_i])
        			-
        			y[f][o][t_i]
        			)==0;
      //terzo vincolo
      //da fare quando ci sono i voli strani
      //quarto vincolo
      forall(f in F)
        Vincolo4:
        (
        	sum(k in L: (k.t<=t0 && k.t+t[f][k.o][k.d]>=t0))(
        	  ((x[f][k.o][k.d][k.t])) + 
        	sum(o in C)
        	  (y[f][o][t0])) 
    	)<=S[f];
 		
 	   //
 	   forall(f in F, o in C, t_i in time)
 	     y[f][o][t_i]>=0   ;	
//condizione 
	      /*forall(f in F,o in C, t_i in time){
		  sum(k in L : k.t+t[f][k.o][k.d]==t_i && k.o==o)
  				(x[f][k.d][k.o][k.t])==z[f][o][t_i];
        }
       

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
 