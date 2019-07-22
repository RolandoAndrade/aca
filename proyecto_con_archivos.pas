program proyecto_con_archivo;
uses crt;
type
    matriz = array [1..30,1..30] of char;
var
   c,f,celulas,generacion,vivas,m:integer;  { vivas y m son el total de celulas que van a nacer y morir }
   a,b:matriz;
   sigue:boolean;              { sigue es para saber si una matriz se repitio y por lo tanto ya no habra evolucion }
   ARCH1,ARCH2:text;
   s,t,resp1:string;           {s es la tranformacion linea por linea del archivo a string , t es el string donde se guarda la informacion del archivo}

procedure asignacion(var a:matriz; f,c:integer;var celulas:integer; t,resp1:string);  {creacion de la generacion 1 }
          var
             i,j,cont,xn,yn:integer;
             x,y:string;
             esx:boolean;
          begin
               if (resp1 = 'si') then  { Asignacion de celulas aleatoreamente }
               begin
                    cont:=celulas;
                    while (cont >= 1) do
                    begin
                         textcolor(lightgreen);
                         i:=random(f)+1;
                         j:=random(c)+1;
                         if (a[i,j] <> chr(3)) then
                            begin
                                 gotoxy(j,i+5);     //se cambia i por j y viceversa (en todos los gotoxy)
                                 write(chr(3));
                                 a[i,j]:=chr(3);
                                 cont:=cont-1;
                            end;
                    end;
               end
{ --------------- ASIGNACION DE CELULAS CON ARCHIVOS ------------------------}
               else
                   begin
                        x:='';
                        y:='';
                        esx:=true;
                        textcolor(lightgreen);
                        for i:=1 to length(t) do
                            begin
                                 if (t[i] = ' ') then
                                    begin
                                         val(x,xn);             {se deben convertir en numeros los strings}
                                         val(y,yn);
                                         A[xn,yn]:=chr(3);
                                         gotoxy(yn,xn+5);
                                         write(chr(3));
                                         y:='';
                                         x:='';
                                         esx:=true;
                                         celulas:=celulas+1;
                                    end;
                                 if (t[i] <> ',') then
                                    begin
                                         if (esx) then
                                            x:=x+t[i]
                                         else
                                             y:=y+t[i];
                                    end
                                    else if (t[i] = ',') then
                                         esx:=false;
                            end;
                   end;
{ ------------------ ASIGNACION CELULAS MUERTAS -----------------------------}
                    textcolor(lightred);
                    i:=1;
                    j:=1;
                    for cont:=1 to f*c do
                        begin
                              if (a[i,j] <> chr(3)) then
                                         begin
                                              gotoxy(j,i+5);    { se cambia i por j y viceversa }
                                              write(chr(4));
                                              a[i,j]:=chr(4);
                                         end;
                             if (j = c) then
                                begin
                                     i:=i+1;
                                     j:=1;
                                end
                             else
                              j:=j+1;
                       end;
               textcolor(15);
               gotoxy(c+5,f div 2 +2);
               write('Generacion 1');
               gotoxy(c+5,f div 2 +4);
               write('Celulas vivas: ');
               textcolor(lightgreen);
               write('VERDE');
               textcolor(15);
               gotoxy(c+5,f div 2 +6);
               write('Celulas muertas: ');
               textcolor(lightred);
               write('ROJO');
          end;

{ ----------------------------- BUSQUEDA DE ARCHIVO --------------------------}
procedure archivos(var s,t:string; var vivas:integer; var ARCH1,ARCH2:text);
     begin
          //repeat
          write('Introduzca la ruta y nombre del archivo de entrada: ');
          readln(s);
          assign (ARCH1, s);
          GOTOXY(1,3);
          delline;
          gotoxy(1,3);
          write('Introduzca la ruta y nombre del archivo de salida: ');
          readln(s);
          assign (ARCH2, s);
          GOTOXY(1,3);
          delline;
          gotoxy(1,3);
          {$I-}
          reset(ARCH1);
          {$I+}
             {if (IOResult = 2) then
                write('Error... File not found')
             else if (IOResult = 3) then
                write('Error... Path not found')
             else if (IOResult = 4) then
                write('Error... Too many open files')               ACA HAY Q REVISAR CONDICIONES Y FUNCIONALIDAD ESTA INCOMPLETO
             else if (IOResult = 5) then
                write('Error... Access denied')
             else if (IOResult = 6) then
                write('Error... Invalid file handle')}
             //until   (IOResult = 0);
         //begin
          rewrite(ARCH2);
          t:='';
          while (not eof(ARCH1)) do
                begin
                     readln(ARCH1,s);
                     writeln(ARCH2,s);
                     t:=t+s+' ';
                     vivas:=vivas+1;
                end;
          close(ARCH1);
          close(ARCH2);
          write('Celulas vivas dadas por archivo tipo .TXT: ',vivas);
         //end;
     end;

 {--------------------- CREACION DE LAS GENERACIONES NUEVAS -----------------}
procedure cm(var a,b:matriz; f,c:integer; var vivas,m,celulas:integer; var generacion:integer;var sigue:boolean);

{--------------------------- MILAGRO 1 -------------------------------------}
          procedure recorrido1(var B:matriz; f,c:integer);
          var
             x,y,cont:integer;
             limite1,limite2,limite3,limite4:integer;
             coordx,coordy:integer;
             espaciosl,espaciost:integer;
             derecha,abajo,izquierda,arriba,consiguio:boolean;
          begin
               derecha:=true;
               abajo:=false;
               izquierda:=false;
               arriba:=false;
               consiguio:=false;
               x:=1;
               y:=1;
               limite1:=c;
               limite2:=f;
               limite3:=1;
               limite4:=2;
               espaciosl:=0;
               espaciost:=0;
               for cont:=1 to f*c do
                   begin
                        if (B[x,y] <> chr(3)) and (not consiguio) then
                           begin
                                coordx:=x;
                                coordy:=y;
                                consiguio:=true;
                           end;
                        if (x mod 2 <> 0) and (y mod 2 <> 0) then
                           begin
                                if (B[x,y] <> chr(3)) then
                                   begin
                                        espaciosl:=espaciosl+1;
                                        espaciost:=espaciost+1;
                                   end
                                else
                                    espaciost:=espaciost+1;
                           end;
                        if (derecha) then
                           begin
                                           if (y = limite1) then
                                              begin
                                                   derecha:=false;
                                                   abajo:=true;
                                                   x:=x+1;
                                                   limite1:=limite1-1;
                                              end
                                           else
                                                    y:=y+1;
                           end
                        else if (abajo) then
                             begin
                                             if (x = limite2) then
                                                begin
                                                     abajo:=false;
                                                     izquierda:=true;
                                                     y:=y-1;
                                                     limite2:=limite2-1;
                                                end
                                             else
                                                      x:=x+1;
                             end
                        else if (izquierda) then
                             begin
                                             if (y = limite3) then
                                                begin
                                                     izquierda:=false;
                                                     arriba:=true;
                                                     x:=x-1;
                                                     limite3:=limite3+1;
                                                end
                                             else
                                                      y:=y-1
                             end
                         else if (arriba) then
                              begin
                                              if (x = limite4) then
                                                 begin
                                                      arriba:=false;
                                                      derecha:=true;
                                                      y:=y+1;
                                                      limite4:=limite4+1;
                                                 end
                                              else
                                                       x:=x-1;
                              end;
                   end;
                   if (espaciosl >= ((50*espaciost) div 100)) then
                  begin
                       textcolor(yellow);
                       B[coordx,coordy]:=chr(3);
                       gotoxy(coordy,coordx+f+8);
                       write(chr(3));
                       textcolor(green);
                       //gotoxy(50,50);
                       //write(coordx,' ',coordy);
                  end;
          end;

{--------------------------- MILAGRO 2 --------------------------------------}
          procedure recorrido2(var B:matriz; f,c:integer);
          var
             i,j,cont,aux,espaciol,espaciot,coordi,coordj:integer;
          begin
               aux:=c;
               espaciol:=0;
               espaciot:=0;
               for cont:=1 to c do
                   begin
                        i:=f;
                        for j:=aux to c do
                        begin
                             if (B[i,j] <> chr(3)) then
                                        begin
                                             coordi:=i;
                                             coordj:=j;
                                        end;
                                     if (i mod 2 = 0) then
                                        begin
                                             if (B[i,j] <> chr(3)) then
                                                begin
                                                     espaciol:=espaciol+1;
                                                     espaciot:=espaciot+1;
                                                end
                                             else
                                                 espaciot:=espaciot+1;
                                        end;
                             if (j=c) then
                                aux:=aux-1
                             else
                                 i:=i-1;
                        end;
                   end;
               aux:=f-1;
               for cont:=2 to f do
                   begin
                        j:=1;
                        for i:=aux downto 1  do
                        begin
                             if (B[i,j] <> chr(3)) then
                                        begin
                                             coordi:=i;
                                             coordj:=j;
                                        end;
                                     if (i mod 2 = 0) then
                                        begin
                                             if (B[i,j] <> chr(3)) then
                                                begin
                                                     espaciol:=espaciol+1;
                                                     espaciot:=espaciot+1;
                                                end
                                             else
                                                 espaciot:=espaciot+1;
                                        end;
                             if (i=1) then
                                     aux:=aux-1
                             else
                                      j:=j+1;
                        end;
                   end;
               if (espaciol >= ((70*espaciot) div 100)) then
                  begin
                       textcolor(yellow);
                       B[coordi,coordj]:=chr(3);
                       gotoxy(coordj,coordi+f+8);
                       write(chr(3));
                       textcolor(green);
                       gotoxy(50,50);
                       write(coordi,' ',coordj);
                  end;
        end;

{-------------------- MILAGRO 3 -----------------------------------------------}
          procedure recorrido3(a:matriz; var B:matriz; f,c:integer; var iguales:integer);
          var
             i,j,cont,espaciosl,espaciost,coordi,coordj:integer;
             sube,consiguio:boolean;
          begin
               sube:=true;
               consiguio:=false;
               i:=f;
               j:=1;
               espaciosl:=0;
               espaciost:=0;
               for cont:=1 to f*c do
                   begin
                        if (cont > ((f*c) div 2)) and (not consiguio) then
                           begin
                                if (B[i,j] <> chr(3)) then
                                   begin
                                        coordi:=i;
                                        coordj:=j;
                                        consiguio:=true;
                                   end;
                           end;
                        if (j mod 2 <> 0) then
                           begin
                                if (B[i,j] <> chr(3)) then
                                   begin
                                        espaciosl:=espaciosl+1;
                                        espaciost:=espaciost+1;
                                   end
                                else
                                    espaciost:=espaciost+1;
                           end;
                        if (sube) then
                           begin
                                if (i=1) then
                                   begin
                                        sube:=false;
                                        j:=j+1;
                                   end
                                 else
                                          i:=i-1;
                           end
                        else
                            begin
                                 if (i=f) then
                                    begin
                                         sube:=true;
                                         j:=j+1;
                                    end
                                 else
                                         i:=i+1;
                            end;
                   end;
                   if (espaciosl = ((60*espaciost) div 100)) then
                  begin
                       textcolor(yellow);
                       B[coordi,coordj]:=chr(3);
                       gotoxy(coordj,coordi+f+8);
                       write(chr(3));
                       textcolor(lightgreen);
                       gotoxy(50,50);
                       write(coordi,' ',coordj);
                       celulas:=celulas+1;
                  end;
                  if (B[coordi,coordj] <> A[coordi,coordj]) then
                     iguales:=iguales-1;
          end;
          var
             i,j,v,iguales:integer;
          begin
          sigue:=true;
          iguales:=0;
             for i:=1 to f do
                 begin
                      for j:=1 to c do
                          begin
                               v:=0;
                                       if (a[i-1,j-1]=chr(3)) and (i-1>0) and (j-1>0) then
                                          v:=v+1;
                                       if (a[i,j-1]=chr(3)) and (j-1>0) then
                                          v:=v+1;
                                       if (a[i+1,j-1]=chr(3)) and (j-1>0) and (i+1<=f) then
                                          v:=v+1;
                                       if (a[i-1,j]=chr(3))  and (i-1>0) then
                                          v:=v+1;
                                       if (a[i+1,j]=chr(3)) and (i+1<=f) then
                                          v:=v+1;
                                       if (a[i-1,j+1]=chr(3)) and (i-1>0) and (j+1<=c) then
                                          v:=v+1;
                                       if (a[i,j+1]=chr(3)) and (j+1<=c) then
                                          v:=v+1;
                                       if (a[i+1,j+1]=chr(3))and (i+1<=f) and (j+1<=c) then
                                          v:=v+1;
                                      if (a[i,j]<>chr(3)) then
                                      begin
                                       if (v=3) then
                                          begin
                                               b[i,j]:=chr(3);
                                               gotoxy(j,i+f+8);
                                               write(chr(3));
                                               vivas:=vivas+1;
                                               celulas:=celulas+1;

                                          end
                                          else
                                              begin
                                                   textcolor(lightred);
                                                   b[i,j]:=chr(4);
                                                   gotoxy(j,i+f+8);
                                                   write(chr(4));
                                                   textcolor(lightgreen);
                                              end;
                                      end
                              else if (a[i,j]=chr(3)) then
                                  begin
                                       if (v<=1) then
                                          begin
                                               textcolor(lightred);
                                               b[i,j]:=chr(4);
                                               gotoxy(j,i+f+8);
                                               write(chr(4));
                                               textcolor(lightgreen);
                                               m:=m+1;
                                               celulas:=celulas-1;
                                          end
                                       else if (v>=4) then
                                          begin
                                               textcolor(lightred);
                                               b[i,j]:=chr(4);
                                               gotoxy(j,i+f+8);
                                               write(chr(4));
                                               textcolor(lightgreen);
                                               m:=m+1;
                                               celulas:=celulas-1;
                                          end
                                       else if (v>1) and (v<4) then
                                          begin
                                               b[i,j]:=chr(3);
                                               gotoxy(j,i+f+8);
                                               write(chr(3));
                                          end;
                                  end;
                               if (A[i,j]=B[i,j]) then
                                  iguales:=iguales+1;
                          end;
                 end;
               //recorrido1(b,f,c);
               //recorrido2(b,f,c);
               //recorrido3(a,b,f,c,iguales);
               if (iguales = f*c) then
                  sigue:=false;
               a:=b;
               generacion:=generacion+1;
               gotoxy(c+5,f+9);
               textcolor(15);
               write('Generacion ',generacion);
               textcolor(lightgreen);
         end;

{ --------------- PROGRAMA PRINCIPAL ----------------------------------------}
begin
     randomize;
 { ------------------ ADORNOS -----------------------------------------------}
    { textcolor(15);
     gotoxy(100,6);
     write('UNIVERSIDAD CATOLICA ANDRES BELLO');
     gotoxy(100,7);
     write('FACULTAD DE INGENIERIA');
     gotoxy(100,8);
     write('ESCUELA DE INGENIERIA INFORMATICA');
     textcolor(11);
     gotoxy(65,6);
     write('ACA');
     gotoxy(56,8);
     write('AUTOMATA CELULAR ALIVE');  }
 {------------------------ INICIO DEL PROGRAMA COMO TAL ----------------------}
     vivas:=0;
     m:=0;
     textcolor(15);
     gotoxy(1,1);
     write('Cuantas filas desea: ');
     readln(f);
     write('Cuantas columnas desea: ');
     readln(c);
     write('Desea que el programa asigne aleatoreamente las celulas en el caldero?: ');
     readln(resp1);
     gotoxy(1,3);
     delline;
     gotoxy(1,3);
     if (resp1 = 'si') then
     begin
          write('Cuantas celulas vivas desea: ');
          readln(celulas);
     end
{ ------------------------ ARCHIVOS -------------------------------------------}
     else
     begin
          archivos(s,t,vivas,ARCH1,ARCH2);
     end;
 {---- todo esto se puede ver mejor si se lleva a un procedure ( el menu del anteproyecto) -------}
     asignacion(a,f,c,celulas,t,resp1);
     gotoxy(1,f+7);
     textcolor(yellow);
     write('Presione enter para que se de la evolucion');
     readln;
     gotoxy(1,f+7);
     delline;
     generacion:=1;
     //gotoxy(1,c+40);
     gotoxy(1,f+7);
     write('Presione una tecla para detener el proceso.');
     textcolor(white);
     sigue:=true;
     repeat
     textcolor(lightgreen);
     cm(a,b,f,c,vivas,m,celulas,generacion,sigue);
     delay(100);
     until (keypressed) or (not sigue);
     textcolor(15);
     gotoxy(c+5,f+11);
     write('Total de celulas que han nacido al cabo de ',generacion,' generaciones: ');
     textcolor(lightgreen);
     write(vivas);
     textcolor(15);
     write('  <-- No estan incluidas celulas dadas por milagros.');
     gotoxy(c+5,f+12);
     write('Total de celulas que han muerto al cabo de ',generacion,' generaciones: ');
     textcolor(lightred);
     write(m);
     textcolor(15);
     gotoxy(c+5,f+13);
     write('Total de celulas restantes en el caldero al cabo de ',generacion,' generaciones: ');
     textcolor(yellow);
     write(celulas);
     textcolor(15);
     if (not sigue) then
       begin
        gotoxy(1,f*2+10);
        writeln('El ciclo se detuvo debido a que ya no habran cambios entre generaciones...');
        writeln;
        writeln('Generacion donde ocurrio ultimo cambio --> De generacion: ',generacion-2);
        gotoxy(44,f*2+13);
        write('A generacion: ',generacion-1);
       end;
     readln;
     readln;
end.
