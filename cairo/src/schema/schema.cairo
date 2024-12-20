use sai::{meta::FieldLayout, schema::ModelSerialized};

/// Implemented on every Schema
pub trait Schema<T> {
    fn selector() -> felt252;
    fn set_selectors() -> Span<felt252>;
    fn write_schemas() -> Span<FieldLayout>;
    fn set_values_serialized(self: @T) -> Span<felt252>;
    fn write_values_serialized(self: @T) -> Span<felt252>;
    fn from_keys_and_serialized<K>(keys: K, fields: Span<felt252>, wo_fields: Span<felt252>) -> T;
}

/// Only on schemas with an id or field/s with key
pub trait Id<T> {
    fn id(self: @T) -> felt252;
    fn to_model_serialized(self: @T) -> ModelSerialized;
    fn has_keys(self: @T) -> bool;
}


pub trait Keys<T> {
    fn id(self: @T) -> felt252;
    fn serialize_keys(self: @T) -> Span<felt252>;
}

