/*********************************************
 * OPL 22.1.0.0 Model
 * Author: lucaz
 * Creation Date: 27 giu 2022 at 16:28:58
 *********************************************/

{string} alimenti = ...;
{string} valori_nutrizionali = ...;
float costo[alimenti] = ...;
float quant_max[alimenti] = ...;
float val_nutr_min[valori_nutrizionali] = ...;
float val_nutr_unitari[valori_nutrizionali][alimenti] = ...;

dvar float+ x[alimenti];
constraint Vincolo1[valori_nutrizionali];
//constraint Vincolo2[alimenti];

	minimize
		sum (j in alimenti)
			costo[j] * x[j];
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
 
 execute PARAMS {
  cplex.tilim = 3600.000;
}

execute DISPLAY
{
  	writeln ("\r\n\r\n Valore funzione obiettivo: ", cplex.getObjValue());
	writeln("\n\n Variabili decisionali: \n");
	var a, b, c;
	for(a in alimenti)
	if(x[a] != 0)
	writeln("\t x[", a,"]: ", x[a]);
	
	writeln("\n\n Costi ridotti: \n");
    for(a in alimenti)
    writeln("Costo ridotto di x[",a,"] = ", x[a].reducedCost);
	
    writeln("\n\n Scarti del primo gruppo di vincoli: \n");
    for(b in Vincolo1)
    writeln("Scarto del vincolo [",b,"] = ", Vincolo1[b].slack);
    
    writeln("\n\n Scarti del secondo gruppo di vincoli: \n");
    for(b in Vincolo2)
    writeln("Scarto del vincolo [",b,"] = ", Vincolo2[b].slack);
    
    writeln("\n\n Variabili duali del primo gruppo di vincoli: \n");
    for(c in Vincolo1)
    writeln("Variabile duale del vincolo1[",c,"] = ", Vincolo1[c].dual);
    
    writeln("\n\n Variabili duali del secondo gruppo di vincoli: \n");
    for(c in Vincolo2)
    writeln("Variabile duale del vincolo1[",c,"] = ", Vincolo2[c].dual);
}
 