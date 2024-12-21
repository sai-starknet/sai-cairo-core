pub mod contract {
    pub mod contract;
    pub use contract::Contract;
}

pub mod store {
    pub mod interface;
    pub mod component;
    pub use component::{IdWrite, IdSet, SetWrite, IdSetWrite, SchemaData};
    pub use interface::{
        IStoreSet, IStoreSetDispatcher, IStoreSetDispatcherTrait, IStoreWrite,
        IStoreWriteDispatcher, IStoreWriteDispatcherTrait, IStoreSetWrite, IStoreSetWriteDispatcher,
        IStoreSetWriteDispatcherTrait, IStoreRead, IStoreReadDispatcher, IStoreReadDispatcherTrait,
    };
}

pub mod schema {
    pub mod schema;
    pub use schema::{Schema, SchemaId, SchemaSanId};
}

pub mod author {
    pub mod author;
    pub mod utils;
    pub mod interface;
    pub use interface::{IAuthor, IAuthorDispatcher, IAuthorDispatcherTrait};
}

// pub mod database {
//     pub mod database;
//     pub mod entry;
//     pub use database::{DatabaseTrait, TableTrait, TableImpl, DatabaseInterface};
//     pub mod table;
//     pub mod interface;
//     pub use interface::{IDatabase, IDatabaseDispatcher, IDatabaseDispatcherTrait};
//     pub use table::{DatabaseTable, Table};
// }

pub mod external {
    pub mod database;
    pub mod publisher;
}

pub mod publisher {
    pub mod publisher;
    pub mod interface;
    pub use interface::{IPublisher, IPublisherDispatcher, IPublisherDispatcherTrait};
}

pub mod event {
    pub mod storage;
}

pub mod meta {
    pub mod introspect;
    pub use introspect::{Introspect, Ty, StructCompareTrait};

    pub mod layout;
    pub use layout::{Layout, FieldLayout, LayoutCompareTrait};
}

pub mod storage {
    pub mod database;
    pub mod packing;
    pub mod layout;
    pub mod storage;
    pub mod entity_model;
}

pub mod utils {
    pub mod hash;
    pub use hash::{bytearray_hash, selector_from_names, selector_from_namespace_and_name};

    pub mod key;
    pub use key::{
        entity_id_from_serialized_keys, combine_key, entity_id_from_keys, entity_ids_from_keys
    };

    pub mod layout;
    pub use layout::{find_field_layout, find_model_field_layout};

    pub mod misc;
    pub use misc::{any_none, sum};

    pub mod naming;
    pub use naming::is_name_valid;

    pub mod serde;
    pub use serde::{serialize_inline, deserialize_unwrap, serialize_multiple, deserialize_multiple};
}

pub mod world {
    pub mod publisher;
}

pub mod local {
    pub mod database;
    pub mod publisher;
}

pub mod permissions {
    pub mod interface;
    pub mod permissions;

    pub use interface::{IPermissions, IPermissionsDispatcher, IPermissionsDispatcherTrait};
}
