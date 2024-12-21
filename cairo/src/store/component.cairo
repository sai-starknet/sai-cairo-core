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
    pub field_layouts: Span<FieldLayout>,
}

impl IdWriteIntoIdSet of Into<IdWrite, IdSet> {
    fn into(self: IdWrite) -> IdSet {
        IdSet { id: self.id, set: self.write }
    }
}

impl IdSetWriteIntoIdSet of Into<IdSetWrite, IdSet> {
    fn into(self: IdSetWrite) -> IdSet {
        let mut set = self.set.into();
        set.append_span(self.write);
        IdSet { id: self.id, set: set.span() }
    }
}

