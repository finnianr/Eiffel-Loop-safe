note
	description: "[
		Java Object Request Broker
		
		Adapted from ES Eiffel2Java JNI_Environment class.
		Holds information about JNI environment. Potentially many JNI environments can exists at once,
		but more than one was never tested
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	JNI_ENVIRONMENT

inherit
	ANY
	 	redefine
	 		default_create
	 	end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create java_class_table.make (1)
			create java_object_table.make (1)
			create reference_counts.make (100)
			debug ("jni")
				create object_names.make (100)
				object_names.compare_objects
			end
			create jvm
		end
feature -- Element change

	open (libjvm_path: READABLE_STRING_8; a_class_path: STRING)
			--
		do
			jvm.open (libjvm_path, a_class_path)
		end

feature -- Access

	object_count: INTEGER
			--
		do
			from reference_counts.start until reference_counts.after loop
				if reference_counts.key_for_iteration /= Default_pointer then
					Result := Result + reference_counts.item_for_iteration.item
				end
				reference_counts.forth
			end
		end

	referenced_objects: ARRAYED_LIST [POINTER]
			--
		do
			create Result.make (reference_counts.count)
			from reference_counts.start until reference_counts.after loop
				if reference_counts.key_for_iteration /= Default_pointer
					and then  reference_counts.item_for_iteration.item > 0
				then
					Result.extend (reference_counts.key_for_iteration)
				end
				reference_counts.forth
			end
		end

	object_names: HASH_TABLE [STRING, POINTER]

feature -- Status query

	is_open: BOOLEAN
		do
			Result := jvm.is_open
		end

feature {JAVA_ENTITY} -- Java reference management

	increment_object_ref_count (java_object_id: POINTER)
			--
		do
			change_object_ref_count_by (java_object_id, 1)
		end

	decrement_object_ref_count (java_object_id: POINTER)
			--
		do
			change_object_ref_count_by (java_object_id, -1)
		end

	change_object_ref_count_by (java_object_id: POINTER; delta: INTEGER)
			--
		require
			valid_java_object_id: java_object_id /= Default_pointer
		local
			count: INTEGER_REF
		do
			reference_counts.search (java_object_id)
			if reference_counts.found then
				count := reference_counts.found_item
				count.set_item (count.item + delta)
			else
				create count
				count.set_item (1)
				reference_counts.extend (count, java_object_id)
			end
			check
				count_not_negative: count.item > -1
			end
			if count.item = 0 then
				reference_counts.remove (java_object_id)
				delete_local_ref (java_object_id)
			end
		end

	reference_counts: HASH_TABLE [INTEGER_REF, POINTER]

feature -- Disposal

	delete_local_ref (java_object_id: POINTER)
			-- Added FJR March 2005
		do
			c_delete_local_ref (jvm.envp, java_object_id)
			debug ("jni")
				check_for_exceptions
			end
		end

	close_jvm
			-- Destroy the JVM and reclaim its resources
		do
			jvm.destroy_vm
		end

feature -- Exception mechanism

	check_for_exceptions
			-- Check if a Java exception occurred, raise Java exception occurred
		local
			p, null: POINTER
			l_exception: EXCEPTIONS
		do
			p := c_exception_occurred (jvm.envp)
			if p /= null then
				c_exception_describe (jvm.envp)
				c_exception_clear (jvm.envp)
				create l_exception
				l_exception.raise ("Java Exception occurred")
			end
		end

	throw_java_exception (jthrowable: JAVA_OBJECT)
			-- throw the exception 'jthrowable' (must be a java.lang.Throwable object)
		do
			c_throw_java_exception (jvm.envp, jthrowable.java_object_id)
		end

	throw_custom_exception (jclass: JAVA_CLASS; msg: STRING)
			-- Constructs an exception object from the specified class 'jclass'
			-- with the message specified by 'msg' and causes that exception
			-- to be thrown.
		local
			l_msg_to_c: C_STRING
		do
			create l_msg_to_c.make (msg)
			c_throw_custom_exception (jvm.envp, jclass.java_class_id, l_msg_to_c.item)
		end

feature  -- Thread Mechanism

	attach_current_thread
			-- Attach `jvm' to current thread.
		do
			jvm.attach_current_thread
		end

	detach_current_thread
			-- Detach `jvm' from current thread.
		do
			jvm.detach_current_thread
		end

feature {JAVA_CLASS, JAVA_OBJECT, JAVA_ARGS, JAVA_ARRAY}

	java_object_table: HASH_TABLE [JAVA_OBJECT, POINTER]
			-- Table of Eiffel objects representing Java objects

feature {NONE} -- Access

	jvm: JAVA_VM
			-- JVM that goes with the JNI enviroment

	java_class_table: HASH_TABLE [JAVA_CLASS, POINTER]
			-- Table of classes we have loaded - keyed by java_class_id

feature -- Reflection

	find_class (name: STRING): JAVA_CLASS
			-- Load in the Java class with the given name.
			-- Namespace if any are delimited by `/'
		require
			name_valid: name /= Void
		local
			clsp: POINTER
			l_name_to_c: C_STRING
		do
			create l_name_to_c.make (name)
			clsp := c_jni_find_class (jvm.envp, l_name_to_c.item);
			create Result.make (clsp) -- Added FJR March 2005

			debug ("jni")
				check_for_exceptions
			end
--			Changed FJR March 2005
--			Result := find_class_by_pointer (clsp)
		end

	find_class_by_pointer (classp: POINTER): JAVA_CLASS
			-- Get a Java class Eiffel proxy given pointer to the
			-- Java class. Create a new one if needed
		require
			classp_not_null: classp /= default_pointer
		do
			Result := java_class_table.item (classp)
			if Result = Void then
				if classp /= default_pointer then
					create Result.make (classp)
					java_class_table.put (Result, classp)
				end
			end
		end

	find_class_pointer (name: STRING): POINTER
			-- Find class pointer only (used during creation in descendants).
			-- Namespace if any are delimited by `/'
		local
			l_name_to_c: C_STRING
		do
			create l_name_to_c.make (name)
			Result := c_jni_find_class (jvm.envp, l_name_to_c.item);
			debug ("jni")
				check_for_exceptions
			end
		end

	get_class (an_obj: POINTER): POINTER
			-- Get associated class of `an_obj'.
		require
			an_obj_not_null: an_obj /= default_pointer
		do
			Result := c_get_class (jvm.envp, an_obj)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_method_id (cls: POINTER; mname: POINTER; sig: POINTER): POINTER
			-- Find feature `mname' in class `cls' with signature `sig'.
		do
			Result := c_get_method_id (jvm.envp, cls, mname, sig)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_method_id (cls: POINTER; mname: POINTER; sig: POINTER): POINTER
			-- Find static feature `mname' in class `cls' with signature `sig'.
		do
			Result := c_get_static_method_id (jvm.envp, cls, mname, sig)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_field_id (cls: POINTER; fname, sig: POINTER): POINTER
			-- Find attribute `mname' in class `cls' with signature `sig'.
		do
			Result := c_get_field_id (jvm.envp, cls, fname, sig)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_field_id (cls: POINTER; fname, sig: POINTER): POINTER
			-- Find static attribute `mname' in class `cls' with signature `sig'.
		do
			Result := c_get_static_field_id (jvm.envp, cls, fname, sig)
			debug ("jni")
				check_for_exceptions
			end
		end

feature -- Comparison
	is_assignable_from (cls_1, cls_2: POINTER): BOOLEAN
			-- Determines whether a java object of type cls_2 can be safely cast to cls_1
		do
			Result := c_is_assignable_from (jvm.envp, cls_1, cls_2)
		end

feature -- Object creation

	new_object (cls: POINTER; constructor: POINTER; args: POINTER): POINTER
			-- Create a new instance of `cls' using feature `constructor' and
			-- arguments `args'.
		do
			Result := c_new_object (jvm.envp, cls, constructor, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_string (v: STRING): POINTER
			-- Create a new java string from `v'.
		local
			l_str: C_STRING
		do
			if v /= Void then
				create l_str.make (v)
				Result := c_new_string_utf (jvm.envp, l_str.item)
				debug ("jni")
					check_for_exceptions
				end
			end
		end

	new_boolean_array (a_size: INTEGER): POINTER
			-- Create a new array of boolean.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_boolean_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_char_array (a_size: INTEGER): POINTER
			-- Create a new array of char.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_char_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_int_array (a_size: INTEGER): POINTER
			-- Create a new array of int.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_int_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_long_array (a_size: INTEGER): POINTER
			-- Create a new array of long.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_long_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_double_array (a_size: INTEGER): POINTER
			-- Create a new array of double.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_double_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_float_array (a_size: INTEGER): POINTER
			-- Create a new array of float.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_float_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_short_array (a_size: INTEGER): POINTER
			-- Create a new array of short.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_short_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_byte_array (a_size: INTEGER): POINTER
			-- Create a new array of byte.
		require
			a_size_positive: a_size >= 0
		do
			Result := c_new_byte_array (jvm.envp, a_size)
			debug ("jni")
				check_for_exceptions
			end
		end

	new_object_array (a_size: INTEGER; element_class: POINTER; init_elt: POINTER): POINTER
			-- Create a new array of reference of type `element_class'.
		require
			a_size_positive: a_size >= 0
			element_class_not_null: element_class /= default_pointer
		do
			Result := c_new_object_array (jvm.envp, a_size, element_class, init_elt)
			debug ("jni")
				check_for_exceptions
			end
		end

feature -- Calls

	call_void_method (oid: POINTER; mid: POINTER; args: POINTER)
			-- Call function `mid' with argument `args' on object `oid'.
		do
			c_call_void_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_boolean_method (oid: POINTER; mid: POINTER; args: POINTER): BOOLEAN
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_boolean_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_byte_method (oid: POINTER; mid: POINTER; args: POINTER): INTEGER_8
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_byte_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_char_method (oid: POINTER; mid: POINTER; args: POINTER): CHARACTER
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_char_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_short_method (oid: POINTER; mid: POINTER; args: POINTER): INTEGER_16
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_short_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_int_method (oid: POINTER; mid: POINTER; args: POINTER): INTEGER
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_int_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_long_method (oid: POINTER; mid: POINTER; args: POINTER): INTEGER_64
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_long_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_float_method (oid: POINTER; mid: POINTER; args: POINTER): REAL
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_float_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_double_method (oid: POINTER; mid: POINTER; args: POINTER): DOUBLE
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_double_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_object_method (oid: POINTER; mid: POINTER; argsp: POINTER): POINTER
			-- Call function `mid' with argument `args' on object `oid'.
		do
			Result := c_call_object_method (jvm.envp, oid, mid, argsp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_string_method (oid: POINTER; mid: POINTER; args: POINTER): STRING
			-- Call function `mid' with argument `args' on object `oid'.
		local
			p, null: POINTER
		do
			p := c_call_object_method (jvm.envp, oid, mid, args)
			debug ("jni")
				check_for_exceptions
			end
			if p /= null then
				Result := get_string (p)
			end
		end

feature -- Static calls

	call_static_void_method (cls: POINTER; mid: POINTER; argp: POINTER)
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			c_call_static_void_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_byte_method (cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_8
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_byte_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_boolean_method (cls: POINTER; mid: POINTER; argp: POINTER): BOOLEAN
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_boolean_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_char_method (cls: POINTER; mid: POINTER; argp: POINTER): CHARACTER
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_char_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_short_method (cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_16
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_short_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_int_method (cls: POINTER; mid: POINTER; argp: POINTER): INTEGER
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_int_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_long_method (cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_64
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_long_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_float_method (cls: POINTER; mid: POINTER; argp: POINTER): REAL
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_float_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_double_method (cls: POINTER; mid: POINTER; argp: POINTER): DOUBLE
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_double_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_object_method (cls: POINTER; mid: POINTER; argp: POINTER): POINTER
			-- Call static feature `mid' defined in class `cls' with arguments `argp'.
		do
			Result := c_call_static_object_method (jvm.envp, cls, mid, argp)
			debug ("jni")
				check_for_exceptions
			end
		end

	call_static_string_method (cls: POINTER; mid: POINTER; argsp: POINTER): STRING
		require
			cls_not_null: cls /= default_pointer
			mid_not_null: mid /= default_pointer
			argsp_not_null: argsp /= default_pointer
		local
			l_str, null: POINTER
		do
			l_str := c_call_static_object_method (jvm.envp, cls, mid, argsp)
			debug ("jni")
				check_for_exceptions
			end
			if l_str /= null then
				Result := get_string (l_str)
			end
		end

feature -- Field Access

	get_integer_field (oid: POINTER; fid: POINTER): INTEGER
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_integer_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_long_field (oid: POINTER; fid: POINTER): INTEGER_64
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_long_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_boolean_field (oid: POINTER; fid: POINTER): BOOLEAN
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_boolean_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_char_field (oid: POINTER; fid: POINTER): CHARACTER
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_char_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_float_field (oid: POINTER; fid: POINTER): REAL
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_float_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_double_field (oid: POINTER; fid: POINTER): DOUBLE
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_double_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_byte_field (oid: POINTER; fid: POINTER): INTEGER_8
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_byte_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_short_field (oid: POINTER; fid: POINTER): INTEGER_16
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_short_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_object_field (oid: POINTER; fid: POINTER): POINTER
			-- Value of attribute `fid' in object `oid'.
		do
			Result := c_get_object_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_string_field (oid: POINTER; fid: POINTER): STRING
		require
			oid_not_null: oid /= default_pointer
			fid_not_null: fid /= default_pointer
		local
			l_str, null: POINTER
		do
			l_str := c_get_object_field (jvm.envp, oid, fid)
			debug ("jni")
				check_for_exceptions
			end
			if l_str /= null then
				Result := get_string (l_str)
			end
		end

feature -- Static Field access

	get_static_integer_field (cls: POINTER; fid: POINTER): INTEGER
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_integer_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_long_field (cls: POINTER; fid: POINTER): INTEGER_64
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_long_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_boolean_field (cls: POINTER; fid: POINTER): BOOLEAN
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_boolean_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_char_field (cls: POINTER; fid: POINTER): CHARACTER
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_char_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_float_field (cls: POINTER; fid: POINTER): REAL
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_float_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_double_field (cls: POINTER; fid: POINTER): DOUBLE
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_double_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_byte_field (cls: POINTER; fid: POINTER): INTEGER_8
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_byte_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_short_field (cls: POINTER; fid: POINTER): INTEGER_16
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_short_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_object_field (cls: POINTER; fid: POINTER): POINTER
			-- Value of attribute `fid' in static `cls'.
		do
			Result := c_get_static_object_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_static_string_field (cls: POINTER; fid: POINTER): STRING
		require
			cls_not_null: cls /= default_pointer
			fid_not_null: fid /= default_pointer
		local
			l_str, null: POINTER
		do
			l_str := c_get_static_object_field (jvm.envp, cls, fid)
			debug ("jni")
				check_for_exceptions
			end
			if l_str /= null then
				Result := get_string (l_str)
			end
		end

feature -- Field setting

	set_integer_field (oid: POINTER; fid: POINTER; v: INTEGER)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_integer_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_long_field (oid: POINTER; fid: POINTER; v: INTEGER_64)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_long_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_object_field (oid: POINTER; fid: POINTER; v: POINTER)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_object_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_boolean_field (oid: POINTER; fid: POINTER; v: BOOLEAN)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_boolean_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_char_field (oid: POINTER; fid: POINTER; v: CHARACTER)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_char_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_float_field (oid: POINTER; fid: POINTER; v: REAL)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_float_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_double_field (oid: POINTER; fid: POINTER; v: DOUBLE)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_double_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_byte_field (oid: POINTER; fid: POINTER; v: INTEGER_8)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_byte_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_short_field (oid: POINTER; fid: POINTER; v: INTEGER_16)
			-- Set attribute `fid' with value `v' in object `oid'.
		do
			c_set_short_field (jvm.envp, oid, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_string_field (oid: POINTER; fid: POINTER;  v: STRING)
		require
			oid_not_null: oid /= default_pointer
			fid_not_null: fid /= default_pointer
			v_not_void: v /= Void
		local
			p: POINTER
			l_str: C_STRING
		do
			create l_str.make (v)
			p := c_new_string_utf (jvm.envp, l_str.item)
			c_set_object_field (jvm.envp, oid, fid, p)
		ensure
			string_field_set: v.is_equal (get_string_field (oid, fid))
		end

feature -- Static field setting

	set_static_integer_field (cls: POINTER; fid: POINTER; v: INTEGER)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_integer_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_long_field (cls: POINTER; fid: POINTER; v: INTEGER_64)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_long_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_object_field (cls: POINTER; fid: POINTER; v: POINTER)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_object_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_boolean_field (cls: POINTER; fid: POINTER; v: BOOLEAN)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_boolean_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_char_field (cls: POINTER; fid: POINTER; v: CHARACTER)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_char_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_float_field (cls: POINTER; fid: POINTER; v: REAL)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_float_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_double_field (cls: POINTER; fid: POINTER; v: DOUBLE)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_double_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_byte_field (cls: POINTER; fid: POINTER; v: INTEGER_8)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_byte_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_short_field (cls: POINTER; fid: POINTER; v: INTEGER_16)
			-- Set attribute `fid' with value `v' in class `cls'.
		do
			c_set_static_short_field (jvm.envp, cls, fid, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_static_string_field (cls: POINTER; fid: POINTER; value: STRING)
		require
			cls_not_null: cls /= default_pointer
			fid_not_null: fid /= default_pointer
			value_not_void: value /= Void
		local
			p: POINTER
			l_str: C_STRING
		do
			create l_str.make (value)
			p := c_new_string_utf (jvm.envp, l_str.item)
			c_set_static_object_field (jvm.envp, cls, fid, p)
			debug ("jni")
				check_for_exceptions
			end
		ensure
			static_string_field_set: value.is_equal (get_static_string_field (cls, fid))
		end

feature -- Array manipulation

	get_array_length (jarray: POINTER): INTEGER
			-- Number of elements in `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_array_length (jvm.envp, jarray)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_object_array_element (jarray: POINTER; indx: INTEGER): POINTER
			-- Item at index `indx' in `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_object_array_element (jvm.envp, jarray, indx)
			debug ("jni")
				check_for_exceptions
			end
		end

	set_object_array_element (jarray: POINTER; indx: INTEGER; v: POINTER)
			-- Put `v' at index `indx' in `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			c_set_object_array_element (jvm.envp, jarray, indx, v)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_char_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_char_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_char_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_char_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_int_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_int_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_int_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_int_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_long_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_long_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_long_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_long_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_boolean_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_boolean_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_boolean_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_boolean_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_short_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_short_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_short_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_short_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_byte_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_byte_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_byte_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_byte_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_float_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_float_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_float_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_float_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

	get_double_array_elements (jarray: POINTER; is_copy: POINTER): POINTER
			-- Acquire area of `jarray'.
		require
			jarray_not_null: jarray /= default_pointer
		do
			Result := c_get_double_array_elements (jvm.envp, jarray, is_copy)
			debug ("jni")
				check_for_exceptions
			end
		end

	release_double_array_elements (jarray: POINTER; elts: POINTER; mode: INTEGER)
			-- Release area of `jarray' pointed by `elts'.
		require
			jarray_not_null: jarray /= default_pointer
			elts_not_null: elts /= default_pointer
		do
			c_release_double_array_elements (jvm.envp, jarray, elts, mode)
			debug ("jni")
				check_for_exceptions
			end
		end

feature -- Convenience

	get_string (a_str: POINTER): STRING
			-- Create new instance of STRING using `a_str'.
		require
			a_str_not_null: a_str /= default_pointer
		local
			l_str: C_STRING
			l_str_ptr, null: POINTER
		do
			l_str_ptr := c_get_string_utf_chars (jvm.envp, a_str, null)
			create l_str.make_by_pointer (l_str_ptr)
			debug ("jni")
				check_for_exceptions
			end
			Result := l_str.string
			c_release_string_utf_chars (jvm.envp, a_str, l_str_ptr)
			debug ("jni")
				check_for_exceptions
			end
		end

feature {NONE} -- Disposal

	c_delete_local_ref (env: POINTER; oid: POINTER)
			-- Added FJR March 2005
		external
			"C++ JNIEnv signature (jobject) use %"jni.h%""
		alias
			"DeleteLocalRef"
		end

feature {NONE} -- String manipulation

	c_get_string_utf_chars (env: POINTER; js, is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jstring, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetStringUTFChars"
		end

	c_release_string_utf_chars (env: POINTER; js, chars: POINTER)
		external
			"C++ JNIEnv signature (jstring, char *) use %"jni.h%""
		alias
			"ReleaseStringUTFChars"
		end

	c_new_string_utf (env: POINTER; chars: POINTER): POINTER
		external
			"C++ JNIEnv signature (char *): EIF_POINTER use %"jni.h%""
		alias
			"NewStringUTF"
		end

feature {NONE} -- Exceptions checking

	c_exception_occurred (env: POINTER): POINTER
		external
			"C++ JNIEnv use %"jni.h%""
		alias
			"ExceptionOccurred"
		end

	c_exception_describe (env: POINTER)
		external
			"C++ JNIEnv use %"jni.h%""
		alias
			"ExceptionDescribe"
		end

	c_exception_clear (env: POINTER)
		external
			"C++ JNIEnv use %"jni.h%""
		alias
			"ExceptionClear"
		end

feature {NONE} -- Comparison

	c_is_assignable_from (env: POINTER; cls_1, cls_2: POINTER): BOOLEAN
			-- Determines whether a java object of cls_2 can be safely cast to cls_1
		external
			"C++ JNIEnv signature (jclass, jclass): EIF_BOOLEAN use %"jni.h%""
		alias
			"IsAssignableFrom"
		end

feature {NONE} -- object creation

	c_new_object (env: POINTER; cls: POINTER; constructor: POINTER; args: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_POINTER use %"jni.h%""
		alias
			"NewObjectA"
		end

feature {NONE} -- dynamic method calls

	c_get_method_id (env: POINTER; cls: POINTER; mname: POINTER; sig: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, char *, char *): EIF_POINTER use %"jni.h%""
		alias
			"GetMethodID"
		end

	c_call_void_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER)
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *) use %"jni.h%""
		alias
			"CallVoidMethodA"
		end

	c_call_boolean_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): BOOLEAN
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_BOOLEAN use %"jni.h%""
		alias
			"CallBooleanMethodA"
		end

	c_call_byte_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): INTEGER_8
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_INTEGER_8 use %"jni.h%""
		alias
			"CallByteMethodA"
		end

	c_call_char_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): CHARACTER
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *):EIF_CHARACTER use %"jni.h%""
		alias
			"CallCharMethodA"
		end

	c_call_short_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): INTEGER_16
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_INTEGER_16 use %"jni.h%""
		alias
			"CallShortMethodA"
		end

	c_call_int_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): INTEGER
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_INTEGER use %"jni.h%""
		alias
			"CallIntMethodA"
		end

	c_call_long_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): INTEGER_64
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_INTEGER_64 use %"jni.h%""
		alias
			"CallLongMethodA"
		end

	c_call_float_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): REAL
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_REAL use %"jni.h%""
		alias
			"CallFloatMethodA"
		end

	c_call_double_method (env: POINTER; oid: POINTER; mid: POINTER; args: POINTER): DOUBLE
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_DOUBLE use %"jni.h%""
		alias
			"CallDoubleMethodA"
		end

	c_call_object_method (lenv: POINTER; oid: POINTER; mid: POINTER; argsp: POINTER): POINTER
		external
			"C++ JNIEnv signature (jobject, jmethodID, jvalue *): EIF_POINTER use %"jni.h%""
		alias
			"CallObjectMethodA"
		end

feature {NONE} -- dynamic attribute access

	c_get_field_id (env: POINTER; cls: POINTER; fname, sig: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, char *, char *): EIF_POINTER use %"jni.h%""
		alias
			"GetFieldID"
		end

	c_get_static_field_id (env: POINTER; cls: POINTER; fname, sig: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, char *, char *): EIF_POINTER use %"jni.h%""
		alias
			"GetStaticFieldID"
		end

	c_get_integer_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_INTEGER use %"jni.h%""
		alias
			"GetIntField"
		end

	c_get_static_integer_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_INTEGER use %"jni.h%""
		alias
			"GetStaticIntField"
		end

	c_get_long_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_64
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_INTEGER_64 use %"jni.h%""
		alias
			"GetLongField"
		end

	c_get_static_long_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_64
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_INTEGER_64 use %"jni.h%""
		alias
			"GetStaticLongField"
		end


	c_get_boolean_field (env: POINTER; oid: POINTER; fid: POINTER): BOOLEAN
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_BOOLEAN use %"jni.h%""
		alias
			"GetBooleanField"
		end

	c_get_static_boolean_field (env: POINTER; oid: POINTER; fid: POINTER): BOOLEAN
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_BOOLEAN use %"jni.h%""
		alias
			"GetStaticBooleanField"
		end

	c_get_char_field (env: POINTER; oid: POINTER; fid: POINTER): CHARACTER
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_CHARACTER use %"jni.h%""
		alias
			"GetCharField"
		end

	c_get_static_char_field (env: POINTER; oid: POINTER; fid: POINTER): CHARACTER
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_CHARACTER use %"jni.h%""
		alias
			"GetStaticCharField"
		end

	c_get_float_field (env: POINTER; oid: POINTER; fid: POINTER): REAL
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_REAL use %"jni.h%""
		alias
			"GetFloatField"
		end

	c_get_static_float_field (env: POINTER; oid: POINTER; fid: POINTER): REAL
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_REAL use %"jni.h%""
		alias
			"GetStaticFloatField"
		end

	c_get_double_field (env: POINTER; oid: POINTER; fid: POINTER): DOUBLE
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_DOUBLE use %"jni.h%""
		alias
			"GetDoubleField"
		end

	c_get_static_double_field (env: POINTER; oid: POINTER; fid: POINTER): DOUBLE
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_DOUBLE use %"jni.h%""
		alias
			"GetStaticDoubleField"
		end

	c_get_byte_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_8
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_INTEGER_8 use %"jni.h%""
		alias
			"GetByteField"
		end

	c_get_static_byte_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_8
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_INTEGER_8 use %"jni.h%""
		alias
			"GetStaticByteField"
		end

	c_get_short_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_16
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_INTEGER_16 use %"jni.h%""
		alias
			"GetShortField"
		end

	c_get_static_short_field (env: POINTER; oid: POINTER; fid: POINTER): INTEGER_16
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_INTEGER_16 use %"jni.h%""
		alias
			"GetStaticShortField"
		end

	c_get_object_field (env: POINTER; oid: POINTER; fid: POINTER): POINTER
		external
			"C++ JNIEnv signature (jobject, jfieldID): EIF_POINTER use %"jni.h%""
		alias
			"GetObjectField"
		end

	c_get_static_object_field (env: POINTER; oid: POINTER; fid: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, jfieldID): EIF_POINTER use %"jni.h%""
		alias
			"GetStaticObjectField"
		end

feature {NONE} -- dynamic attribute setting

	c_set_integer_field ( env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jint) use %"jni.h%""
		alias
			"SetIntField"
		end

	c_set_static_integer_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jint) use %"jni.h%""
		alias
			"SetStaticIntField"
		end

	c_set_long_field ( env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_64)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jlong) use %"jni.h%""
		alias
			"SetLongField"
		end

	c_set_static_long_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_64)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jlong) use %"jni.h%""
		alias
			"SetStaticLongField"
		end

	c_set_object_field (env: POINTER; oid: POINTER; fid: POINTER; value: POINTER)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jobject) use %"jni.h%""
		alias
			"SetObjectField"
		end

	c_set_static_object_field (env: POINTER; oid: POINTER; fid: POINTER; value: POINTER)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jobject) use %"jni.h%""
		alias
			"SetStaticObjectField"
		end

	c_set_boolean_field (env: POINTER; oid: POINTER; fid: POINTER; value: BOOLEAN)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jboolean) use %"jni.h%""
		alias
			"SetBooleanField"
		end

	c_set_static_boolean_field (env: POINTER; oid: POINTER; fid: POINTER; value: BOOLEAN)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jboolean) use %"jni.h%""
		alias
			"SetStaticBooleanField"
		end

	c_set_char_field (env: POINTER; oid: POINTER; fid: POINTER; value: CHARACTER)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jchar) use %"jni.h%""
		alias
			"SetCharField"
		end

	c_set_static_char_field (env: POINTER; oid: POINTER; fid: POINTER; value: CHARACTER)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jchar) use %"jni.h%""
		alias
			"SetStaticCharField"
		end

	c_set_float_field (env: POINTER; oid: POINTER; fid: POINTER; value: REAL)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jfloat) use %"jni.h%""
		alias
			"SetFloatField"
		end

	c_set_static_float_field (env: POINTER; oid: POINTER; fid: POINTER; value: REAL)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jfloat) use %"jni.h%""
		alias
			"SetStaticFloatField"
		end

	c_set_double_field (env: POINTER; oid: POINTER; fid: POINTER; value: DOUBLE)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jdouble) use %"jni.h%""
		alias
			"SetDoubleField"
		end

	c_set_static_double_field (env: POINTER; oid: POINTER; fid: POINTER; value: DOUBLE)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jdouble) use %"jni.h%""
		alias
			"SetStaticDoubleField"
		end

	c_set_byte_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_8)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jbyte) use %"jni.h%""
		alias
			"SetByteField"
		end

	c_set_static_byte_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_8)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jbyte) use %"jni.h%""
		alias
			"SetStaticByteField"
		end

	c_set_short_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_16)
		external
			"C++ JNIEnv signature (jobject, jfieldID, jshort) use %"jni.h%""
		alias
			"SetShortField"
		end

	c_set_static_short_field (env: POINTER; oid: POINTER; fid: POINTER; value: INTEGER_16)
		external
			"C++ JNIEnv signature (jclass, jfieldID, jshort) use %"jni.h%""
		alias
			"SetStaticShortField"
		end

feature {NONE} -- static method calls

	c_get_static_method_id (lenv: POINTER; cls: POINTER; mname: POINTER; sig: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, char *, char *): EIF_POINTER use %"jni.h%""
		alias
			"GetStaticMethodID"
		end

	c_call_static_void_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER)
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *) use %"jni.h%""
		alias
			"CallStaticVoidMethodA"
		end

	c_call_static_byte_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_8
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_INTEGER_8 use %"jni.h%""
		alias
			"CallStaticByteMethodA"
		end

	c_call_static_boolean_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): BOOLEAN
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_BOOLEAN use %"jni.h%""
		alias
			"CallStaticBooleanMethodA"
		end

	c_call_static_char_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): CHARACTER
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_CHARACTER use %"jni.h%""
		alias
			"CallStaticCharMethodA"
		end

	c_call_static_short_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_16
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_INTEGER_16 use %"jni.h%""
		alias
			"CallStaticShortMethodA"
		end

	c_call_static_int_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): INTEGER
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_INTEGER use %"jni.h%""
		alias
			"CallStaticIntMethodA"
		end

	c_call_static_long_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): INTEGER_64
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_INTEGER_64 use %"jni.h%""
		alias
			"CallStaticLongMethodA"
		end

	c_call_static_float_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): REAL
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_REAL use %"jni.h%""
		alias
			"CallStaticFloatMethodA"
		end

	c_call_static_double_method (lenv: POINTER; cls: POINTER; mid: POINTER; argp: POINTER): DOUBLE
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_DOUBLE use %"jni.h%""
		alias
			"CallStaticDoubleMethodA"
		end


	c_call_static_object_method (lenv: POINTER; cls: POINTER; mid: POINTER; argsp: POINTER): POINTER
		external
			"C++ JNIEnv signature (jclass, jmethodID, jvalue *): EIF_POINTER use %"jni.h%""
		alias
			"CallStaticObjectMethodA"
		end

feature {NONE} -- array operations

	c_get_array_length (lenv: POINTER; ljarray: POINTER): INTEGER
		external
			"C++ JNIEnv signature (jarray): EIF_INTEGER use %"jni.h%""
		alias
			"GetArrayLength"
		end

	c_new_object_array (lenv: POINTER; lsize: INTEGER; element_jclass: POINTER;
						initial_element: POINTER): POINTER
		external
			"C++ JNIEnv signature (jsize, jclass, jobject): EIF_POINTER use %"jni.h%""
		alias
			"NewObjectArray"
		end

	c_get_object_array_element (lenv: POINTER; ljarray: POINTER; indx: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jobjectArray, jsize): EIF_POINTER use %"jni.h%""
		alias
			"GetObjectArrayElement"
		end

	c_set_object_array_element (lenv: POINTER; ljarray: POINTER; indx: INTEGER; lvalue: POINTER)
		external
			"C++ JNIEnv signature (jobjectArray, jsize, jobject) use %"jni.h%""
		alias
			"SetObjectArrayElement"
		end

	c_new_char_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewCharArray"
		end

	c_get_char_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jcharArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetCharArrayElements"
		end

	c_release_char_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jcharArray, jchar *, jint) use %"jni.h%""
		alias
			"ReleaseCharArrayElements"
		end

	c_new_int_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewIntArray"
		end

	c_get_int_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jintArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetIntArrayElements"
		end

	c_release_int_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jintArray, jint *, jint) use %"jni.h%""
		alias
			"ReleaseIntArrayElements"
		end

	c_new_long_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewLongArray"
		end

	c_get_long_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jlongArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetLongArrayElements"
		end

	c_release_long_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jlongArray, jlong *, jint) use %"jni.h%""
		alias
			"ReleaseLongArrayElements"
		end

	c_new_boolean_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewBooleanArray"
		end

	c_get_boolean_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jbooleanArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetBooleanArrayElements"
		end

	c_release_boolean_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jbooleanArray, jboolean *, jint) use %"jni.h%""
		alias
			"ReleaseBooleanArrayElements"
		end

	c_new_short_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewShortArray"
		end

	c_get_short_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jshortArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetShortArrayElements"
		end

	c_release_short_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jshortArray, jshort *, jint) use %"jni.h%""
		alias
			"ReleaseShortArrayElements"
		end

	c_new_byte_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewByteArray"
		end

	c_get_byte_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jbyteArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetByteArrayElements"
		end

	c_release_byte_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jbyteArray, jbyte *, jint) use %"jni.h%""
		alias
			"ReleaseByteArrayElements"
		end

	c_new_float_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewFloatArray"
		end

	c_get_float_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jfloatArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetFloatArrayElements"
		end

	c_release_float_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jfloatArray, jfloat *, jint) use %"jni.h%""
		alias
			"ReleaseFloatArrayElements"
		end

	c_new_double_array (lenv: POINTER; lsize: INTEGER): POINTER
		external
			"C++ JNIEnv signature (jsize): EIF_POINTER use %"jni.h%""
		alias
			"NewDoubleArray"
		end

	c_get_double_array_elements (lenv: POINTER; ljarray: POINTER; is_copy: POINTER): POINTER
		external
			"C++ JNIEnv signature (jdoubleArray, jboolean *): EIF_POINTER use %"jni.h%""
		alias
			"GetDoubleArrayElements"
		end

	c_release_double_array_elements (lenv: POINTER; ljarray: POINTER; elts: POINTER; mode: INTEGER)
		external
			"C++ JNIEnv signature (jdoubleArray, jdouble *, jint) use %"jni.h%""
		alias
			"ReleaseDoubleArrayElements"
		end

feature -- Java exception mechanism

	c_throw_java_exception (lenv: POINTER; jthrowable: POINTER)
		external
			"C++ JNIEnv signature (jthrowable) use %"jni.h%""
		alias
			"Throw"
		end

	c_throw_custom_exception (lenv: POINTER; jclass_id: POINTER; msg: POINTER)
		external
			"C++ JNIEnv signature (jclass, char *) use %"jni.h%""
		alias
			"ThrowNew"
		end

feature {NONE} -- class information

	c_get_class (lenv: POINTER; lobj: POINTER): POINTER
		external
			"C++ JNIEnv signature (jobject): EIF_POINTER use %"jni.h%""
		alias
			"GetObjectClass"
		end

	c_jni_find_class (env: POINTER; name: POINTER): POINTER
		external
			"C++ JNIEnv signature (char *): EIF_POINTER use %"jni.h%""
		alias
			"FindClass"
		end

feature {NONE} -- Structure size

	sizeof_jboolean: INTEGER
			-- Size of `jboolean' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jboolean)"
		end

	sizeof_jchar: INTEGER
			-- Size of `jchar' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jchar)"
		end

	sizeof_jbyte: INTEGER
			-- Size of `jbyte' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jbyte)"
		end

	sizeof_jshort: INTEGER
			-- Size of `jshort' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jshort)"
		end

	sizeof_jint: INTEGER
			-- Size of `jint' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jint)"
		end

	sizeof_jlong: INTEGER
			-- Size of `jlong' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jlong)"
		end

	sizeof_jfloat: INTEGER
			-- Size of `jfloat' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jfloat)"
		end

	sizeof_jdouble: INTEGER
			-- Size of `jdouble' structure.
		external
			"C macro use %"jni.h%""
		alias
			"sizeof(jdouble)"
		end

invariant
	jvm_not_void: jvm /= Void
	java_class_table_not_void: java_class_table /= Void
	java_object_table_not_void: java_object_table /= Void

end


--|----------------------------------------------------------------
--| Eiffel2Java: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license.
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

