-- Ordered binary trees without access types (not balanced)
-- Demonstration for "Avoiding Access Types" presentation at the Ada Developers Workshop of the Ada-Europe conference 2024
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

private with Ada.Containers.Indefinite_Holders;

generic -- Binary_Trees
   type Element is private;

   with function "<" (Left : in Element; Right : in Element) return Boolean is <>;
   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;
package Binary_Trees is
   type Handle is tagged private;
   -- Initial value: an empty tree

   procedure Insert (Into : in out Handle; Value : in Element);
   -- Inserts Value into Into
   -- If Into already has an Element = Value, replaces the stored value with Value
   -- Items are inserted in "<" order; if Value < the Element in a node, it is inserted in the Left subtree;
   -- otherwise in the Right

   procedure Delete (From : in out Handle; Value : in Element);
   -- If From has an Element = Value, deletes it, preserving ordering of the remaining Elements
   -- Otherwise, has no effect

   type Search_Result (Found : Boolean := False) is record
      case Found is
      when False =>
         null;
      when True =>
         Value : Element;
      end case;
   end record;

   function Search (Tree : in out Handle; Value : in Element) return Search_Result;
   -- If Tree has no Element = Value, returns (Found => False)
   -- Otherwise, the return value has Found => True and Value set to the found value

   type Order_ID is (Pre_Order, In_Order, Post_Order);

   generic -- Traverse
      with procedure Process (Item : in Element);
   procedure Traverse (Tree : in Handle; Order : in Order_ID);
   -- Traverses Tree in Order, applying Process to each Element in Tree

   generic -- Put
      with function Image (Item : in Element) return String;
   procedure Put (Tree : in Handle);
   -- Writes an image of the tree to the current output
private -- Binary_Trees
   type Root is abstract tagged null record;

   function Equal (Left : in Root'Class; Right : in Root'Class) return Boolean is
      (Left = Right);

   package Tree_Holders is new Ada.Containers.Indefinite_Holders (Element_Type => Root'Class);
   subtype Tree_Holder is Tree_Holders.Holder;

   type Tree_Info is new Root with record
      Value : Element;
      Left  : Tree_Holder;
      Right : Tree_Holder;
   end record;

   type Handle is tagged record
      Tree : Tree_Holder;
   end record;
end Binary_Trees;
