use sai::{
    meta::FieldLayout,
    store::{
        IStoreSet, IStoreWrite, IStoreSetWrite, IStoreRead, IdSet, SchemaData, IdWrite, IdSetWrite,
    },
    event::storage::emit_entity_update_event,
    storage::entity_model::{read_entity_from_field_layouts, write_entity_from_field_layouts},
};

#[derive(Drop, Serde)]
struct LocalReadWriter<P> {
    publisher: P,
}

#[derive(Drop, Serde)]
struct LocalSetter {}

pub impl ILocalStoreSet<P, +Drop<P>> of IStoreSet<LocalReadWriter<P>> {
    fn store_set_entity(
        ref self: LocalReadWriter<P>,
        table: felt252,
        schema_selector: felt252,
        id: felt252,
        values: Span<felt252>
    ) {
        emit_entity_update_event(table, schema_selector, id, values);
    }
    fn store_set_entities(
        ref self: LocalReadWriter<P>,
        table: felt252,
        schema_selector: felt252,
        entities: Array<IdSet>
    ) {
        for entity in entities {
            emit_entity_update_event(table, schema_selector, entity.id, entity.set);
        };
    }
}

pub impl ILocalStoreWrite<P, +IStoreSet<P>, +Drop<P>> of IStoreWrite<LocalReadWriter<P>> {
    fn store_write_entity(
        ref self: LocalReadWriter<P>,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        values: Span<felt252>
    ) {
        write_entity_from_field_layouts(table, schema.field_layouts, id, values);
        self.publisher.store_set_entity(table, schema.selector, id, values);
    }
    fn store_write_entities(
        ref self: LocalReadWriter<P>, table: felt252, schema: SchemaData, entities: Array<IdWrite>
    ) {
        let mut id_sets = ArrayTrait::<IdSet>::new();
        for entity in entities {
            write_entity_from_field_layouts(table, schema.field_layouts, entity.id, entity.write);
            id_sets.append(entity.into());
        };
        self.publisher.store_set_entities(table, schema.selector, id_sets);
    }
}

pub impl ILocalStoreSetWrite<P, +IStoreSet<P>, +Drop<P>> of IStoreSetWrite<LocalReadWriter<P>> {
    fn store_set_write_entity(
        ref self: LocalReadWriter<P>,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        set: Span<felt252>,
        write: Span<felt252>
    ) {
        write_entity_from_field_layouts(table, schema.field_layouts, id, write);
        let mut set = set.into();
        set.append_span(write);
        self.publisher.store_set_entity(table, schema.selector, id, set.span());
    }
    fn store_set_write_entities(
        ref self: LocalReadWriter<P>,
        table: felt252,
        schema: SchemaData,
        entities: Array<IdSetWrite>
    ) {
        let mut id_sets = ArrayTrait::<IdSet>::new();
        for entity in entities {
            write_entity_from_field_layouts(table, schema.field_layouts, entity.id, entity.write);
            id_sets.append(entity.into());
        };
        self.publisher.store_set_entities(table, schema.selector, id_sets);
    }
}

pub impl ILocalStoreRead<P, +IStoreSet<P>> of IStoreRead<LocalReadWriter<P>> {
    fn store_read_entity(
        self: @LocalReadWriter<P>, table: felt252, fields: Span<FieldLayout>, id: felt252
    ) -> Span<felt252> {
        read_entity_from_field_layouts(table, fields, id)
    }
    fn store_read_entities(
        self: @LocalReadWriter<P>, table: felt252, fields: Span<FieldLayout>, ids: Span<felt252>
    ) -> Array<Span<felt252>> {
        let mut entities = ArrayTrait::<Span<felt252>>::new();
        for id in ids {
            entities.append(read_entity_from_field_layouts(table, fields, *id));
        };
        entities
    }
}
