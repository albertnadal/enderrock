unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GR32, GR32_Image,GR32_Layers, Buttons,
  ComCtrls, ToolWin, ActnList, ImgList;
  
type
  TDadesParcela = RECORD
        x_inici, y_inici: integer;
        tipus, forma:string;
        inici, ocupat:boolean;
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Imatge: TImage32;
    NomPeca: TLabel;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel3: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Panel4: TPanel;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    Panel5: TPanel;
    SpeedButton15: TSpeedButton;
    Shape1: TShape;
    OpenDialog: TOpenDialog;
    Panel8: TPanel;
    Label2: TLabel;
    NumeroPeces: TLabel;
    Imatges: TImageList;
    StandardToolBar: TToolBar;
    Button1: TButton;
    EditAmplada: TEdit;
    Label1: TLabel;
    EditFondaria: TEdit;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    SaveDialog: TSaveDialog;
    SpeedButton14: TSpeedButton;
    SpeedButton16: TSpeedButton;
    function ObtenirForma(nom:string):string;
    function HiHaEspaiPerInserirFigura(forma:string; x,y:integer):boolean;
    function ObtenirColor(nom:string):TColor32;
    procedure GuardarEstructuraAlFitxer(ruta_fitxer: string);
    procedure CarregarEstructuraDesdeFitxer(ruta_fitxer: string);
    procedure IncrementarNumeroPeces;
    procedure DecrementarNumeroPeces;    
    procedure CarregarPeca(nom:string);
    procedure EliminarFigura(coord_x,coord_y:integer);
    procedure RestaurarMatriu;
    procedure InserirFigura(tipus_peca, forma_peca:string; coord_x, coord_y:integer);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImatgeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure ImatgeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tipus_peca_actual:string;
    forma_peca_actual:string;
    color_peca_actual:TColor32;
    matriu: array of array of TDadesParcela;
    amplada, fondaria:integer;
    MatriuInicialitzada:boolean;
    canvis:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{
dades.forma:='$eeeee';
dades.fitxer:='peces/marro_fosc.bmp';
GuardarDadesFigura(dades,'figures/BH.fig');

dades.forma:='$sssss';
dades.fitxer:='peces/marro_clar.bmp';
GuardarDadesFigura(dades,'figures/BV.fig');

dades.forma:='$ssseee';
dades.fitxer:='peces/groc.bmp';
GuardarDadesFigura(dades,'figures/L1.fig');

dades.forma:='$sssooo';
dades.fitxer:='peces/groc_fosc.bmp';
GuardarDadesFigura(dades,'figures/L2.fig');

dades.forma:='$ooosss';
dades.fitxer:='peces/blau_mari.bmp';
GuardarDadesFigura(dades,'figures/L3.fig');

dades.forma:='$eeesss';
dades.fitxer:='peces/blau_fosc.bmp';
GuardarDadesFigura(dades,'figures/L4.fig');

dades.forma:='$soossoso';
dades.fitxer:='peces/verd_fosc.bmp';
GuardarDadesFigura(dades,'figures/D1.fig');

dades.forma:='$seessese';
dades.fitxer:='peces/verd_clar.bmp';
GuardarDadesFigura(dades,'figures/D2.fig');

dades.forma:='$osossoos';
dades.fitxer:='peces/verd_claret.bmp';
GuardarDadesFigura(dades,'figures/D3.fig');

dades.forma:='$esessees';
dades.fitxer:='peces/verd.bmp';
GuardarDadesFigura(dades,'figures/D4.fig');

dades.forma:='$eeeeeeeeesooooooooo';
dades.fitxer:='peces/gris.bmp';
GuardarDadesFigura(dades,'figures/HLL.fig');

dades.forma:='$osososososososososo';
dades.fitxer:='peces/gris.bmp';
GuardarDadesFigura(dades,'figures/DLL1.fig');

dades.forma:='$sseenno';
dades.fitxer:='peces/gris_clar.bmp';
GuardarDadesFigura(dades,'figures/CUB.fig');

dades.forma:='$';
dades.fitxer:='peces/acer_limit.bmp';
GuardarDadesFigura(dades,'figures/TERRA.fig');

dades.forma:='$';
dades.fitxer:='peces/runa.bmp';
GuardarDadesFigura(dades,'figures/RUNA.fig');
}
procedure TForm1.GuardarEstructuraAlFitxer(ruta_fitxer: string);
var    F: TextFile;
       S: String;
     x,y: Integer;
   dades: TDadesParcela;
begin
        AssignFile(F, ruta_fitxer);
        Rewrite(F);
        Writeln(F, 'No editis aquest fitxer si no saps el que fas');           //Insereixo el comentari inicial
        Writeln(F, IntToStr(amplada));           //Llegeix l'amplada del mapa
        Writeln(F, IntToStr(fondaria));          //Llegeix la fondaria del mapa
        Writeln(F,'5');            //Llegeix el nombre d'intents
        Writeln(F,NumeroPeces.caption);            //Llegeix el nombre màxim de destrucció
        Writeln(F,NumeroPeces.caption);            //Llegeix el nombre mínim de destrucció
        Writeln(F,NumeroPeces.caption);            //Llegeix el nombre de figures
        for x:=1 to amplada-2 do
        begin
                for y:=1 to fondaria-2 do
                begin
                   dades:=Matriu[x, y];

                   if((dades.ocupat)and(dades.inici)) then
                   begin
                        Writeln(F, dades.tipus);
                        Writeln(F, IntToStr(x));
                        Writeln(F, IntToStr(y));
                   end;
                end;
        end;
        CloseFile(F);
end;

procedure TForm1.CarregarEstructuraDesdeFitxer(ruta_fitxer: string);
var           F: TextFile;
       figura,S: String;
          x,y,n: Integer;
begin
        AssignFile(F, ruta_fitxer);
        Reset(F);
        Readln(F, S);           //Ignoro la primera linia
        Readln(F, S);           //Llegeix l'amplada del mapa
        amplada:= StrToInt(S);
        EditAmplada.text:=S;
        Readln(F, S);           //Llegeix la fondaria del mapa
        fondaria:= StrToInt(S);
        EditFondaria.text:=S;
        Readln(F,S);            //Llegeix el nombre d'intents
        //i:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre màxim de destrucció
        //mesura.Max:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre mínim de destrucció
        //mesura.Min:= StrToInt(S);
        Readln(F,S);            //Llegeix el nombre de figures
        NumeroPeces.caption:='0';
        Imatge.bitmap.setsize(amplada, fondaria);
        imatge.bitmap.clear($FFFFFFFF);
        SetLength(matriu,amplada,fondaria); //Reservo memòria
        RestaurarMatriu;
        MatriuInicialitzada:=true;
        NumeroPeces.caption:=S;
        for n:=1 to StrToInt(S) do
        begin
                Readln(F,figura);                 //Llegeix el tipus de figura
                CarregarPeca(figura);
                Readln(F,S);                      //Llegeix la coordenada horitzontal
                x:= StrToInt(S);
                Readln(F,S);                      //Llegeix la coordenada vertical
                y:= StrToInt(S);
                InserirFigura(figura, forma_peca_actual, x, y);
        end;

        CarregarPeca('TERRA');
        for n:=0 to amplada-1 do
        begin
                InserirFigura('TERRA', forma_peca_actual, n, fondaria-1);
                InserirFigura('TERRA', forma_peca_actual, n, 0);
        end;
        for n:=0 to fondaria-1 do
        begin
                InserirFigura('TERRA', forma_peca_actual, amplada-1, n);
                InserirFigura('TERRA', forma_peca_actual, 0, n);
        end;
        CloseFile(F);
end;

procedure TForm1.IncrementarNumeroPeces;
begin
        NumeroPeces.caption:=IntToStr(StrToInt(NumeroPeces.Caption) + 1);
end;

procedure TForm1.DecrementarNumeroPeces;
begin
        NumeroPeces.caption:=IntToStr(StrToInt(NumeroPeces.Caption) - 1);
end;

procedure TForm1.CarregarPeca(nom:string);
begin
        tipus_peca_actual:=nom;
        forma_peca_actual:=ObtenirForma(nom);
        color_peca_actual:=ObtenirColor(nom);
end;

function TForm1.ObtenirColor(nom:string):TColor32;
begin
        if nom='BV' then ObtenirColor:=$FF8040
        else if nom='BH' then ObtenirColor:=$804000
        else if nom='BHM' then ObtenirColor:=$804000
        else if nom='BVM' then ObtenirColor:=$FF8040
        else if nom='L1' then ObtenirColor:=$FFFF00
        else if nom='L2' then ObtenirColor:=$808000
        else if nom='L3' then ObtenirColor:=$000080
        else if nom='L4' then ObtenirColor:=$0000FF
        else if nom='D1' then ObtenirColor:=$004040
        else if nom='D2' then ObtenirColor:=$5BA597
        else if nom='D3' then ObtenirColor:=$91FFC8
        else if nom='D4' then ObtenirColor:=$00FF00
        else if nom='HLL' then ObtenirColor:=$808080
        else if nom='DLL1' then ObtenirColor:=$808080
        else if nom='CUB' then ObtenirColor:=$C0C0C0
        else if nom='TERRA' then ObtenirColor:=$7B5959
        else if nom='RUNA' then ObtenirColor:=$D4D4D4;

end;

function TForm1.ObtenirForma(nom:string):string;
begin
        if nom='BV' then ObtenirForma:='$sssss'
        else if nom='BH' then ObtenirForma:='$eeeee'
        else if nom='BHM' then ObtenirForma:='$eeeeee'
        else if nom='BVM' then ObtenirForma:='$ssssss'
        else if nom='L1' then ObtenirForma:='$ssseee'
        else if nom='L2' then ObtenirForma:='$sssooo'
        else if nom='L3' then ObtenirForma:='$ooosss'
        else if nom='L4' then ObtenirForma:='$eeesss'
        else if nom='D1' then ObtenirForma:='$soossoso'
        else if nom='D2' then ObtenirForma:='$seessese'
        else if nom='D3' then ObtenirForma:='$osossoos'
        else if nom='D4' then ObtenirForma:='$esessees'
        else if nom='HLL' then ObtenirForma:='$eeeeeeeeesooooooooo'
        else if nom='DLL1' then ObtenirForma:='$osososososososososo'
        else if nom='CUB' then ObtenirForma:='$sseenno'
        else if nom='TERRA' then ObtenirForma:='$'
        else if nom='RUNA' then ObtenirForma:='$';
end;

procedure TForm1.EliminarFigura(coord_x,coord_y:integer);
var pos_x, pos_y,e:integer;
f:string;
begin
        with matriu[coord_x, coord_y] do
        begin
                pos_x:=x_inici;
                pos_y:=y_inici;
                f:=forma;
        end;

        for e:=0 to length(f) do
        begin
                if f[e]='s' then inc(pos_y)
                else if f[e]='n' then dec(pos_y)
                else if f[e]='e' then inc(pos_x)
                else if f[e]='o' then dec(pos_x);

                imatge.bitmap.Line(pos_x, pos_y, pos_x, pos_y,$FFFFFFFF,true);
                matriu[pos_x, pos_y].ocupat:=false;
        end;
end;

function TForm1.HiHaEspaiPerInserirFigura(forma:string; x,y:integer):boolean;
var
pos_x,pos_y,e:integer;
Resultat:boolean;
begin
        Resultat:=true;
        pos_x:=x;
        pos_y:=y;
        e:=1;
        while ((e<=length(forma))and(Resultat)) do
        begin
                if forma[e]='s' then inc(pos_y)
                else if forma[e]='n' then dec(pos_y)
                else if forma[e]='e' then inc(pos_x)
                else if forma[e]='o' then dec(pos_x);

                if ((pos_y>=fondaria)or(pos_y<=0)or(pos_x>=amplada)or(pos_x<=0)or(matriu[pos_x, pos_y].ocupat)) then Resultat:=false;
                inc(e);
        end;
        HiHaEspaiPerInserirFigura:=Resultat;
end;

procedure TForm1.InserirFigura(tipus_peca, forma_peca:string; coord_x, coord_y:integer);
var e,pos_x, pos_y:integer;
begin
        with matriu[coord_x, coord_y] do
        begin
                tipus:=tipus_peca;
                forma:=forma_peca;
                x_inici:=coord_x;
                y_inici:=coord_y;
                inici:=true;
                ocupat:=true;
        end;

        pos_x:=coord_x;
        pos_y:=coord_y;
        for e:=1 to length(forma_peca) do
        begin
                if forma_peca[e]='s' then inc(pos_y)
                else if forma_peca[e]='n' then dec(pos_y)
                else if forma_peca[e]='e' then inc(pos_x)
                else if forma_peca[e]='o' then dec(pos_x);
                imatge.bitmap.Line(pos_x, pos_y, pos_x, pos_y,ObtenirColor(tipus_peca),true);
                with matriu[pos_x, pos_y] do
                begin
                        tipus:=tipus_peca;
                        forma:=forma_peca;
                        x_inici:=coord_x;
                        y_inici:=coord_y;
                        if (e>1) then inici:=false;
                        ocupat:=true;
                end;
        end;


end;

procedure TForm1.RestaurarMatriu;
var x,y:integer;
begin
        for x:=0 to amplada-1 do for y:=0 to fondaria-1 do matriu[x,y].ocupat:=false;
end;

procedure TForm1.Button1Click(Sender: TObject);
var n:integer;
begin
Imatge.bitmap.setsize(strtoint(EditAmplada.text),strtoint(EditFondaria.text));
imatge.bitmap.clear($FFFFFFFF);
SetLength(matriu,strtoint(EditAmplada.text),strtoint(EditFondaria.text));
amplada:= strtoint(EditAmplada.text);
fondaria:= strtoint(EditFondaria.text);
RestaurarMatriu;
NumeroPeces.caption:='0';
        CarregarPeca('TERRA');
        for n:=0 to amplada-1 do
        begin
                InserirFigura('TERRA', forma_peca_actual, n, fondaria-1);
                InserirFigura('TERRA', forma_peca_actual, n, 0);
        end;
        for n:=0 to fondaria-1 do
        begin
                InserirFigura('TERRA', forma_peca_actual, amplada-1, n);
                InserirFigura('TERRA', forma_peca_actual, 0, n);
        end;
MatriuInicialitzada:=true;
CarregarPeca('L1');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        imatge.ScaleMode := smStretch; //smNormal, smStretch, smScale, smResize
        CarregarPeca('BV');
        canvis:=false;
end;

procedure TForm1.ImatgeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
coord_x, coord_y:integer;
begin
coord_x:=(x * strtoint(EditAmplada.text)) div Imatge.Width;
coord_y:=(y * strtoint(EditFondaria.text)) div Imatge.Height;
if MatriuInicialitzada then
begin
        if button=mbleft then
        begin
                if ((not matriu[coord_x, coord_y].ocupat)and(HiHaEspaiPerInserirFigura(forma_peca_actual,coord_x,coord_y))) then
                begin
                        InserirFigura(tipus_peca_actual, forma_peca_actual, coord_x, coord_y);
                        IncrementarNumeroPeces;
                end
                else beep;
        end
        else if button=mbright then
        begin
               if ((matriu[coord_x, coord_y].ocupat)and(matriu[coord_x, coord_y].tipus<>'TERRA')) then
               begin
                        EliminarFigura(coord_x,coord_y);
                        DecrementarNumeroPeces;
               end
               else beep;
        end;
end
else application.MessageBox('Primer has de definir l''amplada i la fondaria i després clica a "Crear nova estructura".', 'Editor d''estructures', MB_OK);
end;




procedure TForm1.ImatgeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
coord_x, coord_y:integer;
begin
coord_x:=(x * strtoint(EditAmplada.text)) div Imatge.Width;
coord_y:=(y * strtoint(EditFondaria.text)) div Imatge.Height;
if ((MatriuInicialitzada)and(matriu[coord_x, coord_y].ocupat)) then NomPeca.caption:=matriu[coord_x,coord_y].tipus
else NomPeca.caption:='';

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
CarregarPeca('BV');
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
CarregarPeca('BH');
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
CarregarPeca('L1');
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
CarregarPeca('L2');
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
CarregarPeca('L3');
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
CarregarPeca('L4');
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
CarregarPeca('D1');
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
CarregarPeca('D2');
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
CarregarPeca('D3');
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
CarregarPeca('D4');
end;

procedure TForm1.SpeedButton11Click(Sender: TObject);
begin
CarregarPeca('HLL');
end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
CarregarPeca('DLL1');
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
CarregarPeca('CUB');
end;

procedure TForm1.SpeedButton15Click(Sender: TObject);
begin
CarregarPeca('RUNA');
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    CarregarEstructuraDesdeFitxer(OpenDialog.FileName);
  end;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin

  if ((MatriuInicialitzada)and(SaveDialog.Execute)) then
  begin
        if FileExists(SaveDialog.FileName) then
        begin
              if (application.MessageBox('El fitxer ja existeix. El vols sobreescriure?', 'Editor d''estructures', MB_YESNO)=7) then Exit;
              GuardarEstructuraAlFitxer(SaveDialog.FileName);
        end
        else GuardarEstructuraAlFitxer(SaveDialog.FileName);
  end
  else application.MessageBox('No s''ha guardat l''estructura.', 'Editor d''estructures', MB_OK);

end;
procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
CarregarPeca('BVM');
end;

procedure TForm1.SpeedButton16Click(Sender: TObject);
begin
CarregarPeca('BHM');
end;

end.
