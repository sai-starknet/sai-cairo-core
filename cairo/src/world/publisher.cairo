use starknet::{SyscallResultTrait, syscalls::{emit_event_syscall}};
use sai::utils::serialize_inline;
use sai::publisher::IPublisher;
use sai::meta::Schema;

const ENTITY_UPDATE_EVENT_SELECTOR: felt252 = selector!("StoreUpdateEntity");
const ENTITIES_UPDATE_EVENT_SELECTOR: felt252 = selector!("StoreUpdateEntities");

struct LocalPublisher {}

#[derive(Drop, starknet::Event)]
struct StoreUpdateEntity {
    #[key]
    table: felt252,
    #[key]
    index: felt252,
    field_selectors: Span<felt252>,
    values: Span<felt252>,
}

#[derive(Drop, starknet::Event)]
struct StoreUpdateEntities {
    #[key]
    table: felt252,
    indexes: Span<felt252>,
    field_selectors: Span<felt252>,
    values: Array<Span<felt252>>,
}

fn emit_entity_update_event(
    table: felt252, index: felt252, field_selectors: Span<felt252>, values: Span<felt252>, 
) {
    emit_event_syscall(
        [ENTITY_UPDATE_EVENT_SELECTOR, table, index].span(),
        serialize_inline(@(field_selectors, values))
    )
        .unwrap_syscall();
}

fn emit_entities_update_event(
    table: felt252,
    indexes: Span<felt252>,
    field_selectors: Span<felt252>
    values: Array<Span<felt252>>,
    
) {
    emit_event_syscall(
        [ENTITY_UPDATE_EVENT_SELECTOR, table].span(), serialize_inline(@(field_selectors, values)),
    )
        .unwrap_syscall();
}


impl WorldPublisherImpl of IPublisher<LocalPublisher> {
    fn set_entity(
        ref self: LocalPublisher, table: felt252, id: felt252, schema: Schema, values: Span<felt252>
    ) {
        emit_entity_update_event(table, id, field_selectors, values);
    }

    fn set_entities(
        ref self: LocalPublisher,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        emit_entities_update_event(table, ids, field_selectors, values);
    }
}

