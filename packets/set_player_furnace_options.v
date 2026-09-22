module packets

import protocol.serializer

pub enum FurnaceType as u8 {
	@none         = 0
	furnace       = 1
	blast_furnace = 2
	smoker        = 3
}

pub fn (e FurnaceType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn FurnaceType.decode(mut r serializer.Reader) !FurnaceType {
	return unsafe { FurnaceType(r.u8()!) }
}

pub enum FurnaceLeftTabIndex as i32 {
	@none         = 0
	recipe_food   = 1
	recipe_items  = 2
	recipe_blocks = 3
	recipe_search = 4
	inventory     = 5
}

pub fn (e FurnaceLeftTabIndex) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn FurnaceLeftTabIndex.decode(mut r serializer.Reader) !FurnaceLeftTabIndex {
	return unsafe { FurnaceLeftTabIndex(r.read_varint32()!) }
}

pub enum FurnaceLayout as i32 {
	@none          = 0
	inventory_only = 1
	default        = 2
}

pub fn (e FurnaceLayout) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn FurnaceLayout.decode(mut r serializer.Reader) !FurnaceLayout {
	return unsafe { FurnaceLayout(r.read_varint32()!) }
}

pub struct FurnaceOptions {
pub mut:
	left_furnace_tab FurnaceLeftTabIndex
	filtering        bool
	furnace_layout   FurnaceLayout
}

pub fn (t FurnaceOptions) encode(mut w serializer.Writer) {
	t.left_furnace_tab.encode(mut w)
	w.bool(t.filtering)
	t.furnace_layout.encode(mut w)
}

pub fn FurnaceOptions.decode(mut r serializer.Reader) !FurnaceOptions {
	return FurnaceOptions{
		left_furnace_tab: FurnaceLeftTabIndex.decode(mut r)!
		filtering:        r.bool()!
		furnace_layout:   FurnaceLayout.decode(mut r)!
	}
}

pub struct SetPlayerFurnaceOptionsPacket {
pub mut:
	furnace_type    FurnaceType
	furnace_options FurnaceOptions
}

pub fn (p &SetPlayerFurnaceOptionsPacket) pid() u16 {
	return 351
}

pub fn (p &SetPlayerFurnaceOptionsPacket) name() string {
	return 'SetPlayerFurnaceOptionsPacket'
}

pub fn (p &SetPlayerFurnaceOptionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetPlayerFurnaceOptionsPacket) encode_payload(mut w serializer.Writer) {
	p.furnace_type.encode(mut w)
	p.furnace_options.encode(mut w)
}

pub fn (mut p SetPlayerFurnaceOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.furnace_type = FurnaceType.decode(mut r)!
	p.furnace_options = FurnaceOptions.decode(mut r)!
}
