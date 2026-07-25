module enums

import serializer

pub enum MolangVersion as i32 {
	invalid                                    = -1
	before_versioning                          = 0
	initial                                    = 1
	fixed_item_remaining_use_duration_query    = 2
	expression_error_messages                  = 3
	unexpected_operator_errors                 = 4
	conditional_operator_associativity         = 5
	comparison_and_logical_operator_precedence = 6
	divide_by_negative_value                   = 7
	fixed_cape_flap_amount_query               = 8
	query_block_property_renamed_to_state      = 9
	deprecate_old_block_query_names            = 10
	deprecated_sniffer_and_camel_queries       = 11
	leaf_supporting_in_first_solid_block_below = 12
	num_valid_versions                         = 13
}

pub fn (e MolangVersion) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn MolangVersion.decode(mut r serializer.Reader) !MolangVersion {
	return unsafe { MolangVersion(r.le_i32()!) }
}
