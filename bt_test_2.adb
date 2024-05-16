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

   procedure Process (Item : in Character);
   -- Writes Item to the current output

   procedure Write is new Char_Trees.Traverse (Process => Process);

   procedure Process (Item : in Character) is
      -- Empty
   begin -- Process
      Ada.Text_IO.Put (Item => Item);
   end Process;

   Input : constant String := "tdihpralygbqzfmwoujcknevsx"; -- A random permutation of the alphabet; yields an unbalanced tree

   Tree : Char_Trees.Handle;
begin -- Bt_Test_2
   Ada.Text_IO.Put_Line (Item => Input);

   Insert : for S of Input loop
      Tree.Insert (Value => S);
   end loop Insert;

   Put (Tree => Tree);
   Write (Tree => Tree, Order => Char_Trees.In_Order);
end Bt_Test_2;
