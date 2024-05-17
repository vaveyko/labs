Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, System.DateUtils,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
    Vcl.MPlayer,
    Vcl.Imaging.Pngimage;

Type
    TMainForm = Class(TForm)
        ClockTimer: TTimer;
        KukushkaImage: TImage;
        MediaPlayer1: TMediaPlayer;
        StartButton: TButton;
        Procedure ClockTimerTimer(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure StartButtonClick(Sender: TObject);
        Procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;

    AngleSec: Real;
    AngleMinute: Real;
    AngleHour: Real;

    SecCount: Integer = 0;
    MinuteCount: Integer = 0;

    Bitmap: TBitmap;

    CurrSec: Integer;

    CenterX: Integer = 0;
    CenterY: Integer = 0;

Const
    SEC_WIDTH = 5;
    SEC_COLOR = ClRed;
    SEC_LEN = 180;

    MINUTE_WIDTH = 12;
    MINUTE_COLOR = ClGray;
    MINUTE_LEN = 150;

    HOUR_WIDTH = 20;
    HOUR_COLOR = ClBlack;
    HOUR_LEN = 120;

    CLOCK_SIZE = 215;

Implementation

{$R *.dfm}

Procedure DrawClockFace(Canvas: TCanvas; X, Y: Integer);
Var
    Angle: Real;
    I, NewX, NewY: Integer;
Begin
    Canvas.Pen.Width := 6;
    Canvas.Ellipse(X - CLOCK_SIZE, Y - CLOCK_SIZE, X + CLOCK_SIZE,
      Y + CLOCK_SIZE);

    Angle := -Pi / 2;
    For I := 1 To 12 Do
    Begin
        Canvas.Pen.Width := 15;
        Angle := Angle + Pi / 6;
        NewX := X + Trunc((CLOCK_SIZE - 5) * Cos(Angle));
        NewY := Y + Trunc((CLOCK_SIZE - 5) * Sin(Angle));
        Canvas.MoveTo(NewX, NewY);
        Canvas.LineTo(NewX, NewY);
    End;
End;

Procedure DrawLine(Canvas: TCanvas; X, Y, Len, Width: Integer; Color: TColor;
  Angle: Real);
Begin
    With Canvas Do
    Begin
        Canvas.MoveTo(X, Y);

        Canvas.Pen.Color := Color;
        Canvas.Pen.Width := Width;
        Canvas.LineTo(X + Trunc(Len * Cos(Angle)), Y + Trunc(Len * Sin(Angle)));
    End;
End;

Procedure DrawHoleClock(CenterX, CenterY: Integer);
Begin
    With Bitmap Do
    Begin
        DrawClockFace(Canvas, CenterX, CenterY);

        DrawLine(Canvas, CenterX, CenterY, HOUR_LEN, HOUR_WIDTH, HOUR_COLOR,
          AngleHour);
        DrawLine(Canvas, CenterX, CenterY, MINUTE_LEN, MINUTE_WIDTH,
          MINUTE_COLOR, AngleMinute);
        DrawLine(Canvas, CenterX, CenterY, SEC_LEN, SEC_WIDTH, SEC_COLOR,
          AngleSec);
    End;
End;

Function CreateBitmap(): TBitmap;
Begin
    BitMap := TBitmap.Create();
    BitMap.Height := MainForm.ClientHeight;
    BitMap.Width := MainForm.ClientWidth;
    CreateBitmap := Bitmap;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    AngleSec := -Pi / 2;
    AngleMinute := -Pi / 2;
    AngleHour := -Pi / 2;
End;

procedure TMainForm.FormPaint(Sender: TObject);
begin
    Bitmap := CreateBitmap();
    DrawHoleClock(MainForm.ClientWidth Div 2, MainForm.ClientHeight Div 2);
    MainForm.Canvas.Draw(0, 0, Bitmap);
end;

Procedure TMainForm.FormResize(Sender: TObject);
Begin
    CenterX := MainForm.ClientWidth Div 2;
    CenterY := MainForm.ClientHeight Div 2;
    With StartButton Do
    Begin
        Left := (MainForm.ClientWidth - Width) Div 2;
        Top := MainForm.ClientHeight - 50;
    End;
End;

Procedure TMainForm.StartButtonClick(Sender: TObject);
Begin
    SecCount := 0;
    MinuteCount := 0;
    AngleSec := -Pi / 2;
    AngleMinute := -Pi / 2;
    AngleHour := -Pi / 2;
    CurrSec := SecondOf(Now);
    With Mediaplayer1 Do
    Begin
        Filename := 'Kukushka.mp3';
        Open;
    End;
    ClockTimer.Interval := 1;
End;

Procedure CheckSec();
Begin
    If (CurrSec <> SecondOf(Now)) Then
    Begin
        Inc(SecCount);
        CurrSec := SecondOf(Now);
        AngleSec := AngleSec + Pi / 180 * 6;
        If SecCount = 60 Then
        Begin
            SecCount := 0;
            AngleSec := -Pi / 2;
            Inc(MinuteCount);
            AngleMinute := AngleMinute + Pi / 180 * 6;
            AngleHour := AngleHour + Pi / 180 * 360 / 12 / 60;
            If (MinuteCount = 60) Then
                MinuteCount := 0;
        End;
    End;
End;

Procedure TMainForm.ClockTimerTimer(Sender: TObject);
Var
    BitMap: TBitmap;
Begin

    BitMap := CreateBitmap();

    With Bitmap Do
    Begin
        DrawClockFace(Canvas, CenterX, CenterY);

        DrawLine(Canvas, CenterX, CenterY, HOUR_LEN, HOUR_WIDTH, HOUR_COLOR,
          AngleHour);
        DrawLine(Canvas, CenterX, CenterY, MINUTE_LEN, MINUTE_WIDTH,
          MINUTE_COLOR, AngleMinute);
        DrawLine(Canvas, CenterX, CenterY, SEC_LEN, SEC_WIDTH, SEC_COLOR,
          AngleSec);

        If (SecCount Mod 15 = 0) Then
            MediaPlayer1.Play();

        If (MediaPlayer1.Mode = MpPlaying) Then
            Canvas.Draw(-350, 0, KukushkaImage.Picture.Graphic);

        CheckSec();
    End;

    MainForm.Canvas.Draw(0, 0, BitMap);
    BitMap.Free();
End;

End.
