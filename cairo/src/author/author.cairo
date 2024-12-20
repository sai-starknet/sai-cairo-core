use sai::{
    author::{IAuthor}, schema::{Schema, Id}, database::{IDatabase, SerializedEntity},
    utils::{entity_id_from_keys, entity_ids_from_keys}
};


trait Database<A> {
    fn read_model<K, M, +Serde<K>, +Drop<K>, +Schema<M>>(self: @A, table: felt252, keys: K) -> M;
    fn read_models<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<M>>(
        self: @A, table: felt252, keys: Span<K>
    ) -> Array<M>;
    fn write_model<M, +Id<M>, +Schema<M>>(ref self: A, table: felt252, model: M);
    fn write_models<M, +Id<M>, +Schema<M>>(ref self: A, table: felt252, models: Array<M>);
    fn write_entity<K, M, +Serde<K>, +Schema<M>>(ref self: A, table: felt252, id: K, entity: M);
    fn write_entities<K, M, +Serde<K>, +Schema<M>>(
        ref self: A, table: felt252, entities: Array<(K, M)>
    );
}

trait TableAuthor<A> {
    fn read_model<K, M, +Schema<M>>(self: @A, keys: K) -> M;
    fn read_models<K, M, +Schema<M>>(self: @A, keys: Span<K>) -> Array<M>;
    fn write_model<M, +IdTrait<M>, +Schema<M>>(ref self: A, model: M);
    fn write_models<M, +IdTrait<M>, +Schema<M>>(ref self: A, models: Array<M>);
    fn write_entity<K, M, +Serde<K>, +Schema<M>>(ref self: A, id: K, entity: M);
    fn write_entities<K, M, +Serde<K>, +Schema<M>>(ref self: A, entities: Array<(K, M)>);
}

trait TableAuthor<A> {
    fn read_model<K, M, +Schema<M>>(self: @A, keys: K) -> M;
    fn read_models<K, M, +Schema<M>>(self: @A, keys: Span<K>) -> Array<M>;
    fn write_model<M, +IdTrait<M>, +Schema<M>>(ref self: A, model: M);
    fn write_models<M, +IdTrait<M>, +Schema<M>>(ref self: A, models: Array<M>);
    fn write_entity<K, M, +Serde<K>, +Schema<M>>(ref self: A, id: K, entity: M);
    fn write_entities<K, M, +Serde<K>, +Schema<M>>(ref self: A, entities: Array<(K, M)>);
}


impl StorageAuthorImpl<A, +IAuthor<A>, +IDatabase<A>> of StorageAuthor<A> {
    fn read_model<K, M, +Serde<K>, +Drop<K>, +Schema<M>>(self: @A, table: felt252, keys: K) -> M {
        let serialized = self
            .read_entity(table, Schema::<M>::values_schemas(), entity_id_from_keys(@keys));
        Schema::<M>::from_keys_and_serialized(keys, serialized, [].span())
    }
    fn read_models<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<M>>(
        self: @A, table: felt252, keys: Span<K>
    ) -> Array<M> {
        let mut models = ArrayTrait::<M>::new();
        let entities = self
            .read_entities(table, Schema::<M>::values_schemas(), entity_ids_from_keys(keys));
        for n in 0
            ..entities
                .len() {
                    models
                        .append(
                            Schema::<
                                M
                            >::from_keys_and_serialized(keys.at(n), *entities.at(n), [].span())
                        );
                };
        models
    }
    fn write_model<M, +Drop<M>, +Id<M>, +Schema<M>>(ref self: A, table: felt252, model: M) {
        let model_serialized = model.to_model_serialized();
        self
            .storage_write_model(
                table,
                Schema::<M>::publish_selectors(),
                Schema::<M>::values_schemas(),
                model_serialized.id,
                model_serialized.set,
                model_serialized.write
            )
    }
    fn write_models<M, +Drop<M>, +Id<M>, +Schema<M>>(
        ref self: A, table: felt252, models: Array<M>
    ) {
        let models_serialized = models.map(|model| model.to_model_serialized());
        self
            .storage_write_models(
                table,
                Schema::<M>::publish_selectors(),
                Schema::<M>::values_schemas(),
                models_serialized
            )
    }
}
