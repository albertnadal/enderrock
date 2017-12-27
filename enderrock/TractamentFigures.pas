unit TractamentFigures;

interface

uses Windows, ExtCtrls, Classes, SysUtils, GR32_Image, GR32, GR32_Layers;

type

          TMapa = class;
          TCella = class;
          TPartFigura = class;
          TFigura = class;
          TCatalegFigures = class;
          TProces = class;
          TLlistaProcessos = class;
          TControlTeclat = class;
          TDestructometre = class;

{ ********************************************************************* }
{ ********************************* TCella **************************** }
          TDadesFigura = RECORD
                  forma : array[0..20] of Char;
                  ordre : array[0..20] of Integer;
                  fitxer: array[0..20] of Char;
                  massa: integer;
          end;

          TCella = class(TObject)
          private
                  nord: TCella;
                  nord_est: TCella;      //                 nord
                  est: TCella;           //        nord_oest  |  nord_est
                  sud_est: TCella;       //                  \|/
                  sud: TCella;           //         oest  --- 0 ---  est
                  sud_oest: TCella;      //                  /|\
                  oest: TCella;          //         sud_oest  |  sud_est
                  nord_oest: TCella;     //                  sud
                  figura: TFigura;
                  part: TPartFigura;
                  constructor Create;
          public
                  procedure AssignarPartFigura(p: TPartFigura);
                  procedure AssignarFigura(f: TFigura);
          end;
{ ********************************************************************* }
{ ******************************** TMapa ****************************** }
          TMapa = class(TObject)
          private
                  amplada: Integer;
                  fondaria: Integer;
                  matriu: array of array of TCella;
                  procedure InicialitzarCelles;
          public
                  constructor Create;
                  procedure CarregarMapa(fitxer: string; cataleg: TCatalegFigures; control:TControlTeclat; out mesura: TDestructometre; out i: integer);
                  procedure ObtenirTamanyMapa(out a, f: integer);
                  procedure MapejarFigura(figura: TFigura; x,y:integer);
          end;

  { ********************************************************************* }
{ **************************** TCatalegFigures ************************ }
          TCatalegFigures = class(TObject)
          private
                 imatge: TImgView32;
                 LlistaProcessos: TLlistaProcessos;
          public
                 constructor create(img: TImgView32; llista: TLlistaProcessos);
                 procedure CarregarDadesFigura(out d:TDadesFigura; fitxer: string);
                 function CrearFigura(nom: String; massa: integer): TFigura;
          end;

{ ********************************************************************* }
{ ****************************** TPartFigura ************************** }
          TPartFigura = class(TObject)
          private
                Fig: TFigura;
                Cella: TCella;
                CapaGrafica: TBitmapLayer;
                fitxer: string;
                x,y:integer;
          public
                constructor create(imatge: TImgView32; f: string; figura: TFigura);virtual;
                procedure ActivarSeleccio;
                procedure DesactivarSeleccio;
                procedure ObtenirSubjecte(out part: TPartFigura; out figura: TFigura; out stop: boolean);virtual;
                procedure ObtenirSuport(out part: TPartFigura; out figura: TFigura; out stop: boolean);
                procedure ObtenirSuportEsquerra(out part: TPartFigura; out figura: TFigura; out stop: boolean);
                procedure ObtenirSuportDret(out part: TPartFigura; out figura: TFigura; out stop: boolean);
                procedure AssignarPosicio(aux_x, aux_y: integer);
                procedure AssignarCella(c: TCella);
                procedure Caure;virtual;
                procedure CaureDreta;virtual;
                procedure CaureEsquerra;virtual;
                procedure Pintar;
                procedure Trencar(f: TFigura);
                destructor destroy;
          end;

{ ********************************************************************* }
{ ******************************* TFigura ***************************** }
          TFigura = class(TObject) //Classe abstracta
          private
                  EstaCaient:Boolean;
                  EstaTrencant:Boolean;
                  EnMoviment:Boolean;
                  Massa: Integer;
                  Parts: array of TPartFigura;
                  Ordre: array of Integer;
                  Forma: String;
                  Fitxer: String;
                  Cataleg: TCatalegFigures;
                  ImatgeSuport: TImgView32;
                  LlistaProcessos: TLlistaProcessos;
                  Mesurador: TDestructometre;
          public
                  constructor create(dades: TDadesFigura; imatge: TImgView32; llista: TLlistaProcessos; cat: TCatalegFigures; m:integer);
                  procedure Trencar; virtual;
                  procedure IniciarCaiguda; virtual;
                  procedure IniciarTrencar; virtual;
                  procedure Caure(out stop: boolean); virtual;
                  procedure NotificarImpacte; virtual;
                  procedure DesactivarSeleccio; virtual;
                  procedure ActivarSeleccio; virtual;
                  procedure AssignarDestructometre(m: TDestructometre);                                    
                  function ObtenirMassaTotalSoportadaRepartida: integer; virtual;
                  function ObtenirNumeroSuports: integer; virtual;                  
                  function ObtenirMassaTotalSoportada: integer; virtual;
                  function ObtenirForma: string; virtual;
                  function ObtenirPartFigura(n :integer): TPartFigura; virtual;
          end;

{ ********************************************************************* }
{ **************************** TTerra ********************************* }
          TTerra = class(TFigura)
          public
                  procedure IniciarTrencar;override;
                  procedure NotificarImpacte; override;
          end;

{ ********************************************************************* }
{ ***************************** TRuna ********************************* }
          TRuna = class(TFigura)
          public
                  procedure IniciarTrencar;override;
                  procedure Caure(out stop: boolean);override;
          end;

{ ********************************************************************* }
{ ************************* TLlistaProcessos*************************** }
          TLlistaProcessos = class(TObject)
          private
                primer: TProces;
          public
                constructor create;
                procedure ExecutarProcessos(out NoProcessos: boolean);
                procedure InserirProces(p: TProces);
          end;

{ ********************************************************************* }
{ ****************************** TProces******************************* }
          TProces = class(TObject)
          private
                figura: TFigura;
          public
                seguent: TProces;
                anterior: TProces;
                constructor create(f: TFigura); virtual;
                procedure Executar; virtual; abstract;
                procedure Acabar; virtual;
          end;

{ ********************************************************************* }
{ ******************* TProcesDestruccioFigura************************** }
          TProcesDestruccioFigura = class(TProces)
          private
                procedure Executar; override;
          end;

{ ********************************************************************* }
{ ******************* TProcesTrencamentFigura ************************* }
          TProcesTrencamentFigura = class(TProces)
          public
                procedure Executar; override;
          end;

{ ********************************************************************* }
{ ******************** TProcesCaigudaFigura *********************** }
          TProcesCaigudaFigura = class(TProces)
          public
                procedure Executar; override;
          end;

{ ********************************************************************* }
{ **************************** TControlTeclat ************************* }
          TControlTeclat = class(TObject)
          private
                cella: TCella;
                anterior: TFigura;
                CapaGrafica: TBitmapLayer;
                imatge: TImgView32;
                x,y: Integer;
          public
                constructor create(i: TImgView32);
                procedure AssignarCella(c: TCella);
                procedure TrencarFigura;
                procedure Amunt;
                procedure Aball;
                procedure Esquerra;
                procedure Dreta;
                procedure Pintar;
          end;

{ ********************************************************************* }
{ *************************** TDestructometre ************************* }
          TDestructometre = class(TObject)
          public
                Max, Min, Total, Actual: Integer;
                inf, sup, gran, petit: TShape;
                constructor create(g, p, i , s: TShape);
                function NivellSuperat: Boolean;
                function NivellFallit: Boolean;
                procedure NotificarFiguraTrencada;
                procedure Pintar;
                procedure Restaurar;
          end;

{ ******************************************************* }
{ ******************** IMPLEMENTACIÓ ******************** }
{ ******************************************************* }
implementation

constructor TDestructometre.create(g,p,i,s:TShape);
begin
        Max:=0;
        Min:=0;
        Total:=0;
        Actual:=0;
        Gran:=g;
        Petit:=p;
        inf:=i;
        sup:=s;
end;

function TDestructometre.NivellSuperat: Boolean;
begin
        NivellSuperat:= ((Actual>=Min)and(Actual<=Max));
end;

function TDestructometre.NivellFallit: Boolean;
begin
        NivellFallit:= (Actual>Max);
end;

procedure TDestructometre.Restaurar;
begin
        Actual:=0;
        Pintar;
end;

procedure TDestructometre.NotificarFiguraTrencada;
begin
        inc(Actual);
        Pintar;
end;

procedure TDestructometre.Pintar;
begin
        if ((Max >= Actual)and(Actual >= Min)) then Petit.Brush.Color:=$0080FF80   //Verd
        else Petit.Brush.Color:=$008080FF;   //Vermell
        sup.Visible:= not(Max=Total);
        inf.Visible:= not(Min=Total);

        if Total<>0 then
        begin
                Petit.Width:=(Gran.Width * Actual) div Total;
                inf.left:=(Gran.Width * Min) div Total;
                sup.left:=(Gran.Width * Max) div Total;
        end
        else
        begin
                Petit.Width:=0;
                inf.left:=0;
                sup.left:=0;
        end;
end;

constructor TControlTeclat.create(i: TimgView32);
begin
        imatge:=i;
        CapaGrafica:= TBitmapLayer.create(imatge.Layers);
        with CapaGrafica do
        begin

                Bitmap.LoadFromFile('cursor.bmp');
                x:= CapaGrafica.Bitmap.width;
                y:= CapaGrafica.Bitmap.height;
                CapaGrafica.Location := FloatRect(x,y, x+CapaGrafica.Bitmap.width, y+CapaGrafica.Bitmap.height);
                Bitmap.DrawMode := dmOpaque;
                Scaled := True;
                Pintar;
        end;
end;

procedure TControlTeclat.TrencarFigura;
begin
        if anterior<>nil then anterior.DesactivarSeleccio;
        if Cella.figura<>nil then Cella.figura.IniciarTrencar;
        anterior:=nil;
end;

procedure TControlTeclat.Amunt;
begin
        If Cella.nord.nord<>nil then
        begin
                Cella:=Cella.nord;
                dec(y,CapaGrafica.Bitmap.height);
                CapaGrafica.Location := FloatRect(x,y, x+CapaGrafica.Bitmap.width, y+CapaGrafica.Bitmap.height);
                if anterior<>nil then anterior.DesactivarSeleccio;
                anterior:=Cella.figura;
                if Cella.figura<>nil then Cella.figura.ActivarSeleccio;
                Pintar;
        end;
end;
procedure TControlTeclat.Aball;
begin
        If Cella.sud.sud<>nil then
        begin
                Cella:=Cella.sud;
                inc(y,CapaGrafica.Bitmap.height);
                CapaGrafica.Location := FloatRect(x,y, x+CapaGrafica.Bitmap.width, y+CapaGrafica.Bitmap.height);
                if anterior<>nil then anterior.DesactivarSeleccio;
                anterior:=Cella.figura;
                if Cella.figura<>nil then Cella.figura.ActivarSeleccio;
                Pintar;
        end;
end;
procedure TControlTeclat.Esquerra;
begin
        If Cella.oest.oest<>nil then
        begin
                Cella:=Cella.oest;
                dec(x,CapaGrafica.Bitmap.width);
                CapaGrafica.Location := FloatRect(x,y, x+CapaGrafica.Bitmap.width, y+CapaGrafica.Bitmap.height);
                if anterior<>nil then anterior.DesactivarSeleccio;
                anterior:=Cella.figura;
                if Cella.figura<>nil then Cella.figura.ActivarSeleccio;
                Pintar;
        end;
end;
procedure TControlTeclat.dreta;
begin
        If Cella.est.est<>nil then
        begin
                Cella:=Cella.est;
                inc(x,CapaGrafica.Bitmap.width);
                CapaGrafica.Location := FloatRect(x,y, x+CapaGrafica.Bitmap.width, y+CapaGrafica.Bitmap.height);
                if anterior<>nil then anterior.DesactivarSeleccio;
                anterior:=Cella.figura;
                if Cella.figura<>nil then Cella.figura.ActivarSeleccio;
                Pintar;
        end;
end;

procedure TControlTeclat.Pintar; begin CapaGrafica.Bitmap.Changed; end;
procedure TControlTeclat.AssignarCella(c: TCella); begin cella:=c; end;

procedure TRuna.IniciarTrencar;begin end;
procedure TTerra.IniciarTrencar;begin end;
procedure TTerra.NotificarImpacte;begin end;

procedure TProces.Acabar;
begin
        anterior.seguent:=seguent;
        seguent.anterior:=anterior;
        self.destroy;
end;

procedure TProcesDestruccioFigura.Executar;
begin
        figura.destroy;
        self.acabar;
end;

procedure TProcesTrencamentFigura.Executar;
begin
        figura.trencar;
        self.Acabar;
end;

constructor TProces.create(f: TFigura); begin figura:=f; end;

procedure TProcesCaigudaFigura.Executar;
var stop: boolean;
begin
        figura.caure(stop);
        if stop then self.Acabar;
end;

constructor TLlistaProcessos.create;
begin
        primer:= TProces.create(nil);
        primer.seguent:= primer;
        primer.anterior:= primer;
end;

procedure TLlistaProcessos.InserirProces(p: TProces);
begin
        primer.seguent.anterior:=p;
        p.anterior:=primer;
        p.seguent:=primer.seguent;
        primer.seguent:=p;
end;

procedure TLlistaProcessos.ExecutarProcessos(out NoProcessos: boolean);
var aux,p: TProces;
begin
        p:=primer.seguent;
        if p=primer then NoProcessos:=true
        else
        begin
                NoProcessos:=false;
                while p<>primer do
                begin
                        aux:=p.seguent;
                        p.Executar;
                        p:=aux;
                end;
        end;
end;

procedure TCella.AssignarFigura(f: TFigura);begin figura:=f; end;
procedure TCella.AssignarPartFigura(p: TPartFigura); begin part:= p; end;
destructor TPartFigura.Destroy;
begin
        self.CapaGrafica.destroy;
end;

procedure TPartFigura.ActivarSeleccio;
begin
        CapaGrafica.Bitmap.DrawMode:=dmBlend;
        CapaGrafica.Bitmap.MasterAlpha:=$60;
        Pintar;
end;

procedure TPartFigura.DesactivarSeleccio;
begin
        CapaGrafica.Bitmap.DrawMode:=dmOpaque;
        Pintar;
end;

procedure TPartFigura.Trencar(f: TFigura);
var p: TPartFigura;
begin
        p:= f.ObtenirPartFigura(0);
        p.AssignarCella(Cella);
        Cella.AssignarFigura(f);
        Cella.AssignarPartFigura(p);
        p.AssignarPosicio(x,y);
        p.Pintar;
        self.destroy;
end;

procedure TPartFigura.ObtenirSuportEsquerra(out part: TPartFigura; out figura: TFigura; out stop: boolean);
begin
        part:= Cella.sud_oest.part;
        figura:= Cella.sud_oest.figura;
        if part <> nil  then stop:=true
        else stop:=false;
end;

procedure TPartFigura.ObtenirSuportDret(out part: TPartFigura; out figura: TFigura; out stop: boolean);
begin
        part:= Cella.sud_est.part;
        figura:= Cella.sud_est.figura;
        if part <> nil  then stop:=true
        else stop:=false;
end;

procedure TPartFigura.ObtenirSubjecte(out part: TPartFigura; out figura: TFigura; out stop: boolean);
begin
        part:= Cella.nord.part;
        figura:= Cella.nord.figura;
        if part <> nil  then stop:=true
        else stop:=false;
end;

procedure TPartFigura.ObtenirSuport(out part: TPartFigura; out figura: TFigura; out stop: boolean);
begin
        part:= Cella.sud.part;
        if part <> nil  then
        begin
                stop:=true;
                figura:= Cella.sud.figura;
        end
        else stop:=false;
end;

procedure TPartFigura.AssignarCella(c: TCella); begin Cella:=c; end;

procedure TPartFigura.Caure;
begin
        if ((Cella.nord.figura<>nil) and (Cella.nord.figura<>Fig) and (not Cella.nord.figura.EstaCaient)) then
        begin
                Cella.nord.figura.IniciarCaiguda;
        end;
        Cella.figura:= nil;
        Cella.part:=nil;
        Cella.sud.figura:=Fig;
        Cella.sud.part:=self;
        AssignarCella(Cella.sud);
        AssignarPosicio(x, y+1);
        Pintar;
end;

procedure TPartFigura.CaureDreta;
begin
        if ((Cella.nord.figura<>nil) and (Cella.nord.figura<>Fig) and (not Cella.nord.figura.EstaCaient)) then
        begin
                Cella.nord.figura.IniciarCaiguda;
        end;
        Cella.figura:= nil;
        Cella.part:=nil;
        Cella.sud_est.figura:=Fig;
        Cella.sud_est.part:=self;
        AssignarCella(Cella.sud_est);
        AssignarPosicio(x+1, y+1);
        Pintar;
end;

procedure TPartFigura.CaureEsquerra;
begin
        if ((Cella.nord.figura<>nil) and (Cella.nord.figura<>Fig) and (not Cella.nord.figura.EstaCaient)) then
        begin
                Cella.nord.figura.IniciarCaiguda;
        end;
        Cella.figura:= nil;
        Cella.part:=nil;
        Cella.sud_oest.figura:=Fig;
        Cella.sud_oest.part:=self;
        AssignarCella(Cella.sud_oest);
        AssignarPosicio(x-1, y+1);
        Pintar;
end;

procedure TPartFigura.Pintar; begin CapaGrafica.Bitmap.Changed; end;

procedure TPartFigura.AssignarPosicio(aux_x, aux_y: integer);
var aux_x2, aux_y2: integer;
begin
        x:= aux_x; y:= aux_y;
        aux_x2:= aux_x * CapaGrafica.Bitmap.width;
        aux_y2:= aux_y * CapaGrafica.Bitmap.Height;
        CapaGrafica.Scaled := True;
        CapaGrafica.Location := FloatRect(aux_x2,aux_y2, aux_x2 + CapaGrafica.Bitmap.width, aux_y2 + CapaGrafica.Bitmap.height);
end;

constructor TPartFigura.create(imatge: TImgView32; f:string; figura: TFigura);
begin
        fig:=figura;
        Fitxer:= f;
        CapaGrafica := TBitmapLayer.Create(imatge.Layers);
        with CapaGrafica do
        begin
                Bitmap.LoadFromFile(Fitxer);
                Bitmap.DrawMode := dmOpaque;
                Scaled := True;
        end;
end;

constructor TFigura.create(dades: TDadesFigura; imatge: TImgView32; llista: TLlistaProcessos; cat: TCatalegFigures;m:integer);
var i:integer;
begin
        LlistaProcessos:=llista;
        if m=0 then Massa:=dades.massa
        else Massa:=m;
        ImatgeSuport:=imatge;
        fitxer:=dades.fitxer;
        Forma:=dades.forma;
        Cataleg:=cat;
        SetLength(Parts, Length(Forma));
        SetLength(Ordre, Length(Forma));
        EstaCaient:=false;
        EstaTrencant:=false;
        EnMoviment:=false;
        for i:=0 to Length(Forma)-1 do Ordre[i]:= dades.ordre[i];
        for i:=0 to Length(Forma)-1 do Parts[i]:= TPartFigura.Create(ImatgeSuport, fitxer, self);
end;

procedure TFigura.DesactivarSeleccio;
var e:integer;
begin
        for e:=0 to length(forma)-1 do parts[e].DesactivarSeleccio;
end;

procedure TFigura.ActivarSeleccio;
var e:integer;
begin
        for e:=0 to length(forma)-1 do parts[e].ActivarSeleccio;
end;

procedure TFigura.IniciarTrencar;
var p: TProcesTrencamentFigura;
begin
        if not EstaTrencant then
        begin
                EstaTrencant:=true;
                p:= TProcesTrencamentFigura.create(self);
                LlistaProcessos.InserirProces(p);
        end;
end;

procedure TFigura.Trencar;
var l:Integer;
    p:TProces;
    f:TFigura;
begin
        Mesurador.NotificarFiguraTrencada;
        for l:= 0 to Length(forma)-1 do
        begin
                f:= Cataleg.CrearFigura('RUNA', Massa div Length(forma) );
                Parts[l].Trencar(f);
                p:= TProcesCaigudaFigura.create(f);
                LlistaProcessos.InserirProces(p);
        end;
                p:= TProcesDestruccioFigura.create(self);
                LlistaProcessos.InserirProces(p);
end;

procedure TFigura.IniciarCaiguda;
var p: TProcesCaigudaFigura;
begin
        if ((not EstaTrencant)and(not EstaCaient)) then
        begin
                EstaCaient:=true;
                p:= TProcesCaigudaFigura.create(self);
                LlistaProcessos.InserirProces(p);
        end;
end;

function TFigura.ObtenirNumeroSuports: integer;
var    exist: Boolean;
           f: TFigura;
NumSuports,e: Integer;
        part: TPartFigura;
begin
        NumSuports:=0;
        for e:=0 to Length(forma)-1 do
        begin
                Parts[e].ObtenirSuport(part, f, exist);
                if ((exist) and (f<>self)) then inc(NumSuports)
        end;
        ObtenirNumeroSuports:=NumSuports;
end;

function TFigura.ObtenirMassaTotalSoportadaRepartida: integer;
var NumSuports: Integer;
begin
        NumSuports:=ObtenirNumeroSuports;
        ObtenirMassaTotalSoportadaRepartida:= ObtenirMassaTotalSoportada div NumSuports;
end;

function TFigura.ObtenirMassaTotalSoportada: integer;
var pes,e,p:integer;
      final:boolean;
      aux,f:TFigura;
       part:TPartFigura;
begin
        p:=Massa;
        aux:=nil;
        pes:=0;
        for e:=0 to Length(forma)-1 do
        begin
                Parts[e].ObtenirSubjecte(part, f, final);
                if ((final) and (f<>self) and (f<>aux)) then
                begin
                        pes:=f.ObtenirMassaTotalSoportadaRepartida;
                        p:=p+pes;
                        aux:=f;
                end
                else if aux=f then p:=p+pes;
        end;
        ObtenirMassaTotalSoportada:=p;
end;

procedure TFigura.NotificarImpacte;
var e:Integer;
    f:TFigura;
 part:TPartFigura;
exist:Boolean;
begin
//        if not EstaTrencant then
//        begin
                for e:=0 to Length(forma)-1 do //Notifico l'impacte als de sota
                begin
                        Parts[e].ObtenirSuport(part, f, exist);
                        if ((exist) and (f<>self)) then f.NotificarImpacte;
                end;
                if ((ObtenirMassaTotalSoportada>Massa*8) and (not EstaCaient) and (not EstaTrencant)) then self.IniciarTrencar;
//        end;
end;

procedure TFigura.AssignarDestructometre(m: TDestructometre);begin Mesurador:=m;end;

procedure TFigura.caure(out stop: Boolean);
var      e: integer;
      part: TPartFigura;
anterior,f: TFigura;
     final: Boolean;
begin
        stop:=false;
        final:=false;
        anterior:=nil;
        for e:=0 to Length(forma)-1 do
        begin
                Parts[e].ObtenirSuport(part, f, final);
                if ((final) and (f<>self) and (anterior<>f)) then
                begin
                        anterior:=f;
                        stop:=true;
                        f.NotificarImpacte;
                end;
        end;
        if not stop then
        begin
                EnMoviment:=true;
                for e:=0 to Length(forma)-1 do Parts[Ordre[e]].caure;
        end
        else if EnMoviment then
        begin
                self.IniciarTrencar;
        end
        else EstaCaient:=false;
end;

procedure TRuna.caure(out stop: Boolean);
var                                 part: TPartFigura;
                                       f: TFigura;
sud_exist, sud_oest_exist, sud_est_exist: Boolean;
                                   opcio: Integer;
begin
        stop:=false;
        with Parts[0] do
        begin
                ObtenirSuport(part, f, sud_exist);
                if sud_exist then
                begin
                        f.NotificarImpacte;
                        ObtenirSuportEsquerra(part, f, sud_oest_exist);
                        ObtenirSuportDret(part, f, sud_est_exist);
                        opcio:=Random(2);
                        case opcio of
                          0: begin
                                if not sud_oest_exist then caureEsquerra
                                else if not sud_est_exist then caureDreta
                                else
                                begin
                                        EstaCaient:=false;
                                        stop:=true;
                                end;
                             end;
                          1: begin
                                if not sud_est_exist then caureDreta
                                else if not sud_oest_exist then caureEsquerra
                                else
                                begin
                                        EstaCaient:=false;
                                        stop:=true;
                                end;
                             end;
                        end;
                 end
                else caure;
        end;
end;

function TFigura.ObtenirPartFigura(n :integer): TPartFigura;
begin ObtenirPartFigura:= Parts[n]; end;

function TFigura.ObtenirForma: string;
var buffer: PChar;
begin
        GetMem(buffer, Length(Forma));
        StrCopy(buffer, PChar(Forma));
        ObtenirForma:=strPas(buffer);
end;

constructor TCella.Create;
begin
        nord:= nil; nord_est:= nil; est:= nil; sud_est:= nil;
        sud:= nil; sud_oest:= nil; oest:= nil; nord_oest:= nil;
        figura:= nil; part:= nil;
end;

procedure TMapa.ObtenirTamanyMapa(out a, f: integer);
begin
        a:=amplada;
        f:=fondaria;
end;

procedure TMapa.MapejarFigura(figura: TFigura; x,y:integer);
var        aux: PChar;
 aux_x,aux_y,l: integer;
          part: TPartFigura;
         forma: string;
begin
        aux_x:=x;
        aux_y:=y;
        forma:= figura.ObtenirForma;
        GetMem(aux, Length(forma));
        strcopy(aux, PChar(forma));
        for l:= 0 to Length(forma)-1 do
        begin
                if aux[l]='e' then aux_x:=aux_x+1
                else if aux[l]='s' then aux_y:=aux_y+1
                else if aux[l]='o' then aux_x:=aux_x-1
                else if aux[l]='n' then aux_y:=aux_y-1;
                part:= figura.ObtenirPartFigura(l);
                part.AssignarPosicio(aux_x, aux_y);
                part.Pintar;
                Matriu[aux_x,aux_y].AssignarPartFigura(part);
                Matriu[aux_x,aux_y].AssignarFigura(figura);
                part.AssignarCella(Matriu[aux_x, aux_y]);
        end;
end;

constructor TMapa.Create;
begin
        amplada:=0;
        fondaria:=0;
end;

procedure TMapa.CarregarMapa(fitxer: String; cataleg: TCatalegFigures; control: TControlTeclat; out mesura: TDestructometre; out i: integer);
var     F: TextFile;
        S: String;
x,y,n,num: Integer;
   figura: TFigura;
begin
        AssignFile(F, fitxer);
        Reset(F);
        Readln(F, S);           //Ignoro la primera linia
        Readln(F, S);           //Llegeix l'amplada del mapa
        amplada:= StrToInt(S);
        Readln(F, S);           //Llegeix la fondaria del mapa
        fondaria:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre d'intents
        i:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre màxim de destrucció
        mesura.Max:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre mínim de destrucció
        mesura.Min:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre de figures
        SetLength(Matriu, amplada, fondaria); //Reservo memòria
        InicialitzarCelles;
        control.AssignarCella(Matriu[1,1]);
        num:= StrToInt(S);
        mesura.Total:=num;

        for n:=1 to num do
        begin
                Readln(F,S);                      //Llegeix el tipus de figura
                figura:= cataleg.CrearFigura(S, 0);  //La crea
                figura.AssignarDestructometre(mesura);
                Readln(F,S);                      //Llegeix la coordenada horitzontal
                x:= StrToInt(S);
                Readln(F,S);                      //Llegeix la coordenada vertical
                y:= StrToInt(S);
                MapejarFigura(figura,x,y);        //Mapejo la figura
                //figura.IniciarCaiguda;
        end;

        for n:=0 to amplada-1 do
        begin
                figura:= cataleg.CrearFigura('TERRA',0);
                MapejarFigura(figura,n,fondaria-1);
                figura:= cataleg.CrearFigura('TERRA',0);
                MapejarFigura(figura,n,0);
        end;
        for n:=0 to fondaria-1 do
        begin
                figura:= cataleg.CrearFigura('TERRA',0);
                MapejarFigura(figura,amplada-1,n);
                figura:= cataleg.CrearFigura('TERRA',0);
                MapejarFigura(figura,0,n);
        end;
        CloseFile(F);
end;

procedure TMapa.InicialitzarCelles;
var     x,y: Integer;
begin
        for y:=0 to fondaria-1 do
        begin
                for x:=0 to amplada-1 do Matriu[x,y]:= TCella.Create; //Creo les cel·les
        end;

        for x:=1 to amplada-2 do
        begin
                with Matriu[x,0] do
                begin
                        nord:=nil; nord_est:=nil; nord_oest:=nil;
                        sud:=Matriu[x,1];
                        sud_oest:=Matriu[x-1,1];
                        sud_est:=Matriu[x+1,1];
                        oest:=Matriu[x-1,0];
                        est:=Matriu[x+1,0];
                end;
                with Matriu[x,fondaria-1] do
                begin
                        sud:=nil; sud_est:=nil; sud_oest:=nil;
                        nord:=Matriu[x,fondaria-2];
                        nord_est:=Matriu[x+1, fondaria-2];
                        nord_oest:=Matriu[x-1, fondaria-2];
                        oest:=Matriu[x-1,0];
                        est:=Matriu[x+1,0];
                end;
        end;

        for y:=1 to fondaria-2 do
        begin
                with Matriu[0,y] do
                begin
                        oest:=nil; sud_oest:=nil; nord_oest:=nil;
                        est:=Matriu[1,y];
                        nord_est:=Matriu[1,y-1];
                        sud_est:=Matriu[1,y+1];
                end;
                with Matriu[amplada-1,y] do
                begin
                        est:=nil; nord_est:=nil; sud_est:=nil;
                        oest:=Matriu[amplada-1,y];
                        sud_oest:=Matriu[amplada-1, y+1];
                        nord_oest:=Matriu[amplada-1, y-1];
                end;
        end;

        for y:=1 to fondaria-2 do
        begin
                for x:=1 to amplada-2 do
                begin
                       with Matriu[x,y] do
                       begin
                                nord:=Matriu[x,y-1];
                                sud:=Matriu[x,y+1];
                                est:=Matriu[x+1,y];
                                oest:=Matriu[x-1,y];
                                nord_est:=Matriu[x+1,y-1];
                                nord_oest:=Matriu[x-1,y-1];
                                sud_est:=Matriu[x+1,y+1];
                                sud_oest:=Matriu[x-1,y+1];
                       end;
                end;
        end;
        with Matriu[0,0] do
        begin
                oest:=nil; nord:=nil;
                est:=Matriu[1,0];
                sud:=Matriu[0,1];
        end;
end;

procedure TCatalegFigures.CarregarDadesFigura(out d: TDadesFigura; fitxer: string);
var f:integer;
begin
        f := FileOpen(fitxer, fmOpenRead);
        FileRead(f, d, SizeOf(TDadesFigura));
        FileClose(f);
end;

function TCatalegFigures.CrearFigura(nom: String; massa: integer): TFigura;
var dades: TDadesFigura;
begin
                CarregarDadesFigura(dades, 'figures/'+nom+'.fig');
                if nom='RUNA' then CrearFigura:= TRuna.create(dades, imatge, LlistaProcessos, self, massa)
                else if nom='TERRA' then CrearFigura:= TTerra.create(dades, imatge, LlistaProcessos, self, massa)
                else CrearFigura:= TFigura.create(dades, imatge, LlistaProcessos, self, massa);
end;

constructor TCatalegFigures.create(img: TImgView32; llista: TLlistaProcessos);
begin
        imatge:= img;
        LlistaProcessos:= llista;
end;
end.
