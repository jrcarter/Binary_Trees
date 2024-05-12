-- Ordered binary trees without access types (not balanced)
-- Demonstration for "Avoiding Access Types" presentation at the Ada Developers Workshop of the Ada-Europe conference 2024
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Ada.Text_IO;

package body Binary_Trees is
   type Action_ID is (Find, Add, Remove);

   procedure Search (Tree : in out Tree_Holder; Value : in Element; Action : in Action_ID; Result : out Search_Result) with
      Pre => not Tree.Is_Empty;
   -- Searches for Value in Tree
   -- Makes Result the result that the Search function should return
   -- If Action = Add, performs the insertion
   -- If Action = Remove and Value is in Tree, performs the deletion

   procedure Insert (Into : in out Handle; Value : in Element) is
      Dummy : Search_Result;
      Temp  : Tree_Info;
   begin -- Insert
      if Into.Tree.Is_Empty then
         Temp.Value := Value;
         Into.Tree.Replace_Element (New_Item => Temp);

         return;
      end if;

      Search (Tree => Into.Tree, Value => Value, Action => Add, Result => Dummy);
   end Insert;

   procedure Delete (From : in out Handle; Value : in Element) is
      Dummy : Search_Result;
   begin -- Delete
      if From.Tree.Is_Empty then
         return;
      end if;

      Search (Tree => From.Tree, Value => Value, Action => Remove, Result => Dummy);
   end Delete;

   function Search (Tree : in out Handle; Value : in Element) return Search_Result is
      Result : Search_Result := (Found => False);
   begin -- Search
      if not Tree.Tree.Is_Empty then
         Search (Tree => Tree.Tree, Value => Value, Action => Find, Result => Result);
      end if;

      return Result;
   end Search;

   procedure Traverse (Tree : in Handle; Order : in Order_ID) is
      procedure Traverse (Tree : in Tree_Holder);
      -- Recursively do the actual traversal

      procedure Traverse (Tree : in Tree_Holder) is
         Info : Tree_Info;
      begin -- Traverse
         if Tree.Is_Empty then
            return;
         end if;

         Info := Tree_Info (Tree.Element);

         if Order = Pre_Order then
            Process (Item => Info.Value);
         end if;

         Traverse (Tree => Info.Left);

         if Order = In_Order then
            Process (Item => Info.Value);
         end if;

         Traverse (Tree => Info.Right);

         if Order = Post_Order then
            Process (Item => Info.Value);
         end if;
      end Traverse;
   begin -- Traverse
      Traverse (Tree => Tree.Tree);
   end Traverse;

   procedure Put (Tree : in Handle) is
      procedure Put (Tree : in Tree_Holder; Depth : in Natural);
      -- Recursively does the writing

      procedure Put (Tree : in Tree_Holder; Depth : in Natural) is
         -- Empty
      begin -- Put
         if Tree.Is_Empty then
            return;
         end if;

         Put (Tree => Tree_Info (Tree.Element).Right, Depth => Depth + 1);
         Ada.Text_IO.Put_Line (Item => (1 .. Depth => ' ') & Image (Tree_Info (Tree.Element).Value) );
         Put (Tree => Tree_Info (Tree.Element).Left, Depth => Depth + 1);
      end Put;
   begin -- Put
      Put (Tree => Tree.Tree, Depth => 0);
   end Put;

   procedure Search (Tree : in out Tree_Holder; Value : in Element; Action : in Action_ID; Result : out Search_Result) is
      Info : Tree_Info := Tree_Info (Tree.Element);

      procedure Delete (Tree : in out Tree_Holder);
      -- Perform deletion of Tree

      procedure Set_Value (Item : in out Root'Class);
      -- Sets Item.Value to Value

      procedure Delete (Tree : in out Tree_Holder) is
         procedure Move (From : in out Tree_Holder; Parent : in out Tree_Holder; Left : in Boolean);
         -- If From.Right is empty, moves the Element in From to Tree and assigns From.Left to the child of Parent indicated by
         -- Left
         -- Otherwise, calls itself with From.Right

         procedure Move (From : in out Tree_Holder; Parent : in out Tree_Holder; Left : in Boolean) is
            Local : Tree_Info := Tree_Info (From.Element);
            P_Inf : Tree_Info := Tree_Info (Parent.Element);
         begin -- Move
            if not Local.Right.Is_Empty then
               Move (From => Local.Right, Parent => From, Left => False);
            else
               Info.Value := Local.Value;
               From := Local.Left;

               if Left then
                  P_Inf.Left := Local.Left;
               else
                  P_Inf.Right := Local.Left;
               end if;

               Parent.Replace_Element (New_Item => P_Inf);
               Tree.Replace_Element (New_Item => Info);
            end if;
         end Move;
      begin -- Delete
         if Info.Right.Is_Empty then
            Tree := Info.Left;
         elsif Info.Left.Is_Empty then
            Tree := Info.Right;
         else
            Move (From => Info.Left, Parent => Tree, Left => True);
         end if;
      end Delete;

      procedure Set_Value (Item : in out Root'Class) is
         -- Empty
      begin -- Set_Value
         Tree_Info (Item).Value := Value;
      end Set_Value;

      Temp : Tree_Info;
   begin -- Search
      Result := (Found => False);

      if Info.Value = Value then
         Result := (Found => True, Value => Info.Value);

         if Action = Find then
            return;
         end if;

         if Action = Add then
            Tree.Update_Element (Process => Set_Value'Access);

            return;
         end if;

         Delete (Tree => Tree);

         return;
      end if;
      -- else keep looking

      if Value < Info.Value then
         if not Info.Left.Is_Empty then
            Search (Tree => Info.Left, Value => Value, Action => Action, Result => Result);
            Tree.Replace_Element (New_Item => Info);

            return;
         end if;
         -- else Value should be inserted as left child

         if Action = Add then
            Temp.Value := Value;
            Info.Left.Replace_Element (New_Item => Temp);
            Tree.Replace_Element (New_Item => Info);
         end if;

         return; -- Done for other actions
      end if;
      -- else Info.Value < Value

      if not Info.Right.Is_Empty then
         Search (Tree => Info.Right, Value => Value, Action => Action, Result => Result);
         Tree.Replace_Element (New_Item => Info);

         return;
      end if;
      -- else Value should be inserted as right child

      if Action = Add then
         Temp.Value := Value;
         Info.Right.Replace_Element (New_Item => Temp);
         Tree.Replace_Element (New_Item => Info);
      end if;
   end Search;
end Binary_Trees;
