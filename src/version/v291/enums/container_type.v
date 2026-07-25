module enums

import serializer

pub enum ContainerType as i8 {
	@none               = -9
	inventory           = -1
	container           = 0
	workbench           = 1
	furnace             = 2
	enchantment         = 3
	brewing_stand       = 4
	anvil               = 5
	dispenser           = 6
	dropper             = 7
	hopper              = 8
	cauldron            = 9
	minecart_chest      = 10
	minecart_hopper     = 11
	horse               = 12
	beacon              = 13
	structure_editor    = 14
	trade               = 15
	command_block       = 16
	jukebox             = 17
	armor               = 18
	hand                = 19
	compound_creator    = 20
	element_constructor = 21
	material_reducer    = 22
	lab_table           = 23
	loom                = 24
	lectern             = 25
	grindstone          = 26
	blast_furnace       = 27
	smoker              = 28
	stonecutter         = 29
	cartography         = 30
}

pub fn (e ContainerType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ContainerType.decode(mut r serializer.Reader) !ContainerType {
	return unsafe { ContainerType(r.i8()!) }
}
