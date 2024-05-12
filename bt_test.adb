-- Test program for Binary_Trees
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Ada.Text_IO;
with Binary_Trees;

procedure Bt_Test is
   package Int_Trees is new Binary_Trees (Element => Positive);
   procedure Put is new Int_Trees.Put (Image => Integer'Image);

   Tree : Int_Trees.Handle;
begin -- Bt_Test
   Tree.Insert (Value => 10);
   Tree.Insert (Value =>  5);
   Tree.Insert (Value => 15);
   Tree.Insert (Value =>  3);
   Tree.Insert (Value => 13);
   Tree.Insert (Value =>  8);
   Tree.Insert (Value => 18);
   Put (Tree => Tree);
   Ada.Text_IO.Skip_Line;
   Ada.Text_IO.Put_Line (Item => " 4 is " & (if Tree.Search ( 4).Found then "" else "not ") & "found");
   Ada.Text_IO.Put_Line (Item => " 5 is " & (if Tree.Search ( 5).Found then "" else "not ") & "found");
   Ada.Text_IO.Put_Line (Item => "14 is " & (if Tree.Search (14).Found then "" else "not ") & "found");
   Ada.Text_IO.Put_Line (Item => "15 is " & (if Tree.Search (15).Found then "" else "not ") & "found");
   Ada.Text_IO.Skip_Line;
   Tree.Delete (Value => 10);
   Put (Tree => Tree);
   Ada.Text_IO.Skip_Line;
   Tree.Delete (Value => 8);
   Put (Tree => Tree);
   Ada.Text_IO.Skip_Line;
   Tree.Delete (Value => 5);
   Put (Tree => Tree);
   Ada.Text_IO.Skip_Line;
   Tree.Delete (Value => 3);
   Put (Tree => Tree);
end Bt_Test;
