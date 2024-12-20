use sai::store::{
    IStoreSet, IStoreWrite, IStoreSetWrite, IStoreRead,
    event::storage::{emit_entity_update_event, emit_entities_update_event}
};

#[derive(Drop)]
struct LocalSetter {}

impl LocalStoreSetImpl of IStoreTrait<LocalSetter> {
    fn set_entity(ref self: LocalSetter, table: felt252, id: felt252, values: Span<felt252>) {
        emit_entity_update_event(table, id, values);
    }

    fn set_entities(ref self: LocalSetter, table: felt252, entities: IdSet) {
        let mut ids = entities.ids;
        let mut values = entities.values;
        loop {
            match (ids.pop_front(), values.pop_front()) {
                (
                    Option::Some(id), Option::Some(values)
                ) => { emit_entity_update_event(table, *id, values); },
                _ => { break; }
            }
        };
    }
}
