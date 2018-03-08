program MonteCarloMontyHall;

uses
  Vcl.Forms,
  MonteCarlo in 'MonteCarlo.pas',
  MonteCarloFrame in 'MonteCarloFrame.pas' {Form2},
  MyRandomGenerators in 'MyRandomGenerators.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
