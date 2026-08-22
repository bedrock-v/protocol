module current

import protocol
import protocol.version.v2192

// The pool the server decodes with.
//
// Every packet it can name is registered again here under this module's own
// alias of it. V keeps an alias apart from the type it stands for, so a packet
// the pool built as the version module's type would not match a check written
// against the alias - and the dispatch that decides what a packet means is
// exactly such a check.
pub fn new_packet_pool() protocol.PacketPool {
	mut pool := v2192.new_pool()
	pool.register(fn () protocol.Packet {
		return &ActorEventPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AddActorPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AddItemActorPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AddPlayerPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AnimatePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AvailableActorIdentifiersPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &AvailableCommandsPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &BiomeDefinitionListPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &BlockActorDataPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &BlockPickRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &BookEditPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ChangeDimensionPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ChunkRadiusUpdatedPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ClientToServerHandshakePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &CommandRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ContainerClosePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ContainerOpenPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &CreativeContentPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &DisconnectPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &InteractPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &InventoryContentPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &InventorySlotPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &InventoryTransactionPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ItemComponentPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ItemStackRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ItemStackResponsePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &JigsawStructureDataPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &LevelChunkPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &LevelEventPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &LevelSoundEventPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &LoginPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &MobEffectPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &MobEquipmentPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ModalFormRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ModalFormResponsePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &MoveActorAbsolutePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &MovePlayerPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &NetworkChunkPublisherUpdatePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &NetworkSettingsPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &OpenSignPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &PlayStatusPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &PlayerActionPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &PlayerAuthInputPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &PlayerHotbarPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &PlayerListPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &RemoveActorPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &RemoveObjectivePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &RequestChunkRadiusPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &RequestNetworkSettingsPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePackChunkDataPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePackChunkRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePackClientResponsePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePackDataInfoPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePackStackPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ResourcePacksInfoPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &RespawnPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &ServerToClientHandshakePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetActorDataPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetActorMotionPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetDifficultyPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetDisplayObjectivePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetLocalPlayerAsInitializedPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetPlayerGameTypePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetScorePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetTimePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SetTitlePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &StartGamePacket{}
	})
	pool.register(fn () protocol.Packet {
		return &StopSoundPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SubChunkPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &SubChunkRequestPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &TakeItemActorPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &TextPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &UpdateAbilitiesPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &UpdateAdventureSettingsPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &UpdateAttributesPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &UpdateBlockPacket{}
	})
	pool.register(fn () protocol.Packet {
		return &VoxelShapesPacket{}
	})
	return pool
}
