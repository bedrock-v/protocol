module types

import protocol.serializer
import protocol.version.v662.enums

pub struct InternalItemDescriptor {
pub mut:
	full_name string
	aux_value u16
}

pub fn (t InternalItemDescriptor) encode(mut w serializer.Writer) {
	w.write_string(t.full_name)
	w.le_u16(t.aux_value)
}

pub fn InternalItemDescriptor.decode(mut r serializer.Reader) !InternalItemDescriptor {
	return InternalItemDescriptor{
		full_name: r.read_string()!
		aux_value: r.le_u16()!
	}
}

pub struct MolangDescriptor {
pub mut:
	full_name      string
	molang_version enums.MolangVersion
}

pub fn (t MolangDescriptor) encode(mut w serializer.Writer) {
	w.write_string(t.full_name)
	t.molang_version.encode(mut w)
}

pub fn MolangDescriptor.decode(mut r serializer.Reader) !MolangDescriptor {
	return MolangDescriptor{
		full_name:      r.read_string()!
		molang_version: enums.MolangVersion.decode(mut r)!
	}
}

pub struct ItemTagDescriptor {
pub mut:
	item_tag string
}

pub fn (t ItemTagDescriptor) encode(mut w serializer.Writer) {
	w.write_string(t.item_tag)
}

pub fn ItemTagDescriptor.decode(mut r serializer.Reader) !ItemTagDescriptor {
	return ItemTagDescriptor{
		item_tag: r.read_string()!
	}
}

pub struct DeferredDescriptor {
pub mut:
	full_name string
	aux_value u16
}

pub fn (t DeferredDescriptor) encode(mut w serializer.Writer) {
	w.write_string(t.full_name)
	w.le_u16(t.aux_value)
}

pub fn DeferredDescriptor.decode(mut r serializer.Reader) !DeferredDescriptor {
	return DeferredDescriptor{
		full_name: r.read_string()!
		aux_value: r.le_u16()!
	}
}

pub struct BaseDescription {
pub mut:
	internal_item_descriptor InternalItemDescriptor
	molang_descriptor        MolangDescriptor
	item_tag_descriptor      ItemTagDescriptor
	deferred_descriptor      DeferredDescriptor
}

pub fn (t BaseDescription) encode(mut w serializer.Writer) {
	t.internal_item_descriptor.encode(mut w)
	t.molang_descriptor.encode(mut w)
	t.item_tag_descriptor.encode(mut w)
	t.deferred_descriptor.encode(mut w)
}

pub fn BaseDescription.decode(mut r serializer.Reader) !BaseDescription {
	return BaseDescription{
		internal_item_descriptor: InternalItemDescriptor.decode(mut r)!
		molang_descriptor:        MolangDescriptor.decode(mut r)!
		item_tag_descriptor:      ItemTagDescriptor.decode(mut r)!
		deferred_descriptor:      DeferredDescriptor.decode(mut r)!
	}
}
