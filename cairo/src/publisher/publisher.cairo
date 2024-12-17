use sai::{
    meta::{SchemaTrait, Schema}, utils::{serialize_inline, serialize_multiple},
    database::{entry::{entry_to_id_values, entries_to_ids_values}, DatabaseTable}
};

/// Interface to publish entities without writing to the database.
pub trait PublisherInterface<P> {
    /// Set an entity with a layout.
    fn set_entity(ref self: P, table: felt252, id: felt252, layout: Schema, values: Span<felt252>);

    /// Set multiple entities with a layout.
    fn set_entities(
        ref self: P,
        table: felt252,
        ids: Span<felt252>,
        layout: Schema,
        values: Array<Span<felt252>>,
    );
}

/// Publish with a schema without writing to the database.
pub trait PublisherTrait<P> {
    /// Set a value with a schema.
    fn set_table_value<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: P, table: felt252, id: felt252, value: @V
    );

    /// Set multiple values with a schema.
    fn set_table_values<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: P, table: felt252, ids: Span<felt252>, values: Span<V>
    );

    /// Set an entry with a schema.
    fn set_table_entry<E, +Serde<E>, +SchemaTrait<E>>(ref self: P, table: felt252, entry: @E);

    /// Set multiple entries with a schema.
    fn set_table_entries<E, +Drop<E>, +Serde<E>, +SchemaTrait<E>>(
        ref self: P, table: felt252, entries: Span<E>
    );

    /// Convert to a table.
    fn to_table(self: @P, selector: felt252) -> DatabaseTable<P>;
}

/// Publish to a table without writing to the database.
pub trait TablePublisherTrait<T> {
    /// Set a value with a schema.
    fn set_value<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: T, table: felt252, id: felt252, value: @V
    );

    /// Set multiple values with a schema.
    fn set_values<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: T, table: felt252, ids: Span<felt252>, values: Span<V>
    );

    /// Set an entry with a schema.
    fn set_entry<E, +Serde<E>, +SchemaTrait<E>>(ref self: T, table: felt252, entry: @E);


    fn set_entries<E, +Drop<E>, +Serde<E>, +SchemaTrait<E>>(
        ref self: T, table: felt252, entries: Span<E>
    );
}

pub impl PublisherImpl<P, +PublisherInterface<P>, +Drop<P>, +Copy<P>> of PublisherTrait<P> {
    fn set_table_value<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: P, table: felt252, id: felt252, value: @V
    ) {
        self.set_entity(table, id, SchemaTrait::<V>::schema(), serialize_inline(value));
    }

    fn set_table_values<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: P, table: felt252, ids: Span<felt252>, values: Span<V>
    ) {
        self.set_entities(table, ids, SchemaTrait::<V>::schema(), serialize_multiple(values));
    }

    fn set_table_entry<E, +Serde<E>, +SchemaTrait<E>>(ref self: P, table: felt252, entry: @E) {
        let (id, values) = entry_to_id_values(entry);
        self.set_entity(table, id, SchemaTrait::<E>::schema(), values);
    }

    fn set_table_entries<E, +Drop<E>, +Serde<E>, +SchemaTrait<E>>(
        ref self: P, table: felt252, entries: Span<E>
    ) {
        let (ids, values) = entries_to_ids_values(entries);
        self.set_entities(table, ids, SchemaTrait::<E>::schema(), values);
    }

    fn to_table(self: @P, selector: felt252) -> DatabaseTable<P> {
        DatabaseTable { database: *self, selector, }
    }
}

pub impl TablePublisherImpl<
    P, +PublisherInterface<P>, +Copy<P>, +Drop<P>
> of TablePublisherTrait<DatabaseTable<P>> {
    fn set_value<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: DatabaseTable<P>, table: felt252, id: felt252, value: @V
    ) {
        let mut database = self.database;
        database.set_entity(self.selector, id, SchemaTrait::<V>::schema(), serialize_inline(value));
    }

    fn set_values<V, +Serde<V>, +SchemaTrait<V>>(
        ref self: DatabaseTable<P>, table: felt252, ids: Span<felt252>, values: Span<V>
    ) {
        let mut database = self.database;
        database
            .set_entities(
                self.selector, ids, SchemaTrait::<V>::schema(), serialize_multiple(values)
            );
    }

    fn set_entry<E, +Serde<E>, +SchemaTrait<E>>(
        ref self: DatabaseTable<P>, table: felt252, entry: @E
    ) {
        let mut database = self.database;
        let (id, values) = entry_to_id_values(entry);
        database.set_entity(self.selector, id, SchemaTrait::<E>::schema(), values);
    }

    fn set_entries<E, +Drop<E>, +Serde<E>, +SchemaTrait<E>>(
        ref self: DatabaseTable<P>, table: felt252, entries: Span<E>
    ) {
        let mut database = self.database;
        let (ids, values) = entries_to_ids_values(entries);
        database.set_entities(self.selector, ids, SchemaTrait::<E>::schema(), values);
    }
}
