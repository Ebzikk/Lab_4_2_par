with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size : Integer := 1000;
   type array_type is array(0..size - 1) of Long_Integer;
   arr : array_type;

   function add_elements (first_ind, second_ind : Integer) return Long_Integer;

   function add_elements (first_ind, second_ind : Integer) return Long_Integer is
   begin
      return arr(first_ind) + arr(second_ind);
   end add_elements;

   task type sum_task is
      entry start(first_ind, second_ind : Integer);
   end sum_task;

   task body sum_task is
      first_indx, second_indx : Integer;
   begin
      accept start(first_ind, second_ind : Integer) do
         first_indx := first_ind;
         second_indx := second_ind;
      end start;

      arr(first_indx) := add_elements(first_indx, second_indx);
      arr(second_indx) := 0;
   end sum_task;

   type sum_task_type is access sum_task;

   tasks_array : array (0..size / 2) of sum_task_type;
   current_size : Integer := arr'Length;
   last_element_ind : Integer := current_size - 1;
begin
   for i in 0..size - 1 loop
      arr(i) := long_integer(i);
   end loop;

   while current_size > 1 loop
      for i in 0..(current_size / 2 - 1) loop
         tasks_array(i) := new sum_task;
         tasks_array(i).start(i, last_element_ind);
         last_element_ind := last_element_ind - 1;
      end loop;

      current_size := current_size / 2 + (current_size rem 2);
   end loop;

   Put_Line(arr(0)'Img);
end Main;


