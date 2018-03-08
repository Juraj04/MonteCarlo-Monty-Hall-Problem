unit MyRandomGenerators;

interface

type
  /// <summary>
  ///   Trieda na generovanie nahodnych hodnot
  /// </summary>
  TMyRandom = class
    protected
      FBaseSeed: Integer;
      FSeed: Integer;
    public
      /// <summary>
      ///   Funkcia na generovanie nahodnych hodnot z intervalu <0,1)
      /// </summary>
      /// <returns>
      ///   nahodne cislo
      /// </returns>
      function getDouble: Double;
      /// <summary>
      ///   Konstruktor pre triedu MyRandom
      /// </summary>
      /// <param name="paSeed">
      ///   Seed pre generovanie cisla
      /// </param>
      constructor Create(paSeed: Integer);
  end;

  /// <summary>
  ///   Trieda na generovanie nahodnych celych cisel z intervalu
  /// </summary>
  TMyRandomRange = class(TMyRandom)
    private
      FMax: Integer;
    public
      /// <summary>
      ///   Funkcia na generovanie nahodnych celych cisel z intervalu <0, FMax)
      /// </summary>
      /// <returns>
      ///   Nahodne cele cislo
      /// </returns>
      function getInteger: Integer;
      /// <summary>
      ///   Konstruktor pre triedu TMyRandomRange
      /// </summary>
      /// <param name="paSeed">
      ///   Seed pre generovanie cisla
      /// </param>
      /// <param name="paMax">
      ///   Horna hranica intervalu generovania
      /// </param>
      constructor Create(paSeed: Integer; paMax: Integer);
  end;

implementation

uses
  System.Math;
{ MyRandom }

constructor TMyRandom.Create(paSeed: Integer);
begin
  FBaseSeed := paSeed;
  FSeed := paSeed;
end;

function TMyRandom.getDouble: Double;
begin
  RandSeed := FSeed;
  Result := Random;
  FSeed := RandSeed;
end;


{ MyRandomRange }

constructor TMyRandomRange.Create(paSeed, paMax: Integer);
begin
  inherited Create(paSeed);
  FMax := paMax;
end;

function TMyRandomRange.getInteger: Integer;
begin
  RandSeed := FSeed;
  Result := Random(FMax);
  FSeed := RandSeed;
end;

end.
