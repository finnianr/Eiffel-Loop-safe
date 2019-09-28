indexing
   description: "Vectors (one dimensional matrices) of COMPLEX_DOUBLEs"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class VECTOR_COMPLEX_DOUBLE
--
--    <--row vector-->
--    e1 e2 e3 e4
--
--          ^
--    e1    |
--    e2    |
--    e3    column vector
--    e4    |
--          |
--          v
--
--    element( index )
--
--    size is height for column vector
--    size is width for row vector
--
--    first element ( top or leftmost ) is at index 1
--

inherit
   MATRIX_COMPLEX_DOUBLE
      rename item as matrix_item,
         put as matrix_put
      redefine indexed_out
      end
   DOUBLE_MATH_EXTENDED
      undefine out, is_equal, copy
      end

create {ANY}
   make, make_from, make_row, make_column, make_from_array

feature -- Initialization

   make_row(n: INTEGER) is
      require
         valid_n: n > 0
      do
         make(1, n)
      ensure
         height = 1
         width = n
      end

   make_column(n: INTEGER) is
      require
         valid_n: n > 0
      do
         make(n, 1)
      ensure
         height = n
         width = 1
      end

feature -- Access

   is_column_vector: BOOLEAN is
      do
         Result := width = 1
      end

   is_row_vector: BOOLEAN is
      do
         Result := height = 1
      end

   size, length: INTEGER is
      do
         if is_column_vector then
            Result := height
         else
            Result := width
         end
      end

   item alias "[]" (i: INTEGER): COMPLEX_DOUBLE assign put is
      local
         index: INTEGER
      do
         index := 2*i - 2
         Result.set( area.item(index), area.item(index+1) )
      end

feature -- Measurement

   norm, magnitude: DOUBLE is
      do
         Result := sqrt( squared_magnitude )
      end

   squared_magnitude: DOUBLE is
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > length
         loop
            Result := Result + ( item(i) * item(i).conjugated ).r
            i := i + 1
         end
      end

   normalized: like Current is
      local
         c: COMPLEX_DOUBLE
         i: INTEGER
         mag: DOUBLE
      do
         create Result.make_from( Current )
         mag := magnitude
         if mag /= 0.0 then
            c.set( 1.0/mag, 0.0 )
            from
               i := 1
            until
               i > length
            loop
               Result.put( item(i)*c, i )
               i := i + 1
            end
         end
      end

   normalize is
      local
         c: COMPLEX_DOUBLE
         i: INTEGER
         mag: DOUBLE
      do
         mag := magnitude
         if mag /= 0.0 then
            c.set( 1.0/mag, 0.0 )
            from
               i := 1
            until
               i > length
            loop
               put( item(i)*c, i )
               i := i + 1
            end
         end
      end

feature -- Element change

   put(v: COMPLEX_DOUBLE; i: INTEGER) is
      local
         index: INTEGER
      do
         index := 2*i - 2
         area.put(v.r, index)
         area.put(v.i, index+1)
      end

   put_real(v: DOUBLE; i: INTEGER) is
      do
         area.put(v, 2*i - 2)
      end

   put_imag(v: DOUBLE; i: INTEGER) is
      do
         area.put(v, 2*i - 1)
      end

feature -- Output

   indexed_out: STRING is
      local
         i: INTEGER
      do
         create Result.make(32)
         from
            i := 1
         until
            i > length
         loop
            Result.append( i.out )
            Result.append( "%T" )
            Result.append(item(i).out)
            Result.append("%N")
            i := i + 1
         end
      end

feature -- Basic operations

   dot, infix "#dot"(other: VECTOR_COMPLEX_DOUBLE): COMPLEX_DOUBLE is
      -- dot product of `Current' by `other'
      require
         other_not_void: other /= Void
         compatible_size: length = other.length
         compatible_row_or_column: is_row_vector = other.is_row_vector
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > length
         loop
            Result := Result + item(i) * other.item(i)
            i := i + 1
         end
      end

invariant

   is_a_vector_not_a_matrix: height = 1 or width = 1

indexing

   license: "[ 
      Eiffel Forum License, version 2
      
      1. Permission is hereby granted to use, copy, modify and/or distribute this 
      package, provided that:
         * copyright notices are retained unchanged,
         * any distribution of this package, whether modified or not, includes 
           this license text.
         
      2. Permission is hereby also granted to distribute binary programs which 
      depend on this package. If the binary program depends on a modified 
      version of this package, you are encouraged to publicly release the 
      modified version of this package.
   
   
      THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT WARRANTY. ANY EXPRESS OR 
      IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
      OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
      IN NO EVENT SHALL THE AUTHORS BE LIABLE TO ANY PARTY FOR ANY DIRECT, 
      INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
      ARISING IN ANY WAY OUT OF THE USE OF THIS PACKAGE.
      ]"

end -- class VECTOR_COMPLEX_DOUBLE
