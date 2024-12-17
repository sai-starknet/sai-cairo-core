use sai::{
    publisher::IPublisher, meta::Schema,
    event::storage::{emit_entity_update_event, emit_entities_update_event}
};

#[derive(Drop, Copy)]
struct LocalDatabase<P> {
    publisher: P,
}

#[derive(Drop, Copy)]
struct LocalPublisher {}


impl LocalPublisherImpl of IPublisher<LocalPublisher> {
    fn set_entity(
        ref self: LocalPublisher, table: felt252, id: felt252, schema: Schema, values: Span<felt252>
    ) {
        emit_entity_update_event(table, id, values);
    }

    fn set_entities(
        ref self: LocalPublisher,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        emit_entities_update_event(table, ids, values);
    }
}
