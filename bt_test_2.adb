-- Test program for Binary_Trees
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Ada.Text_IO;
with Binary_Trees;

procedure Bt_Test_2 is
   package Char_Trees is new Binary_Trees (Element => Character);

   function Image (Item : in Character) return String is
      (Item & "");

   procedure Put is new Char_Trees.Put (Image => Image);

   procedure Insert (Into : in out Char_Trees.Handle; S : in String);
   -- If S /= "", inserts the middle character of S into Into, then calls itself with the substrings to the left & right of there

   procedure Process (Item : in Character);
   -- Writes Item to the current output

   procedure Write is new Char_Trees.Traverse (Process => Process);

   procedure Insert (Into : in out Char_Trees.Handle; S : in String) is
      Mid : Positive;
   begin -- Insert
      if S = "" then
         return;
      end if;

      Mid := (S'First + S'Last) / 2;
      Into.Insert (Value => S (Mid) );
      Insert (Into => Into, S => S (S'First .. Mid - 1) );
      Insert (Into => Into, S => S (Mid + 1 .. S'Last) );
   end Insert;

   procedure Process (Item : in Character) is
      -- Empty
   begin -- Process
      Ada.Text_IO.Put (Item => Item);
   end Process;

   Tree : Char_Trees.Handle;
begin -- Bt_Test_2
   Insert (Into => Tree, S => "abcdefghijklmnopqrstuvwxyz");
   Put (Tree => Tree);
   Write (Tree => Tree, Order => Char_Trees.In_Order);
end Bt_Test_2;
