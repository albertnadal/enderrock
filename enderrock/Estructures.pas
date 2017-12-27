unit Estructures;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TractamentFigures, StdCtrls, GR32_Image, ExtCtrls, GR32, GR32_Layers,
  siFltBtn, Buttons, DXInput, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  OvalBtn;

type
  TForm1 = class(TForm)
    ImgView: TImgView32;
    Timer1: TTimer;
    Panel1: TPanel;
    BotoFletxaEsquerra: TSpeedButton;
    BotoFletxaAmunt: TSpeedButton;
    BotoFletxaDreta: TSpeedButton;
    BotoFletxaAball: TSpeedButton;
    BotoBomba: TSpeedButton;
    ScrollBox1: TScrollBox;
    ImatgeNivell1: TImage;
    ImatgeNivell2: TImage;
    ImatgeNivell3: TImage;
    ImatgeNivell4: TImage;
    ImatgeNivell5: TImage;
    ImatgeNivell6: TImage;
    ImatgeNivell7: TImage;
    ImatgeNivell8: TImage;
    Selector: TShape;
    BotoIniciar: TsiFlatBtn;
    siFlatBtn2: TsiFlatBtn;
    PanellOpcions: TPanel;
    SelectorVelocitat: TScrollBar;
    Image3: TImage;
    Image4: TImage;
    SelectorTamany: TScrollBar;
    siFlatBtn3: TsiFlatBtn;
    rgScaleMode: TRadioGroup;
    siFlatBtn4: TsiFlatBtn;
    siFlatBtn5: TsiFlatBtn;
    BeepCheck: TCheckBox;
    DXInput1: TDXInput;
    PanellInferior: TPanel;
    ShapeMesurador: TShape;
    ShapeMesura: TShape;
    LimitInf: TShape;
    LimitSup: TShape;
    Panel2: TPanel;
    Intents: TLabel;
    ImatgeAjudant: TImage;
    DialegAjudant: TLabel;
    GlobusPetit: TShape;
    GlobusGran: TShape;
    GlobusPetitPetit: TShape;
    AjudantCheck: TCheckBox;
    siFlatBtn1: TsiFlatBtn;
    procedure FormCreate(Sender: TObject);
    procedure Iniciar(teclat: boolean);
    procedure PintarComentariAjudant;
    procedure OcultarComentariAjudant;
    procedure CanviarComentariAjudant;
    function NoQuedenIntents: boolean;
    procedure CarregarNombreIntents(i:integer);
    procedure DecrementarIntents;
    procedure ExecutarVictoria;
    procedure ExecutarDerrota(msg: string);
    procedure ExecutarFiTorn;
    procedure CrearFitxersFigures;
    procedure Timer1Timer(Sender: TObject);
    procedure SelectorVelocitatChange(Sender: TObject);
    procedure GuardarDadesFigura(dades:TDadesFigura; fitxer:string);
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure EscalaComboClick(Sender: TObject);
    procedure BotoFletxaAmuntClick(Sender: TObject);
    procedure BotoFletxaEsquerraClick(Sender: TObject);
    procedure BotoFletxaDretaClick(Sender: TObject);
    procedure BotoFletxaAballClick(Sender: TObject);
    procedure InicialitzarTeclat;
    procedure SelectorTamanyChange(Sender: TObject);
    procedure BotoBombaClick(Sender: TObject);
    procedure ImatgeNivell1Click(Sender: TObject);
    procedure ImatgeNivell2Click(Sender: TObject);
    procedure ImatgeNivell3Click(Sender: TObject);
    procedure ImatgeNivell4Click(Sender: TObject);
    procedure ImatgeNivell5Click(Sender: TObject);
    procedure ImatgeNivell6Click(Sender: TObject);
    procedure ImatgeNivell7Click(Sender: TObject);
    procedure ImatgeNivell8Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BotoIniciarClick(Sender: TObject);
    procedure siFlatBtn2Click(Sender: TObject);
    procedure siFlatBtn3Click(Sender: TObject);
    procedure rgScaleModeClick(Sender: TObject);
    procedure BeepCheckClick(Sender: TObject);
    procedure FormResizen(Sender: TObject);
    procedure AjudantCheckClick(Sender: TObject);
    procedure siFlatBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
  B: TBitmapLayer;
  FitxerMapa: String;
    { Public declarations }
  end;

var
  Form1: TForm1;
  Cataleg: TCatalegFigures;
  Mapa: TMapa;
  Processos: TLlistaProcessos;
  Control: TControlTeclat;
  DIPreparat  : boolean = false;
  Mesurador: TDestructometre;

implementation

{$R *.dfm}
procedure TForm1.CanviarComentariAjudant;
var msg: string;
      t: integer;
begin
        t:=DialegAjudant.Width;
        randomize;
        case random(6) of
          0: msg:='Et recordo que pots usar els controls ràpids amb les tecles de cursor i la tecla Espai.';
          1: msg:='Pots incrementar la velocitat de caiguda de les peces al menú d''opcions.';
          2: msg:='Pots ajustar el tamany de l''estructura accedint al menú d''opcions.';
          3: msg:='Cada peça te un pes propi, i aquest és proporcional al seu tamany.';
          4: msg:='Les peces més grans son capaces de soportar més quantitat de pes que les petites.';
          5: msg:='El pes d''una part de l''estructura es reparteix pel nombre de suports que la sostenen.';
        end;
        DialegAjudant.caption:=msg;
        DialegAjudant.Width:=t;
        PintarComentariAjudant;
end;

procedure TForm1.PintarComentariAjudant;
begin
        ImatgeAjudant.visible:=true;
        GlobusPetitPetit.left:=ImatgeAjudant.left-GlobusPetitPetit.Width;
        GlobusPetit.left:=GlobusPetitPetit.left-GlobusPetit.Width;
        GlobusGran.left:=GlobusPetit.left-GlobusGran.Width;
        GlobusGran.Height:=DialegAjudant.Height+16;
        DialegAjudant.left:=GlobusGran.left+12;
        GlobusPetitPetit.visible:=true;
        GlobusPetit.Visible:=true;
        GlobusGran.Visible:=true;
        DialegAjudant.Visible:=true;
end;

procedure TForm1.OcultarComentariAjudant;
begin
        GlobusPetitPetit.visible:=false;
        GlobusPetit.Visible:=false;
        GlobusGran.Visible:=False;
        DialegAjudant.Visible:=false;
        ImatgeAjudant.visible:=false;
end;

procedure TForm1.CarregarNombreIntents(i: integer);
begin
        Intents.Caption:= IntToStr(i) + ' Intents';
end;

function TForm1.NoQuedenIntents: boolean;
begin
        if StrToInt(StringReplace(Intents.caption, ' Intents', '',[rfReplaceAll]))<=0 then NoQuedenIntents:=true
        else NoQuedenIntents:=false;
end;

procedure TForm1.DecrementarIntents;
var StringNumIntents: String;
          NumIntents: Integer;
begin
        StringNumIntents:= StringReplace(Intents.caption, ' Intents', '',[rfReplaceAll]);
        NumIntents:=StrToInt(StringNumIntents);
        if NumIntents>0 then
        begin
                Dec(NumIntents);
                StringNumIntents:=IntToStr(NumIntents);
                Intents.caption:= StringNumIntents + ' Intents';
        end;
end;

procedure TForm1.ExecutarFiTorn;
begin
        ImgView.cursor:=crArrow;
        Timer1.Enabled:=false;
        BotoIniciar.enabled:=true;
        BotoFletxaDreta.enabled:=true;
        BotoFletxaEsquerra.enabled:=true;
        BotoFletxaAmunt.enabled:=true;
        BotoFletxaAball.enabled:=true;
        BotoBomba.enabled:=true;
        DIPreparat:=true;
end;

procedure TForm1.ExecutarVictoria;
begin

        ImgView.cursor:=crArrow;
        Timer1.Enabled:=false;
        Application.MessageBox('Nivell superat!', 'Enderrock!', MB_OK);
        BotoIniciar.enabled:=true;
        if AjudantCheck.checked then CanviarComentariAjudant;
end;

procedure TForm1.ExecutarDerrota(msg: string);
begin

        ImgView.cursor:=crArrow;
        Timer1.Enabled:=false;
        Application.MessageBox(pchar('Nivell no superat! ' + msg), 'Enderrock!', MB_OK);
        BotoIniciar.enabled:=true;
        if AjudantCheck.checked then CanviarComentariAjudant;
end;

procedure TForm1.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  if not DIPreparat then exit;
  DXInput1.Update;

  // Keyboard
      // Update keyboard display.
      if isUp in DXInput1.States then Control.Amunt;
      if isDown in DXInput1.States then Control.Aball;
      if isLeft in DXInput1.States then Control.Esquerra;
      if isRight in DXInput1.States then Control.Dreta;
      if isButton1 in DXInput1.States then
      begin
        ImgView.cursor:=crHourGlass;
        BotoIniciar.enabled:=false;
        BotoFletxaDreta.enabled:=false;
        BotoFletxaEsquerra.enabled:=false;
        BotoFletxaAmunt.enabled:=false;
        BotoFletxaAball.enabled:=false;
        BotoBomba.enabled:=false;
        Control.TrencarFigura;
        Timer1.Enabled:=true;
        DIPreparat:=false;
      end;
end;

procedure TForm1.GuardarDadesFigura(dades:TDadesFigura; fitxer:string);
var f: integer;
begin
        f := FileCreate(fitxer);
        FileWrite(f, dades, SizeOf(TDadesFigura));
        FileClose(f);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        Update;
        Show;
        Randomize;
        CrearFitxersFigures;
        LimitSup.left:=0;
        LimitInf.Left:=0;
        ShapeMesura.left:=0;
        FitxerMapa:='nivells\nivell1.map'; //És aquest per defecte
        Processos:= TLlistaProcessos.create;
        Cataleg:= TCatalegFigures.create(ImgView, Processos);
        Control:= nil;
        Mapa:= nil;
        Iniciar(false);
        if AjudantCheck.Checked then PintarComentariAjudant;        
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var    NoProcessos: boolean;
begin
        if BeepCheck.checked then beep;
        Processos.ExecutarProcessos(NoProcessos);
        if NoProcessos then
        begin
                DecrementarIntents;
                if Mesurador.NivellSuperat then ExecutarVictoria
                else if Mesurador.NivellFallit then ExecutarDerrota('Has sobrepassat el límit permés.')
                else if NoQuedenIntents then ExecutarDerrota('Has esgotat tots els intents.')
                else ExecutarFiTorn;
        end;

end;

procedure TForm1.SelectorVelocitatChange(Sender: TObject);
begin
        Timer1.interval:=SelectorVelocitat.Position;
        ImgView.SetFocus;
end;

procedure TForm1.CrearFitxersFigures;
var  dades: TDadesFigura;
begin
dades.forma:='$eeeee';
dades.ordre[0]:=0; dades.ordre[1]:=1; dades.ordre[2]:=2;
dades.ordre[3]:=3; dades.ordre[4]:=4; dades.ordre[5]:=5;
dades.fitxer:='peces/marro_fosc.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/BH.fig');

dades.forma:='$sssss';
dades.ordre[0]:=5; dades.ordre[1]:=4; dades.ordre[2]:=3;
dades.ordre[3]:=2; dades.ordre[4]:=1; dades.ordre[5]:=0;
dades.fitxer:='peces/marro_clar.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/BV.fig');

dades.forma:='$ssseee';
dades.ordre[0]:=6; dades.ordre[1]:=5; dades.ordre[2]:=4;
dades.ordre[3]:=3; dades.ordre[4]:=2; dades.ordre[5]:=1; dades.ordre[6]:=0;
dades.fitxer:='peces/groc.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/L1.fig');

dades.forma:='$sssooo';
dades.ordre[0]:=6; dades.ordre[1]:=5; dades.ordre[2]:=4;
dades.ordre[3]:=3; dades.ordre[4]:=2; dades.ordre[5]:=1; dades.ordre[6]:=0;
dades.fitxer:='peces/groc_fosc.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/L2.fig');

dades.forma:='$ooosss';
dades.ordre[0]:=6; dades.ordre[1]:=5; dades.ordre[2]:=4;
dades.ordre[3]:=3; dades.ordre[4]:=2; dades.ordre[5]:=1; dades.ordre[6]:=0;
dades.fitxer:='peces/blau_mari.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/L3.fig');

dades.forma:='$eeesss';
dades.ordre[0]:=6; dades.ordre[1]:=5; dades.ordre[2]:=4;
dades.ordre[3]:=3; dades.ordre[4]:=2; dades.ordre[5]:=1; dades.ordre[6]:=0;
dades.fitxer:='peces/blau_fosc.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/L4.fig');

dades.forma:='$soossoso';
dades.ordre[0]:=8; dades.ordre[1]:=7; dades.ordre[2]:=6; dades.ordre[3]:=5;
dades.ordre[4]:=4; dades.ordre[5]:=3; dades.ordre[6]:=2; dades.ordre[7]:=1;
dades.ordre[8]:=0;
dades.fitxer:='peces/verd_fosc.bmp';
dades.massa:=150;
GuardarDadesFigura(dades,'figures/D1.fig');

dades.forma:='$seessese';
dades.ordre[0]:=8; dades.ordre[1]:=7; dades.ordre[2]:=6; dades.ordre[3]:=5;
dades.ordre[4]:=4; dades.ordre[5]:=3; dades.ordre[6]:=2; dades.ordre[7]:=1;
dades.ordre[8]:=0;
dades.fitxer:='peces/verd_clar.bmp';
dades.massa:=150;
GuardarDadesFigura(dades,'figures/D2.fig');

dades.forma:='$osossoos';
dades.ordre[0]:=8; dades.ordre[1]:=7; dades.ordre[2]:=6; dades.ordre[3]:=5;
dades.ordre[4]:=4; dades.ordre[5]:=3; dades.ordre[6]:=2; dades.ordre[7]:=1;
dades.ordre[8]:=0;
dades.fitxer:='peces/verd_claret.bmp';
dades.massa:=150;
GuardarDadesFigura(dades,'figures/D3.fig');

dades.forma:='$esessees';
dades.ordre[0]:=8; dades.ordre[1]:=7; dades.ordre[2]:=6; dades.ordre[3]:=5;
dades.ordre[4]:=4; dades.ordre[5]:=3; dades.ordre[6]:=2; dades.ordre[7]:=1;
dades.ordre[8]:=0;
dades.fitxer:='peces/verd.bmp';
dades.massa:=150;
GuardarDadesFigura(dades,'figures/D4.fig');

dades.forma:='$eeeeeeeeesooooooooo';
dades.ordre[0]:=19; dades.ordre[1]:=18; dades.ordre[2]:=17; dades.ordre[3]:=16;
dades.ordre[4]:=15; dades.ordre[5]:=14; dades.ordre[6]:=13; dades.ordre[7]:=12;
dades.ordre[8]:=11; dades.ordre[9]:=10; dades.ordre[10]:=9; dades.ordre[11]:=8;
dades.ordre[12]:=7; dades.ordre[13]:=6; dades.ordre[14]:=5; dades.ordre[15]:=4;
dades.ordre[16]:=3; dades.ordre[17]:=2; dades.ordre[18]:=1; dades.ordre[19]:=0;
dades.fitxer:='peces/gris.bmp';
dades.massa:=300;
GuardarDadesFigura(dades,'figures/HLL.fig');

dades.forma:='$ssssss';
dades.ordre[0]:=6; dades.ordre[1]:=5; dades.ordre[2]:=4;
dades.ordre[3]:=3; dades.ordre[4]:=2; dades.ordre[5]:=1; dades.ordre[6]:=0;
dades.fitxer:='peces/m_clar_m.bmp';
dades.massa:=1000;
GuardarDadesFigura(dades,'figures/BVM.fig');

dades.forma:='$eeeeee';
dades.ordre[0]:=0; dades.ordre[1]:=1; dades.ordre[2]:=2;
dades.ordre[3]:=3; dades.ordre[4]:=4; dades.ordre[5]:=5; dades.ordre[6]:=6;
dades.fitxer:='peces/m_fosc_m.bmp';
dades.massa:=2000;
GuardarDadesFigura(dades,'figures/BHM.fig');

dades.forma:='$osososososososososo';
dades.ordre[0]:=19; dades.ordre[1]:=18; dades.ordre[2]:=17; dades.ordre[3]:=16;
dades.ordre[4]:=15; dades.ordre[5]:=14; dades.ordre[6]:=13; dades.ordre[7]:=12;
dades.ordre[8]:=11; dades.ordre[9]:=10; dades.ordre[10]:=9; dades.ordre[11]:=8;
dades.ordre[12]:=7; dades.ordre[13]:=6; dades.ordre[14]:=5; dades.ordre[15]:=4;
dades.ordre[16]:=3; dades.ordre[17]:=2; dades.ordre[18]:=1; dades.ordre[19]:=0;
dades.fitxer:='peces/gris.bmp';
dades.massa:=300;
GuardarDadesFigura(dades,'figures/DLL1.fig');

dades.forma:='$sseenno';
dades.ordre[0]:=2; dades.ordre[1]:=3; dades.ordre[2]:=4; dades.ordre[3]:=5;
dades.ordre[4]:=1; dades.ordre[5]:=6; dades.ordre[6]:=7; dades.ordre[7]:=0;
dades.fitxer:='peces/gris_clar.bmp';
dades.massa:=200;
GuardarDadesFigura(dades,'figures/CUB.fig');

dades.forma:='$';
dades.ordre[0]:=0;
dades.fitxer:='peces/acer_limit.bmp';
dades.massa:=100;
GuardarDadesFigura(dades,'figures/TERRA.fig');

dades.forma:='$';
dades.ordre[0]:=0;
dades.fitxer:='peces/runa.bmp';
dades.massa:=0;
GuardarDadesFigura(dades,'figures/RUNA.fig');
end;

procedure TForm1.EscalaComboClick(Sender: TObject);
begin
ImgView.SetFocus;
end;

procedure TForm1.InicialitzarTeclat;
begin
        DIPreparat:=true;
end;

procedure TForm1.BotoFletxaAmuntClick(Sender: TObject);
begin
Control.Amunt;
ImgView.SetFocus;
end;

procedure TForm1.BotoFletxaEsquerraClick(Sender: TObject);
begin
Control.Esquerra;
ImgView.SetFocus;
end;

procedure TForm1.BotoFletxaDretaClick(Sender: TObject);
begin
Control.Dreta;
ImgView.SetFocus;
end;

procedure TForm1.BotoFletxaAballClick(Sender: TObject);
begin
Control.Aball;
ImgView.SetFocus;
end;

procedure TForm1.SelectorTamanyChange(Sender: TObject);
begin
        ImgView.Scale := SelectorTamany.Position / 100;
        ImgView.SetFocus;
end;

procedure TForm1.BotoBombaClick(Sender: TObject);
begin
        ImgView.cursor:=crHourGlass;
        BotoIniciar.enabled:=false;
        BotoFletxaDreta.enabled:=false;
        BotoFletxaEsquerra.enabled:=false;
        BotoFletxaAmunt.enabled:=false;
        BotoFletxaAball.enabled:=false;
        BotoBomba.enabled:=false;
        Control.TrencarFigura;
        Timer1.Enabled:=true;
        DIPreparat:=false;
end;

procedure TForm1.ImatgeNivell1Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell1.top;
        FitxerMapa:='nivells\nivell1.map';
end;

procedure TForm1.ImatgeNivell2Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell2.top;
        FitxerMapa:='nivells\nivell2.map';
end;



procedure TForm1.ImatgeNivell3Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell3.top;
        FitxerMapa:='nivells\nivell3.map';
end;

procedure TForm1.ImatgeNivell4Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell4.top;
        FitxerMapa:='nivells\nivell4.map';        
end;

procedure TForm1.ImatgeNivell5Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell5.top;
        FitxerMapa:='nivells\nivell5.map';
end;

procedure TForm1.ImatgeNivell6Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell6.top;
end;

procedure TForm1.ImatgeNivell7Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell7.top;
end;

procedure TForm1.ImatgeNivell8Click(Sender: TObject);
begin
        Selector.Top:=ImatgeNivell8.top;
end;
procedure TForm1.FormPaint(Sender: TObject);
begin
        if ImatgeAjudant.Visible then PintarComentariAjudant;
        ImgView.SetFocus;
//        InicialitzarTeclat;
end;

procedure TForm1.Iniciar(teclat:boolean);
var i,amplada,fondaria:integer;
begin
        ImgView.layers.clear;
{        if Control<>nil then
        begin
                Control.free;
        end;}

        Control:= TControlTeclat.create(ImgView);
        if Mesurador<>nil then Mesurador.Free;
        Mesurador:= TDestructometre.create(ShapeMesurador, ShapeMesura, LimitInf, LimitSup);
        if Processos<>nil then Processos.Free;
        Processos:= TLlistaProcessos.create;

        if Cataleg<>nil then Cataleg.free;
        Cataleg:= TCatalegFigures.create(ImgView, Processos);

        if Mapa<>nil then Mapa.free;
        Mapa:= TMapa.Create;
        Mapa.CarregarMapa(FitxerMapa, Cataleg, Control, Mesurador, i);
        Mapa.ObtenirTamanyMapa(amplada,fondaria);
        ImgView.Bitmap.SetSize(amplada*9,fondaria*9); //És el tamany en pixels del total
        if teclat then
        begin
                Application.OnIdle := AppOnIdle;
                InicialitzarTeclat;
                CarregarNombreIntents(i);
                if AjudantCheck.checked then OcultarComentariAjudant;
                ImgView.SetFocus;
                BotoFletxaDreta.enabled:=true;
                BotoFletxaEsquerra.enabled:=true;
                BotoFletxaAmunt.enabled:=true;
                BotoFletxaAball.enabled:=true;
                BotoBomba.enabled:=true;
        end;

        Mesurador.Restaurar;
end;

procedure TForm1.BotoIniciarClick(Sender: TObject);
begin
        Iniciar(true);
end;
procedure TForm1.siFlatBtn2Click(Sender: TObject);
begin
        if Application.MessageBox('Desitges sortir del joc?', 'Sortir', MB_OKCANCEL)=1 then
        begin
                Timer1.enabled:=false;
                Processos.free;
                Cataleg.free;
                if Mapa<>nil then Mapa.free;
                if control<>nil then Control.free;                
                Application.terminate;
        end;
end;
procedure TForm1.siFlatBtn3Click(Sender: TObject);
begin
        if not PanellOpcions.visible then PanellOpcions.visible:=true
        else PanellOpcions.visible:=false;
        if ImatgeAjudant.Visible then PintarComentariAjudant;
end;

procedure TForm1.rgScaleModeClick(Sender: TObject);
const
  SM_CONSTS: array [0..3] of TScaleMode = (smNormal, smStretch, smScale, smResize);
begin
        ImgView.ScaleMode := SM_CONSTS[rgScaleMode.ItemIndex];
        SelectorTamany.Enabled := rgScaleMode.ItemIndex = 2;
        ImgView.SetFocus;
end;
procedure TForm1.BeepCheckClick(Sender: TObject);
begin
        ImgView.SetFocus;
end;

procedure TForm1.FormResizen(Sender: TObject);
begin
        if ImatgeAjudant.Visible then PintarComentariAjudant;
        if Mesurador<>nil then Mesurador.Pintar;
end;

procedure TForm1.AjudantCheckClick(Sender: TObject);
begin
        if AjudantCheck.checked then PintarComentariAjudant
        else OcultarComentariAjudant;
end;

procedure TForm1.siFlatBtn1Click(Sender: TObject);
begin
    FitxerMapa:='nivells\nivell7.map';
end;

end.
