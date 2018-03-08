unit MonteCarlo;

interface
uses
  MyRandomGenerators, System.Threading, System.Classes;
type
  /// <summary>
  ///   Referencia na proceduru, ktora sluzi ako event pri posielani dat do gui
  /// </summary>
  /// <param name="paChanged">
  ///   Pocet vyhier ked zmeni rozhodnutie
  /// </param>
  /// <param name="paKept">
  ///   Pocet vyhier ked nezmeni rozhodnutie
  /// </param>
  /// <param name="paIteration">
  ///   Aktualna replikacia
  /// </param>
  TOnDataWriting = reference to procedure(paChanged,paKept,paIteration: Integer);

  /// <summary>
  ///   Vseobecne jadro metody Monte Carlo
  /// </summary>
  TMonteCarlo = class
  strict private
    FWarmUp: Double;
    FReplications: Integer;
    FPointsInGraph: Integer;
    FSkipData: Integer;
    FWritingPeriod: Integer;
    FTask: ITask;
    FOnEndTask: TNotifyEvent;
  strict protected
    /// <summary>
    ///   Abstraktna procedura, volana pred zacatim replikacii
    /// </summary>
    procedure BeforeMC; virtual; abstract;
    /// <summary>
    ///   Abstractna procedura, volana kazdu iteraciu replikacie
    /// </summary>
    procedure DoMc; virtual; abstract;
    /// <summary>
    ///  Abstraktna procedura, volana kazdu iteraciu, vhodna na zobrazovanie vysledkov
    /// </summary>
    /// <param name="paId">
    ///  Konkretna iteracia
    /// </param>
    procedure ShowResults(paI: Integer); virtual; abstract;
    /// <summary>
    /// Abstraktna procedura, volana po skonceni replikacii
    /// </summary>
    procedure AfterMc; virtual; abstract;
  public
    property OnEndTask: TNotifyEvent read FOnEndTask write FOnEndTask;   //event ktory sa uskutocni na konci simulacie
    /// <summary>
    ///   Spustenie simulacie Monte Carlo
    /// </summary>
    procedure RunReplications;
    /// <summary>
    ///   Zastavenie simulacie Monte Carlo
    /// </summary>
    procedure StopReplications;
    /// <summary>
    ///   Konstruktor triedy MonteCarlo
    /// </summary>
    /// <param name="paReplications">
    ///   Pocet replikacii
    /// </param>
    constructor Create(paReplications: Integer);
  end;

  /// <summary>
  ///   Konkretna implementacia metody Monte Carlo na simulaciu Monty Hall problemu
  /// </summary>
  TMontyHallProblem = class(TMonteCarlo)
    strict private
      FDoorNumber: Integer;
      FRightChangedDecision: Integer;
      FRightKeptDecision: Integer;

      //RandomGenerator...
      FRGCar: TMyRandomRange;
      FRGPlayerFirstDoor: TMyRandomRange;
      FRGOpenFakeDoorNoCar: TMyRandomRange; //ak host netrafil auto na prve uhadnutie
      FRGOpenFakeDoorYesCar: TMyRandomRange; //ak host trafil auto na prve uhadnutie
      FRGPlayerSecondDoor: TMyRandomRange;   //ak sa rozhodne menit dvere
      FOnDataWriting: TOnDataWriting;
      /// <summary>
      ///   Funkcia na posuvanie cisel, ked sa vygeneruju uz obsadene dvere
      /// </summary>
      /// <param name="paBlockedDoor1">
      ///   Prve obsadene dvere
      /// </param>
      /// <param name="paBlockedDoor2">
      ///   Druhe obsadene dvere
      /// </param>
      /// <param name="paRNG">
      ///   Generator na generovanie nahodneho cisla
      /// </param>
      /// <returns>
      ///   Upravene cislo
      /// </returns>
      function AdjustNumber(paBlockedDoor1: Integer; paBlockedDoor2: Integer; paRNG: TMyRandomRange): Integer;

    strict protected
      procedure BeforeMC; override;
      procedure DoMc; override;
      procedure ShowResults(paI: Integer); override;
      procedure AfterMc; override;
    public
      property OnDataWriting: TOnDataWriting read FOnDataWriting write FOnDataWriting; //event, ktory vyvola funkciu ktora updatuje gui



      /// <summary>
      ///   Konstruktor triedy MontyHallProblem
      /// </summary>
      /// <param name="paReplications">
      ///   Pocet replikacii
      /// </param>
      /// <param name="paDoor">
      ///   Pocet dveri
      /// </param>
      constructor Create(paReplications: Integer; paDoor: Integer);
      /// <summary>
      ///   Destruktor triedy MontyHallProblem
      /// </summary>
      destructor Destroy; override;
  end;

implementation

uses
  Dialogs, System.SysUtils, System.Math;

{ TMonteCarlo }


constructor TMonteCarlo.Create(paReplications: Integer);
begin
  FReplications := paReplications;
end;

procedure TMonteCarlo.RunReplications;
begin
    BeforeMC;
    FTask := TTask.Create(
    procedure
    var
      I: Integer;
    begin
      for I := 1 to FReplications do
      begin
        if TTask.CurrentTask.Status = TTaskStatus.Canceled then
        begin
          if Assigned(OnEndTask) then OnEndTask(Self);
          Exit;
        end;

        if TTask.CurrentTask.Status <> TTaskStatus.Canceled then
        begin
          DoMc;
          ShowResults(I);
        end;

      end;
      AfterMc;
      if Assigned(OnEndTask) then OnEndTask(Self);
    end);
    FTask.Start;
end;

procedure TMonteCarlo.StopReplications;
begin
  if (FTask <> nil) and (FTask.Status = TTaskStatus.Running) then FTask.Cancel;
end;

{ TMontyHallProblem }

constructor TMontyHallProblem.Create(paReplications, paDoor: Integer);
begin
  inherited Create(paReplications);
  FDoorNumber := paDoor;
end;

procedure TMontyHallProblem.BeforeMC;
begin
  Randomize;
  //RandSeed := 100;
  FRGCar := TMyRandomRange.Create(Random(MaxInt), FDoorNumber);
  FRGPlayerFirstDoor := TMyRandomRange.Create(Random(MaxInt), FDoorNumber);
  FRGOpenFakeDoorNoCar := TMyRandomRange.Create(Random(MaxInt), FDoorNumber - 2);
  FRGOpenFakeDoorYesCar := TMyRandomRange.Create(Random(MaxInt),FDoorNumber - 1);
  FRGPlayerSecondDoor := TMyRandomRange.Create(Random(MaxInt), FDoorNumber - 2);
end;

destructor TMontyHallProblem.Destroy;
begin
  FreeAndNil(FRGCar);
  FreeAndNil(FRGPlayerFirstDoor);
  FreeAndNil(FRGOpenFakeDoorNoCar);
  FreeAndNil(FRGOpenFakeDoorYesCar);
  FreeAndNil(FRGPlayerSecondDoor);
  inherited;
end;

procedure TMontyHallProblem.DoMc;
var
  doorCar, doorChoice, doorOpened: Integer;
begin

  doorCar := FRGCar.getInteger;
  doorChoice := FRGPlayerFirstDoor.getInteger;

  if doorCar = doorChoice then
  begin
    doorOpened := AdjustNumber(doorCar, doorChoice, FRGOpenFakeDoorYesCar);
    Inc(FRightKeptDecision);
  end
  else doorOpened := AdjustNumber(doorCar, doorChoice, FRGOpenFakeDoorNoCar);

  doorChoice := AdjustNumber(doorOpened, doorChoice, FRGPlayerSecondDoor);

  if doorCar = doorChoice then Inc(FRightChangedDecision);
end;

procedure TMontyHallProblem.ShowResults(paI: Integer);
begin
  if Assigned(FOnDataWriting)
    then FOnDataWriting(FRightChangedDecision, FRightKeptDecision, paI);

end;

function TMontyHallProblem.AdjustNumber(paBlockedDoor1, paBlockedDoor2: Integer;
  paRNG: TMyRandomRange): Integer;
var
  number: Integer;
begin
  number := paRNG.getInteger;
  Result := number;
  if paBlockedDoor1 = paBlockedDoor2 then
  begin
    if number >= paBlockedDoor1 then Inc(number);
    Exit(number);
  end;
  if number >= Min(paBlockedDoor1, paBlockedDoor2) then
  begin
    Inc(number);
    if number = Max(paBlockedDoor1, paBlockedDoor2) then Inc(number);
    Exit(number);
  end;

end;

procedure TMontyHallProblem.AfterMc;
begin

//  FreeAndNil(FRGCar);
//  FreeAndNil(FRGPlayerFirstDoor);
//  FreeAndNil(FRGOpenFakeDoorNoCar);
//  FreeAndNil(FRGOpenFakeDoorYesCar);
//  FreeAndNil(FRGPlayerSecondDoor);
end;
end.
