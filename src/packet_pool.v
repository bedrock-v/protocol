module src

import src.serializer

pub struct PacketPool {
pub mut:
	factories map[u16]fn () Packet
}

pub fn new_packet_pool() PacketPool {
	mut p := PacketPool{
		factories: map[u16]fn () Packet{}
	}
	p.register(fn () Packet {
		return &LoginPacket{}
	})
	p.register(fn () Packet {
		return &PlayStatusPacket{}
	})
	p.register(fn () Packet {
		return &ServerToClientHandshakePacket{}
	})
	p.register(fn () Packet {
		return &ClientToServerHandshakePacket{}
	})
	p.register(fn () Packet {
		return &DisconnectPacket{}
	})
	p.register(fn () Packet {
		return &SetTimePacket{}
	})
	p.register(fn () Packet {
		return &TextPacket{}
	})
	p.register(fn () Packet {
		return &RequestNetworkSettingsPacket{}
	})
	p.register(fn () Packet {
		return &NetworkSettingsPacket{}
	})
	p.register(fn () Packet {
		return &RequestChunkRadiusPacket{}
	})
	p.register(fn () Packet {
		return &ChunkRadiusUpdatedPacket{}
	})
	p.register(fn () Packet {
		return &SetLocalPlayerAsInitializedPacket{}
	})
	p.register(fn () Packet {
		return &RespawnPacket{}
	})
	p.register(fn () Packet {
		return &AnimatePacket{}
	})
	p.register(fn () Packet {
		return &ContainerClosePacket{}
	})
	p.register(fn () Packet {
		return &ClientCacheStatusPacket{}
	})
	p.register(fn () Packet {
		return &SetDifficultyPacket{}
	})
	p.register(fn () Packet {
		return &NetworkStackLatencyPacket{}
	})
	p.register(fn () Packet {
		return &InteractPacket{}
	})
	p.register(fn () Packet {
		return &EmotePacket{}
	})
	p.register(fn () Packet {
		return &PlayerActionPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackClientResponsePacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackChunkRequestPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackDataInfoPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackChunkDataPacket{}
	})
	p.register(fn () Packet {
		return &RemoveActorPacket{}
	})
	p.register(fn () Packet {
		return &TakeItemActorPacket{}
	})
	p.register(fn () Packet {
		return &SetActorMotionPacket{}
	})
	p.register(fn () Packet {
		return &MoveActorAbsolutePacket{}
	})
	p.register(fn () Packet {
		return &SetHealthPacket{}
	})
	p.register(fn () Packet {
		return &SetSpawnPositionPacket{}
	})
	p.register(fn () Packet {
		return &ShowCreditsPacket{}
	})
	p.register(fn () Packet {
		return &BlockPickRequestPacket{}
	})
	p.register(fn () Packet {
		return &ActorPickRequestPacket{}
	})
	p.register(fn () Packet {
		return &SetPlayerGameTypePacket{}
	})
	p.register(fn () Packet {
		return &SpawnExperienceOrbPacket{}
	})
	p.register(fn () Packet {
		return &OnScreenTextureAnimationPacket{}
	})
	p.register(fn () Packet {
		return &SimpleEventPacket{}
	})
	p.register(fn () Packet {
		return &RefreshEntitlementsPacket{}
	})
	p.register(fn () Packet {
		return &TickingAreasLoadStatusPacket{}
	})
	p.register(fn () Packet {
		return &PlayerHotbarPacket{}
	})
	p.register(fn () Packet {
		return &GuiDataPickItemPacket{}
	})
	p.register(fn () Packet {
		return &HurtArmorPacket{}
	})
	p.register(fn () Packet {
		return &MobEquipmentPacket{}
	})
	p.register(fn () Packet {
		return &MobArmorEquipmentPacket{}
	})
	p.register(fn () Packet {
		return &InventorySlotPacket{}
	})
	p.register(fn () Packet {
		return &InventoryContentPacket{}
	})
	p.register(fn () Packet {
		return &ContainerOpenPacket{}
	})
	p.register(fn () Packet {
		return &ContainerSetDataPacket{}
	})
	p.register(fn () Packet {
		return &CreativeContentPacket{}
	})
	p.register(fn () Packet {
		return &BlockActorDataPacket{}
	})
	p.register(fn () Packet {
		return &ItemRegistryPacket{}
	})
	p.register(fn () Packet {
		return &UpdateEquipPacket{}
	})
	p.register(fn () Packet {
		return &SetActorDataPacket{}
	})
	p.register(fn () Packet {
		return &AddItemActorPacket{}
	})
	p.register(fn () Packet {
		return &MobEffectPacket{}
	})
	p.register(fn () Packet {
		return &MovePlayerPacket{}
	})
	p.register(fn () Packet {
		return &AddActorPacket{}
	})
	p.register(fn () Packet {
		return &UpdateAttributesPacket{}
	})
	return p
}

pub fn (mut p PacketPool) register(factory fn () Packet) {
	pkt := factory()
	p.factories[pkt.pid()] = factory
}

pub fn (p &PacketPool) get_packet_by_id(pid u16) ?Packet {
	factory := p.factories[pid] or { return none }
	return factory()
}

pub fn (p &PacketPool) decode(mut r serializer.Reader) !Packet {
	header := read_packet_header(mut r)!
	mut pkt := p.get_packet_by_id(header.pid) or {
		return error('unknown packet id 0x${header.pid:x}')
	}
	pkt.decode_payload(mut r)!
	return pkt
}
