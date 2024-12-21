use sai::{schema::{Schema, SchemaId}, store::IdSetWrite};


pub fn entities_to_schemas<K, M, +Drop<K>, +Serde<K>, +Drop<M>, +Schema<M>>(
    mut keys: Array<K>, mut entities: Array<Span<felt252>>
) -> Array<M> {
    let mut schemas = ArrayTrait::<M>::new();
    loop {
        match (keys.pop_front(), entities.pop_front()) {
            (
                Option::Some(key), Option::Some(entity)
            ) => { schemas.append(Schema::<M>::from_k_and_serialized(key, entity, [].span())); },
            _ => { break; }
        }
    };
    schemas
}

pub fn schemas_to_id_set_write<M, +SchemaId<M>, +Drop<M>>(entities: Array<M>) -> Array<IdSetWrite> {
    let mut array = ArrayTrait::<IdSetWrite>::new();
    for entity in entities {
        array.append(entity.id_set_write());
    };
    array
}
