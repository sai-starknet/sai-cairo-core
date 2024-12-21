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
