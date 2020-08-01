{â™¥ROLANDO ANDRADEâ™¥, MARIO AVENA, ADOPTADAS(STEPHANIE CRUZ, DANIELA DA SILVA), RAFAEL MENDEZ}
{--------------------ENTREGA FINAL--------------------}
{

ATENCIÓN: Las dimensiones ideales de la consola son 120x60
PARA LA BUENA VISUALIZACIÓN DEL PROGRAMA ES RECOMENDABLE REAJUSTAR LAS DIMENSIONES DE LA CONSOLA, PARA ELLO REALICE LOS SIGUIENTES PASOS:

1-Click derecho en la cabecera de la consola
2- Propiedades.
3- Seleccione la pestaña diseño
4 -En ancho establezca 100
5- En alto 80.
6- Aceptar.
7- Reiniciar el programa.

}

program AutomataCelularAlive;
//Librerías a utilizar
uses crt,graph;
//Definción de constantes
const
    filas = 30;//Se declaran como constantes los valores máximos
    columnas=30;//Se declaran como constantes los valores máximos
type
    matriz=array[1..filas,1..columnas] of integer;//Se define matriz como un arreglo bidimensional
var
	n,m,vivas,i,j: Integer;             //n: filas, m: columnas, vivas: células
    datos,cultivo:boolean;                         //Algunas condiciones para el menú
    celdas:matriz;                                 //El caldero de cultivo
    driver,modo:SmallInt;                          //Parámetros de InitGraph
    entrada,salida:text;                           //Archivos

{<<<--------------------Mensaje de error-------------------->>>}

procedure error(a:integer);//Recibe el número de lÃ­nea a donde debe devolverse
begin
    delay(2000);//Espera dos segundos
    delline;//Borra línea
    gotoxy(1,a);//Devuelve a la línea dada
    delline;//Borra hasta el final de línea
    gotoxy(1,a);//Vuelve al principio de línea
    TextColor(8);  
end;

{<<<--------------------Vaciar Caldero-------------------->>>}

function limpia(a:matriz;n,m:integer;var gen:integer): matriz;//recibe el caldo, las dimensiones y el número de generación
var
    i,j: Integer;
begin
    gen:=1;//resetea las generaciones
    for i := 1 to n do
    begin
        for j := 1 to m do
        begin
            a[i,j]:=0;//célula muerta
        end;
    end;
    limpia:=a;
end;

{<<<--------------------Introducir coordenadas de manera manual-------------------->>>}

procedure manual(var a:matriz;n,m,vivas:integer);//recibe la matriz, las dimensiones y el número de células vivas
var
    i,j,l: Integer;
begin
    clrscr;
    cultivo:=true;//se creó un cultivo
    l:=1;//contador de líneas

    {--Poner células hasta que no hayan suficientes vivas--}

    while (vivas>0) do
        begin
            {--Pedir fila hasta que sea válida--}
            repeat
                write('Introduce fila: ');
                readln(i);
                //Verificar que sea válida la fila
                if(i<=0)or(i>n)then
                begin
                    TextColor(3);
                    writeln('Error: No existe!');
                    error(l);
                    delline;
                    delline;
                end;
            until (i>0)and(i<=n);

            l:=l+1;//Salto de línea

            {--Pedir columna hasta que sea válida--}
            repeat
                write('Introduce columna: ');
                readln(j);
                //Verificar que sea válida la columna
                if(j<=0)or(j>m)then
                begin
                    TextColor(3);
                    writeln('Error: No existe!');
                    error(l);
                    delline;
                    delline;
                end;
            until (j>0)and(j<=m);

            l:=l+1;//salto de línea

            if (a[i,j]=0) then//Si la casilla está¡ vacía
                begin
                    a[i,j]:=1;//Se coloca viva
                    vivas:=vivas-1;//Se reducen las que faltan
                end
            else//Si está¡ ocupada marca error
                begin
                    TextColor(3);
                    writeln('Error: Esta ocupada :(!');
                    error(l);
                end;
        end;
end;

{<<<--------------------Pedir y validar entrada de datos-------------------->>>}

procedure PedirValidar(var n,m,vivas:integer);
var
    s: char;
    largotabla:Integer;
begin
	{
    Condiciones:
		A- El número de filas (n) y columnas (m) pueden ser hasta el valor 30 y no menos de 10.
		B- El número de células vivas debe ser menor o igual al número de celdas de la matriz.
	}	
	{--Pedir número de FILAS con las condiciones adecuadas--}
    datos:=true;
    cultivo:=false;
    n:=0;
    m:=0;
    vivas:=0;
	repeat
        TextColor(8);
		write('Por favor, Introduzca el numero de filas: ');
		readln(n);
		if (n<10) then
            begin
                TextColor(3);
                writeln('Error: Son muy pocas filas!');
                error(1);
            end
		else if(n>30) then
            begin
                TextColor(3);
                writeln('Error: Son demasiadas filas!');
                error(1);
            end;
			
	until (n>=10)and(n<=30);	

	{--Pedir número de COLUMNAS con las condiciones adecuadas--}

	repeat
		write('Por favor, Introduzca el numero de columnas: ');
		readln(m);
		if (m<10) then
            begin
                TextColor(3);
                writeln('Error: Son muy pocas columnas!');
                error(2);
            end
		else if(m>30) then
            begin
                TextColor(3);
                writeln('Error: Son demasiadas columnas!');
                error(2);
            end;
			
	until (m>=10)and(m<=30);

	{--Obtener el largo de la tabla--}

	largotabla:=n*m;

	{--Pedir número de CÉLULAS VIVAS con las condiciones adecuadas--}

	repeat
		write('Por favor, Introduzca el numero de celulas vivas: ');
		readln(vivas);
		if (vivas<n) then
            begin
                TextColor(3);
                writeln('Error: Con tan pocas celulas no hay diversion!');
                error(3);   
            end	
		else if(vivas>largotabla) then
            begin
                TextColor(3);
                writeln('Error: Hay celulas que no tienen donde vivir!');
                error(3);    
            end;
	until (vivas>=n)and(vivas<=largotabla);

    {--Pedir coordenadas--}

    repeat
        write('Desea introducir las coordenadas a mano S/N?');
        readln(s);
        s:=upcase(s);
        if (s<>'N')and(s<>'S') then
        begin
            TextColor(cyan);
            writeln('Error, por favor introduzca una S o una N');
            error(4);
        end;                           
    until (s='S')or(s='N');
    //Si la respuesta es afirmativa llama a manual
    if(s='S')then
        manual(celdas,n,m,vivas);
    //Irse casi al final
    gotoxy(1,45);
    writeln('Presione enter para continuar...')
end;

{<<<--------------------Enumerado de filas y columnas-------------------->>>}

procedure Enumerado(x,y,celdas:integer;FilaColumna:char);
//Recibe como parámetros las coordenadas de inicio x/y, en número de filas o columnas, y un caracter que representa la fila o columna
begin
	for i := 1 to celdas do
	begin
		gotoxy(x,y);
        write(i mod 10);
        if FilaColumna='v' then //Es necesario diferenciar de fila y columna porque si (m=n) entonces solo cambiará una coordenada
        	x:=x+1
        else
        	y:=y+1;
	end;
end;

{<<<--------------------Milagro 1-------------------->>>}

procedure Milagro1(var a:matriz;n,m:Integer);//Recibe la matriz y las dimensiones

{<<<--------------------Busca celdas de coordenadas impares-------------------->>>}

    procedure comprueba(a:matriz;i,j:integer;var posi,posj,impares,vacia:Integer);
    //Recibe a la matriz, los índices, la posición (i,j) de la primera casilla vacía, el número de casillas impares y vacías
    begin

        //Si está en una celda de coordenadas impares

        if(i mod 2=1)and(j mod 2=1)then
            impares:=impares+1;

        //Si es una celda de coordenadas impares vacía

        if (i mod 2=1)and(j mod 2=1)and(a[i,j]=0)then
            vacia:=vacia+1;

        //Si es la primera celda vacía

        if (a[i,j]=0)and(posi=0)then
            begin
                posi:=i;
                posj:=j;
            end;
    end;
var
    i,j,dir,r,vacia,impares,posi,posj: Integer;
    paso:boolean;
    s:char;
begin
    dir:=1;//Dirección: 1=DER 2=ABA 3=IZQ 4=ARR
    r:=0;//Posición dentro del espiral. Mientras más grande, más adentro ;)
    impares:=0;//Total de células impares
    vacia:=0;//Total de células vacías impares
    posi:=0;//Posición en i de la primera celda vacía
    i:=1;
    j:=1;
    paso:=false;//Indica si ya se pasó por la columna 1
    repeat
        case dir of
            1://Va hacia la derecha
            begin
                while (j<=m-r) do
                begin
                    comprueba(a,i,j,posi,posj,impares,vacia);
                    j:=j+1;
                end;
                j:=j-1;//j>m por lo que debes restar 1
                i:=i+1;//No queremos repetir la celda (1,m)
                dir:=2;//Cambia hacia abajo
                
            end;
            2://Va hacia abajo
            begin
                while (i<=n-r) do
                begin
                    comprueba(a,i,j,posi,posj,impares,vacia);
                    i:=i+1;
                end;
                i:=i-1;//i>n debes restar 1
                j:=j-1;//No se quiere repetir la celda (n,m)
                dir:=3;//Cambia hacia abajo
                r:=r+1;//Entrará en un nuevo nivel
            end;
            3://Va hacia la izquierda
            begin
                while (j>1) do//ve hasta la columna 1
                begin
                    comprueba(a,i,j,posi,posj,impares,vacia);
                    j:=j-1;
                end;
                //No calcula (n,1)
                dir:=4;//Cambia hacia arriba
            end;
            4://Va hacia la arriba
            begin
                //empieza en (n,1)
                while (i>=1+r) do
                begin
                    if (not paso) then//Si es la primera vez que pasa por la columna debe evaluar
                        comprueba(a,i,j,posi,posj,impares,vacia);
                    i:=i-1;
                end;
                paso:=true;
                i:=i+1;//i=0 por lo que debes sumar 1
                j:=j+1;//No queremos repetir la evaluación de la misma columna
                dir:=1;//Ve hacia la derecha
            end;
        end;
    until (i-r<=0);
    impares:=impares div 2;//50%
    if (vacia=impares) then
    begin

    {--Preguntar si acepta el milagro--}

        repeat
            clrscr;
            writeln('Dios ha decidio hacer el milagro 1, lo quieres aceptar S/N?');
            readln(s);
            s:=upcase(s);
            if (s<>'S')and(s<>'N') then
            begin
                writeln('Error, por favor introduzca una S o una N');
                delay(2000);
            end;
        until(s='S')or(S='N');
        if(s='S')then
            a[posi,posj]:=1
        else
        begin
            writeln('Usted es macabro');
            delay(2000);
        end;
        clrscr;
    end;
end;

{<<<--------------------Milagro 2-------------------->>>}

procedure Milagro2(var a:matriz;n,m:Integer);//Recibe la matriz y dimensiones
var
    i,j,aux,cont,posi,posj,par,vacia: Integer;
    s:char;
begin
    cont:=0;//Número de columna dónde empieza luego de pasar por la diagonal
    i:=0;
    par:=0;//Total de celdas pares
    vacia:=0;//Total de celdas vacías pares
    posi:=0;//Coordenadas de la primera celda vacía
    posj:=0;
    while (cont<m-1) do//hasta que no inicie en (n,m)
        begin
            
            if (i<n) then//si no ha llegado a la última fila
                i:=i+1
            else
                cont:=cont+1;
            j:=1+cont;
            
            aux:=i;
            //Coordenada x par se refiere a la fila
            //Mientras no llegue a la última columna y el aux no sea menos que las filas
            while (j<=m)and(aux>=1) do
                begin
                    if (aux mod 2=0) then//Detecta si la casilla tiene coordenada x par
                        par:=par+1;        
                    if (a[aux,j]=0)and(posi=0) then//Detecta si es la primera casilla vacía
                            begin
                                posi:=aux;
                                posj:=j;
                            end;
                    if(a[aux,j]=0)and(aux mod 2=0) then //Detecta si está vacía y es de coordenada x par
                            vacia:=vacia+1;
                    aux:=aux-1;
                    j:=j+1;   
                end;
        end;
    par:=trunc(par*0.7);//toma la parte entera del 70%
    if (vacia=par) then//Si la cantidad de celdas vacías es igual al del 70% de pares
    begin

    {--Preguntar si acepta el milagro--}

        repeat
            clrscr;
            writeln('Dios ha decidio hacer el milagro 2, lo quieres aceptar S/N?');
            readln(s);
            s:=upcase(s);
            if (s<>'S')and(s<>'N') then
            begin
                writeln('Error, por favor introduzca una S o una N');
                delay(2000);
            end;
        until(s='S')or(S='N');
        if(s='S')then
            a[posi,posj]:=1
        else
        begin
            writeln('Usted es macabro');
            delay(2000);
        end;
        clrscr;
    end;
    
end;

{<<<--------------------Milagro 3-------------------->>>}

procedure Milagro3(var a:matriz;n,m:Integer);
//Recibe a la matriz y las dimensiones

    {<<<--------------------Recorrido en ZigZag de la matriz-------------------->>>}

    function ZigZag(a:matriz;var i,impar,posi,posj,cont:integer;j,n,m,factor:integer): Integer;
    {Recibe la matriz, la fila, el número de células impares, la posición de la primera célula vacía,
    un contador de celdas, la columna, las dimensiones y un factor que indique si suma o resta 1

    Devuelve el número de celdas vacías

    }
    var
        vacia: Integer;//Número de celdas vacías
    begin
        vacia:=0;
        while (i<=n)and(i>=1) do//Mientras no exceda las dimensiones de las filas del cultivo
        begin
            if (j mod 2=1) then//Si es una celda de coordenada y impar
                impar:=impar+1;
            if(a[i,j]=0)and(cont>=(m*n) div 2)and(posi=0)then//Si es una celda vacía, ya va por la mitad del recorrido y es la primera celda vacía con esas condiciones
                begin
                    posi:=i;
                    posj:=j;
                end;
            if(a[i,j]=0)and(j mod 2=1)then//Si está vacía y tiene coordenada y impar
                vacia:=vacia+1;
            i:=i+factor;//Suma o decrementa 1 dependiendo del factor
            cont:=cont+1;//Se recorre una celda más
        end;
        if (i=0) then
            i:=1
        else
            i:=n;
        ZigZag:=vacia; 
    end;
var
    i,j,vacia,impar,posi,posj,cont: Integer;
    sub:boolean;//Indica si sube o baja
    s:char;
begin
    sub:=true;//Está subiendo
    posi:=0;//Coordenadas de la primera celda vacía
    posj:=0;
    vacia:=0;//Contador de vacías
    impar:=0;//Contador de impares
    cont:=1;//Número de celdas recorridas
    i:=n;
    for j := 1 to m do
    begin
        if (sub) then
        begin
            vacia:=vacia+ZigZag(a,i,impar,posi,posj,cont,j,n,m,-1);//Va restando 1 a las filas
            sub:=false;
        end
        else
        begin
            vacia:=vacia+ZigZag(a,i,impar,posi,posj,cont,j,n,m,1);//Va sumando 1 a las filas
            sub:=true;
        end;
    end;
    impar:=trunc(impar*0.6);//Parte entera del 60%
    if (vacia=impar) then
    begin

    {--Preguntar si acepta el milagro--}

        repeat
            clrscr;
            writeln('Dios ha decidio hacer el milagro 3, lo quieres aceptar S/N?');
            readln(s);
            s:=upcase(s);
            if (s<>'S')and(s<>'N') then
            begin
                writeln('Error, por favor introduzca una S o una N');
                delay(2000);
            end;
        until(s='S')or(S='N');
        if(s='S')then
            a[posi,posj]:=1
        else
        begin
            writeln('Usted es macabro');
            delay(2000);
        end;
        clrscr;
    end;
end;

{<<<--------------------Extinción masiva MUAJAJAJAJAJA-------------------->>>}

//EXISTE UNA PROBABILIDAD DEL 10% QUE MUERAN EL LAS CÉLULAS QUE HAY EN EL CULTIVO POR FILAS Y COLUMNAS EN CRUZ

procedure extincion(var a:matriz;n,m:integer);
var
    i,j,aux,azar,muerta:integer;
    s:char;
begin
    randomize;
    muerta:=0;
    azar:=random(100)+1;
    //Si la generación es illuminati
    if(azar=42)then
    begin
        repeat
            write('EL FIN SE ACERCA, DESEAS HACER ALGO????? ');
            readln(s);
            s:=upcase(s);
            if(s<>'N')and(s<>'S')then
            begin
                textcolor(cyan);
                writeln('Introduce una S o una N');
                error(2);
            end;
        until(s='N')or(s='S');
        if(s='N')then
        begin
            repeat//Escoge al azar una célula viva
                i:=random(n)+1;//coordenadas al azar
                j:=random(m)+1;
            until(a[i,j]=1);
            aux:=1;
            //Mata las células de la fila
            while(aux<=m)and(vivas>0)do
            begin
                if(a[i,aux]=1)then
                begin
                    a[i,aux]:=0;
                    muerta:=muerta+1;
                end;
                aux:=aux+1;
            end;
            aux:=1;
            //Mata las células de las columnas
            while(aux<=n)and(vivas>0)do
            begin
                if(a[aux,j]=1)then
                begin
                    a[aux,j]:=0;
                    muerta:=muerta+1;
                end;
                aux:=aux+1;
            end;
            writeln('Oh no :( Hubo una extincion masiva en la fila ',i,' y la columna ',j,' y murieron ',muerta,' celulas :,(');
        end
        else
            writeln('Los salvaste de la destruccion :)');
        delay(5000);
    end;
end;

{<<<--------------------Archivo de salida-------------------->>>}

procedure GeneraSalida(a:matriz;n,m:integer);
//Recibe la matriz y las dimensiones
var
    i,j: Integer;
begin
    rewrite(salida);//Crea o sobreescribe un archivo
    for i := 1 to n do
        begin
            for j := 1 to m do
                begin
                    if (a[i,j]=1) then
                    begin
                        writeln(salida,i,',',j)//Escribe las coordenadas dentro del archivo
                    end;
                end;
        end;
    close(salida);
end;

{<<<--------------------Archivo final de salida (CONFIGURACIÓN FINAL)-------------------->>>}

procedure GeneraSalidaFinal(a:matriz;n,m,gen:integer);
//Recibe la matriz, las dimensiones y la generacíon
var
    i,j: Integer;
begin
    rewrite(salida);//Crea o sobreescribe un archivo
    writeln(salida,'Generación: ',gen);
    writeln(salida,'Dimensiones: ',n,'x',m);
    writeln(salida,'Coordenadas:');
    for i := 1 to n do
        begin
            for j := 1 to m do
                begin
                    if (a[i,j]=1) then
                    begin
                        writeln(salida,i,',',j)//Escribe las coordenadas dentro del archivo
                    end;
                end;
        end;
    close(salida);
end;

{<<<--------------------Suma células al rededor de la celda seleccionada-------------------->>>}

function SumaCelula(a:matriz;i,j,n,m:integer): Integer;
//Recibe al caldo, las coordenadas de la celda, las dimensiones. Devuelve el número de células vivas al rededor de la celda
var
    sumavivas,cont,posj,posi:integer;
begin
    cont:=0;//Fila evaluada
    posi:=i;//Indice de la celda a evaluar
    sumavivas:=0;
    if (i-1=0) then//Si está en la primera fila
        begin
            posi:=i;//Empieza a evaluar en i
            cont:=cont+1;//Empieza a evaluar en la fila siguiente
        end
    else
        posi:=i-1;
    while (cont<3)and(posi<=n) do//Evalua un máximo de 3 filas y hasta que ya no haya siguiene
        begin
            //Si la columna anterior no existe
            if (j-1=0) then
                posj:=j//Empieza a evaluar en j
            else
                posj:=j-1;//Empieza a evaluar en la columna anterior

            while (posj<=j+1)and(posj<=m) do//Evalua hasta la columna j+1 o hasta que no exista siguiente columna
            begin
                if (a[posi,posj]=1) then//Si hay una célula viva
                        sumavivas:=sumavivas+1;
                posj:=posj+1;//Siguiente columna
            end;
            posi:=posi+1;//Siguiente fila
            cont:=cont+1;//Siguiente fila
        end;
    if (a[i,j]=1) then//Si la celda evaluada tiene una célula resta
        sumavivas:=sumavivas-1;
    SumaCelula:=sumavivas;
end;

{<<<--------------------Nueva generación-------------------->>>}

function generacion(a:matriz;n,m:integer):matriz;
var
    nuevagen:matriz;
begin
    for i := 1 to n do
    begin
        for j := 1 to m do
        begin
            //Si la suma de las células es 3 o suman dos pero está la celda viva
            if(SumaCelula(a,i,j,n,m)=3)or((SumaCelula(a,i,j,n,m)=2)and(a[i,j]=1))then
                nuevagen[i,j]:=1//nace
            else
                nuevagen[i,j]:=0;//muere

        end;
    end;
    generacion:=nuevagen;//cambia por el nuevo cultivo
end;

{<<<--------------------Mostrar coordenadas-------------------->>>}

procedure MostrarCoordenadas;//Recorre la información dentro del caldero
var
    x,y: Integer;
begin
    x:=m+6;
    y:=5;
    TextColor(cyan);
    for i := 1 to n do
    begin
        for j := 1 to m do
        begin
            if(celdas[i,j]=1)then
                begin
                    gotoxy(x,y);
                    write('(',i,',',j,')');
                    y:=y+1;
                    if (y>n+15) then
                        begin
                            y:=5;//Vuelve a la línea 5
                            x:=x+7;//Desplaza a la derecha 8 unidades

                        end;
                end;
        end;
    end;
    TextColor(8);
end;

{<<<--------------------Detectar si el caldero está vacío-------------------->>>}

    function CaldoVacio(a:matriz;n,m:integer):boolean;
    var
        i,j:integer;
        vacio:boolean;
    begin
        vacio:=true;//Suponemos que está vacío
        i:=1;
        //Se recorre la matriz hasta encontrar una célula viva o hasta que se acabe el recorrido
        while(i<=n)and(vacio)do
        begin
            j:=1;
            while(j<=m)and(vacio)do
            begin
                if(a[i,j]=1)then//Si se encuentra una viva, ya no está vacío
                    vacio:=false
                else
                    j:=j+1;
            end;
            i:=i+1;
        end;
        CaldoVacio:=vacio;
    end;

{<<<--------------------Opciones de caldo-------------------->>>}

procedure Opciones(var a:matriz;var run,gen:integer;n,m:integer;var activ:boolean);
//Recibe la matriz, las generaciones automáticas por recorrer, la generación, las dimensiones y al activador

    {<<<--------------------Seleccionar una célula del caldero para crear o eliminar-------------------->>>}

    procedure Casilla(var i,j:integer;n,m:integer);
    //Índices y dimensiones

    {--PREGUNTAR POR UNA FILA--}

    begin
        repeat
            TextColor(8);
            gotoxy(1,61);
            delline;
            gotoxy(1,61);
            write('Fila de la celula: ');
            readln(i);
            if (i<=0)or(i>n) then
            begin
                TextColor(cyan);
                write('Error, introduzca una fila valida...');
                delay(2000);
                delline;
            end;    
        until (i>0)and(i<=n);

        {--PREGUNTAR POR UNA COLUMNA--}

        repeat
            TextColor(8);
            gotoxy(1,62);
            delline;
            gotoxy(1,62);
            write('Culumna de la celula: ');
            readln(j);
            if (j<=0)or(j>m) then
            begin
                TextColor(cyan);
                write('Error, introduzca una columna valida...');
                delay(2000);
                delline;
            end;    
        until (j>0)and(j<=m);
    end;
var
    r: char;
    k,i,j:integer;
begin
    repeat
        i:=0;
        j:=0;
        gotoxy(1,50);
        TextColor(8);
        writeln('Que desea hacer?:');
        writeln('Para:');
        writeln('     1) Continuar presione N');
        writeln('     2) Correr generaciones automaticamente (Contando la actual) introduzca I');
        writeln('     3) Ir a una generacion sin mostrar evolucion S');
        writeln('     4) Eliminar una celula seleccione D');
        writeln('     5) Crear una celula seleccione C');
        writeln('     6) Mostrar coordenadas X');
        writeln('     7) Salir E');
        gotoxy(20,50);
        readln(r);
        r:=upcase(r);
        {--Verifica si es un caracter correcto--}
        if (r<>'N') and (r<>'I') and (r<>'S') and (r<>'D')and(r<>'C')and(r<>'E')and(r<>'X') then
           begin
                gotoxy(1,61);
                TextColor(cyan);
                write('Error, introduzca una de las letras indicadas...');
                delay(2000);
                delline;
           end;
    until (r='N') or (r='S') or (r='I') or (r='D')or (r='E')or(r='C')or(r='X');
    case r of
        'N':run:=2;//avanzar a la siguiente generación
        'I'://avanzar n-1 generaciones
        begin
            repeat
                TextColor(8);
                gotoxy(1,61);
                delline;
                gotoxy(1,61);
                write('Numero de generaciones a correr: ');
                readln(run);
                if (run<=0) then
                begin
                    TextColor(cyan);
                    write('Error, introduzca un numero positivo...');
                    delay(2000);
                    delline;
                end;
            until (run>0);
        end;
        'S'://avanzar a la generación específica
        begin
            repeat
                TextColor(8);
                gotoxy(1,61);
                delline;
                gotoxy(1,61);
                write('Numero de generacion: ');
                readln(k);
                if (k<=gen) then
                begin
                    TextColor(cyan);
                    write('Error, introduzca una generacion posterior...');
                    delay(2000);
                    delline;
                end;             
            until (k>gen);
            while (gen<k)and(not CaldoVacio(a,n,m)) do
            begin
                a:=generacion(a,n,m);
                gen:=gen+1;
            end;
            if(CaldoVacio(a,n,m))then
            begin
                textcolor(cyan);
                writeln('Se acabo la diversion en la generacion ',gen,', no quedan celulas vivas :(');
                delay(5000);
                textcolor(8);
            end;
        end;
        'D'://Matar célula :(
        begin
            Casilla(i,j,n,m);//Seleccionar una celda dentro del caldero
            TextColor(cyan);
            if (a[i,j]=1) then//Si está ocupada mátala
                begin
                    a[i,j]:=0;
                    writeln('Mataste una celula :(');
                end
            else
                writeln('Fallaste! Jeje');    
            delay(2000);
            TextColor(8);              
        end;
        'C'://Crear célula
        begin
            Casilla(i,j,n,m);//Seleccionar una celda dentro del caldero
            TextColor(cyan);
            if (a[i,j]=0) then//Si está vacía crea una célula
                begin
                    a[i,j]:=1;
                    writeln('Una celula logro nacer :)');
                end
            else
                writeln('Dos celulas no pueden estar juntas en una celda');    
            delay(2000);
            TextColor(8);   
        end;
        'X'://Muestra las coordenadas
        begin 
            MostrarCoordenadas;
            Readkey;
        end;
        'E':activ:=false;//Salir, deja de mostrar el caldero
    end;
end;

{<<<--------------------Mostrar caldo generado anteriormente-------------------->>>}

procedure MostrarCaldo(var a:matriz;abierto:boolean;var gen,run:integer);
//Recibe la matriz, un booleano que sirve para saber si se abrió la ventana gráfica, el número de generación y las corridas automáticas restantes
var
    x,y: Integer;
    s:string;
    activ:boolean;
begin
        cultivo:=true;
        datos:=true;
        {--ABRIR UNA NUEVA VENTANA--}
        if (not abierto)then//Si no está abierta una ventana gráfica entonces
            begin
                initgraph(driver, modo, '');{Inicia una ventana gráfica}
                setbkcolor(white);//color de fondo blanco
                cleardevice();//limpia la ventana para que quede de color de fondo
                setcolor(7);//color de fuente del texto
                SetTextStyle(1,3,4);//tipo de fuente por defecto, horizontal y tamaño 4
                OutTextXY(getMaxX div 3,10,'JUEGO DE LA VIDA'); //Escribe un texto en una posición dada
            end;
        activ:=true;//Mostrar está activo
        clrscr;//Limpia la pantalla
        writeln(gen);//Escribe al contador de generaciones en consola
        SetTextStyle(2,0,2);
        str(gen,s);
        setfillstyle(solidfill,15);
        bar(10,10,150,50);//Se dibuja un rectángulo blanco por detrás del texto
        OutTextXY(10,10,s);//Escribe al contador de generaciones en ventana

        {--LLAMADA A LOS MILAGROS--}

        Milagro1(a,n,m);
        Milagro2(a,n,m);
        Milagro3(a,n,m);

        {--EXTINCIÓN MASIVA MUAJAJAJJAJA--}

        extincion(a,n,m);

        {--GENERAR ARCHIVO DE SALIDA--}

        GeneraSalida(a,n,m);

        {SEPARACIÓN ENTRE LÍNEAS DE 20}

        x := (getMaxX div 2)-(m div 2)*20; //(Centrado)Comienza en el centro X y resta la mitad de las columnas por su ancho
        y := 60;                           //Comienza en 60 Y
        Enumerado(4,5,m,'v');              //Escribe el enumerado vertical
        Enumerado(2,7,n,'h');              //Escribe el enumerado horizontal

        {--RECORRIDO DEL ARREGLO--}

        for i := 1 to n do
        begin
            for j := 1 to m do
            begin
                setfillstyle(solidfill,8);//Color de relleno gris
                rectangle(x,y,x+20,y+20);//Dibuja un rectángulo hueco
                if (a[i,j]=1) then
                    begin
                        gotoxy(j+3,i+6);
                        write(chr(3));//Dibuja un corazón en consola
                        bar(x+1, y+1, x+19, y+19);//dibuja cuadrado gris rellanado en ventana
                    end
                else
                    begin
                        setfillstyle(solidfill,15);//relleno blanco
                        bar(x+1, y+1, x+19, y+19);//dibuja cuadrado blanco rellanado en ventana
                    end;
                x:=x+20;//Cambio de columna
            end;
            x := (getMaxX div 2)-(m div 2)*20;//Tablero a la mitad
            y:=y+20;//Cambio de fila
        end;
        //Run indica si corre automáticamente
        //Si run<=0 entonces es necesario solicitar al usuario qué hacer
        if(run<=0)then
            Opciones(a,run,gen,n,m,activ)
        else if(not CaldoVacio(a,n,m))then//Sino está vacío el proceso es automático
            begin
                a:=generacion(a,n,m);//siguiente generación
                gen:=gen+1;//Aumenta al contador
            end
        else
            begin
                textcolor(cyan);
                writeln;
                writeln('Se acabo la diversion en la genracion ',gen,', no quedan celulas vivas :(');
                run:=0;
                delay(5000);
                textcolor(8);
            end;
        run:=run-1;//Resta a contador automático
        if (activ) then//Si sigue activa
        begin
            delay(500);
            MostrarCaldo(a,true,gen,run);//Vuelve a mostrar

        end
        else
        begin
            closegraph;//Cierra la ventana gráfica
            GeneraSalidaFinal(a,n,m,gen);
        end;
end;

{<<<--------------------Generar un Caldo-------------------->>>}

procedure GenerarCaldo; 
var celulas,gen:integer;
    begin
        gen:=0;
        celdas:=limpia(celdas,n,m,gen);//limpiamos caldero
        randomize;//Iniciamos la generación de números aleatorios
        celulas := 0;
        while (celulas < vivas) do
            begin
                i := random (n) + 1;//genera un número aleatorio de 1 a n
                j := random (m) + 1;//genera un número aleatorio de 1 a m
                if (celdas[i,j] <> 1) then//Si es 0
                    begin
                        celdas[i,j] := 1;//Celda vive
                        celulas := celulas + 1;//Aumenta el número de células vivas
                    end;
            end;
     end;   

{<<<--------------------Cargar archivo-------------------->>>}


procedure CargarAnchivo(var archi:text;tipo:string); //Recibe un archivo y un estring que será mostrado
    function estaVacio(s:string):boolean;
    var
        i:integer;
        vacio:boolean;
    begin
        i:=1;
        vacio:=true;
        while (i<=length(s))and(vacio)do
        begin
            if(s[i]<>' ')then
            begin
                vacio:=false;
            end;
            i:=i+1;
        end;

        estaVacio:=vacio;
    end;
var
    s: string;
    error:boolean;
begin
    repeat
        TextColor(8);
        clrscr;
        error:=false;
        writeln('Introduzca direccion del archivo y nombre del archivo de '+tipo);
        readln(s);
        Assign(archi,s);//asigna al archivo la dirección dada
        if(tipo='entrada')then
        begin
            {$I-}
            reset(entrada);
            {$I+}
        end;
        //Si es distinto de 0 hubo un error
        if (IOResult<>0)or(s='')or(estaVacio(s)) then
            begin
                TextColor(cyan);
                error:=true;
                writeln('ERROR 404 NOT FOUND :(');
                delay(2000);
            end
    until (not error);
end;

{<<<--------------------Generar un Caldo por Archivo-------------------->>>}

procedure GenerarporArchivo(var a:matriz;var n,m:integer);

    {<<<--------------------Buscar hasta encontrar una coma-------------------->>>}

    procedure BuscarComa(s:string;var posi,posj:integer;n,m,valormin:integer;var error:boolean);
    //Recibe la línea del archivo,las posiciones dentro del caldo, las dimensiones un valor mínimo que deben tener y un indicador de error
    var
        i,x,cod: Integer;
        a:string;
    begin
        {--Agrega a los acumuladores los índices guardados en las coordenadas hasta encontrar una coma--}
        i:=1;//número de caracter en la línea
        a:='';//string acumulador
        while (i<=Length(s))and(s[i]<>',') do //mientras no llegue al fin de línea y no se encuentre la coma
            begin
                a:=a+s[i];//añade al acumulador
                i:=i+1;
            end;
        i:=i+1;//salta la coma
        val(a,x,cod);//convierte el acumulador en número
        if (cod<>0)or(x>n)or(x<valormin)or(i>Length(s)) then//Error: Si no se puede convertir a número, se excede el número máximo de filas o es un número negativo
            begin
                writeln('ERROR, no sirve el archivo :(');
                if(cod<>0)then
                    writeln('Hay elementos que no se pueden convertir a número')
                else if(x>n)or(x<valormin)then
                    writeln('Algun elemento no cumple con las dimensiones')
                else
                    writeln('Faltan comas!');
                error:=true;//Hubo error
            end
        else
            begin
                posi:=x;//Coordenada i=al valor dado
                a:='';//resetea acumulador
                while (i<=Length(s)) do//llega al final de línea
                    begin
                        a:=a+s[i];
                        i:=i+1;
                    end;
                val(a,x,cod);//convierte a número
                if (cod<>0)or(x>m)or(x<valormin)then//Error: Si no se puede convertir a número, se excede el número máximo de columnas o es un número negativo
                    begin
                        writeln('ERROR, no sirve el archivo :(');
                        if(cod<>0)then
                            writeln('Hay elementos que no se pueden convertir a número')
                        else if(x>n)or(x<valormin)then
                            writeln('Algun elemento no cumple con las dimensiones');
                        error:=true;//Hubo error
                    end
                else
                    posj:=x;//Coordenada j
            end;
            
    end;
var
    b:matriz;
    s: string;
    l,vivas,gen:integer;
    error:boolean;
begin
    error:=false;
    reset(entrada);
    l:=1;
    n:=30;
    m:=30;
    i:=1;
    j:=1;
    vivas:=0;
    while (not eof(entrada))and(not error) do
    begin
        readln(entrada,s);
        if (l=1) then
            begin
                BuscarComa(s,n,m,n,m,10,error);//Se alterarán las dimensiones como si fueran posiciones y mínimo deben valer 10
                b:=limpia(b,n,m,gen);//Limpia el caldero
            end
        else
            begin
                BuscarComa(s,i,j,n,m,1,error);//Se alteran las coordenadas las cuales mínimo pueden valer 1
                //Si está vacía la celda
                if (b[i,j]=0) then
                    begin
                        b[i,j]:=1;
                        VIVAS:=VIVAS+1;
                    end;
            end;
        l:=l+1;//Hay una nueva línea
    end;
    //Si hay más celulas vivas que filas y no hay error
    if (vivas>=n)and(not error) then
        begin
            a:=b;//sobreescribe la matriz
            //si no hay datos debes pedir un archivo de salida
            if(not datos)then
                 CargarAnchivo(salida,'salida');
            cultivo:=true;//hay cultivo
            datos:=true;//hay datos
            //Si hay más líneas de las que debería es porque se repitieron
            if(vivas+2<l)then
                writeln('Fueron retiradas unas cuantas celulas repetidas');
            writeln('Archivo leido :)');
        end
    //Si no hay error
    else if (vivas<n)and(not error) then
        writeln('Muy pocas celulas :(')
    else
        writeln('ERROR :(');
    close(entrada);
    Readkey;
end;

{<<<--------------------Menú-------------------->>>}

procedure menu;
    var
        gen,run:integer;
        r:char;
begin
    gen:=1; 
    run:=0;
repeat
    {--Introducir caracter--}
    repeat
        clrscr;
        TextColor(8);    
        {gotoxy(1,40);
        write(DATOS);
        write(' ',CULTIVO); }
        gotoxy(1,1);
        writeln('Que desea hacer?:');
        writeln('Para:');
        writeln('     1) Cargar los datos del programa introduzca D');
        writeln('     2) Visualizar el caldo de cultivo introduzca C');
        writeln('     3) Mostrar las coordenadas introduzca S');
        writeln('     4) Cargar los datos de un archivo introduzca F');
        writeln('     5) Configurar directorio de salida es O');
        writeln('     6) Salir E');
        gotoxy(20,1);
        readln(r);
        r:=upcase(r);
        {--Verifica si es un caracter correcto--}
        if (r<>'D') and (r<>'C') and (r<>'S')and(r<>'F')and(r<>'O')and(r<>'E') then
           begin
                gotoxy(1,10);
                TextColor(cyan);
                write('Error, introduzca una de las letras indicadas...');
                delay(2000);
           end;
    until (r='D') or (r='S') or (r='C')or (r='F')or(r='O')or(r='E');
    {--PEDIR DATOS--}
    if (r='D')and(not datos) then//Si no hay datos, hay que introducirlos
       begin
            clrscr;
            PedirValidar(n,m,vivas);
            CargarAnchivo(salida,'salida');
            Readkey;
       end
    else if(r='D')then//Si ya hay, hay que preguntar si se quieren sobreescribir
        begin
            repeat
                TextColor(cyan);
                gotoxy(1,10);
                write('Ya introdujo anteriormente datos, hacerlo de todos modos? S/N: ');
                readln(r);
                r:=upcase(r);  
                if (r<>'S')and(r<>'N') then
                    begin
                        writeln('Error, por favor introduzca una S o una N');
                        error(10);    
                    end;
                     
            until (r='S')or(r='N');
            if(r='S')then
                begin
                    celdas:=limpia(celdas,n,m,gen);
                    clrscr;
                    PedirValidar(n,m,vivas);
                    Readkey;
                end;
        end
    {--GENERAR CULTIVO--}    
    else if (r='C') and (not datos)and(not cultivo) then//Si no hay datos, no se puede generar cultivo
        begin
            TextColor(cyan);
            gotoxy(1,10);
            write('Error, no tiene datos para mostrar un caldero');
            delay(2000);
        end
    else if(r='C')and(not cultivo)then//Si no hay cultivo, pero hay datos, debes generar uno
        begin
            clrscr;
            cultivo:=true;
            GenerarCaldo;
            MostrarCaldo(celdas,false,gen,run);
        end
    else if(r='C')then//Si hay datos, y hay cultivo, simplemente muestra el cultivo generado con anterioridad
        begin
            clrscr;
            MostrarCaldo(celdas,false,gen,run);
        end
    {--MOSTRAR COORDENADAS--}
    else if (r='S') and (not cultivo) then//Si no se ha generado cultivo, no hay coordenadas que mostrar
        begin
            gotoxy(1,10);
            TextColor(cyan);
            write('Error, no ha generado el cultivo');
            delay(2000);
        end
    else if (r='S') then//Si hay datos, muestra las coordenadas
        begin
            clrscr;
            MostrarCoordenadas;
            Readkey;
        end
    {--ARCHIVOS--}
    else if (r='F') then//Seleccionar archivo de entrada
        begin
            celdas:=limpia(celdas,n,m,gen);
            CargarAnchivo(entrada,'entrada');
            GenerarporArchivo(celdas,n,m);
        end
    else if (r='O') then//Cambiar el destino de la salida
        begin
            CargarAnchivo(salida,'salida');
        end;

until(r='E');
end;

{<<<--------------------Programa principal-------------------->>>}

begin
	{--Cambiamos color de la consola--}

	TextBackground(7);
	TextColor(8);
	clrscr;

    {--Iniciamos variables de verificación de eventos ocurridos en el programa--}

    datos:=false;
    cultivo:=false;

    {--Parámetros de graph--}

    Driver := detect;//detectar el tipo de controlador gráfico
    modo:=0;//pantalla completa

    {--En el menú ocurre la magia--}

    menu;
end.
