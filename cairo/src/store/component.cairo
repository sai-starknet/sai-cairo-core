use sai::meta::FieldLayout;

#[derive(Drop, Serde)]
pub struct IdWrite {
    pub id: felt252,
    pub write: Span<felt252>
}

#[derive(Drop, Serde)]
pub struct IdSet {
    pub id: felt252,
    pub set: Span<felt252>
}

#[derive(Drop, Serde)]
pub struct SetWrite {
    pub set: Span<felt252>,
    pub write: Span<felt252>
}

#[derive(Drop, Serde)]
pub struct IdSetWrite {
    pub id: felt252,
    pub set: Span<felt252>,
    pub write: Span<felt252>
}

#[derive(Drop, Serde)]
pub struct SchemaData {
    pub selector: felt252,
    pub write: Span<FieldLayout>,
}

