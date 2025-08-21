-- Ten program drukuje znaki i ich kody ASCII
-- Kompilacja: gnatmake test

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Test is

   package MyTest is
      procedure ListAscii(LowerBound: in Integer; UpperBound: in Integer);
   end MyTest;

   package body MyTest is
      procedure ListAscii(LowerBound: in Integer; UpperBound: in Integer) is
         Uc : Character := ' ';             -- zmienna
         Fl : Float;
	 T  : array(1..10) of Float;
	 I  : Integer;
	 D  : record
	        Dzien, Miesiac : Integer;
	        Rok : Integer;
              end record;
      begin
         New_Line;
         Put_Line("Kody ASCII:");
         for I in Integer range LowerBound .. UpperBound loop
            Ada.Integer_Text_IO.Put(I);   -- procedura z Ada.Integer_Text_IO
            Put(' ');    -- to jest procedura z Ada.Text_IO
            Put(Uc);
            Uc := Character'Succ(Uc);    -- kolejny znak
            New_Line;
         end loop;
         -- tylko test
         Fl := 1.1 * 0.1 + 1.0e-2;  -- po kropce i przed zawsze cyfra
	 T(0) := 0;
	 for I in 1 .. 10 loop
	    T(I) := T(I) * I * I;
	 end loop;
	 D.Dzien := 1;
	 D.Miesiac := D. Dzien * 10;
	 D.Rok := 2018;
      end ListAscii;

   end MyTest;

   use MyTest;

   FromASCII : constant Integer := 32;
   ToASCII : constant Integer := 127;


begin
   if FromAscii <= ToAscii then
      ListAscii(FromAscii, ToAscii);
   else
      Put_Line("Figa");
      New_Line;
   end if;
end Test;
