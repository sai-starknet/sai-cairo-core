use core::starknet::ContractAddress;

use sai::world::{IWorldDispatcher};

use crate::world::{spawn_test_world, NamespaceDef, TestResource};

/// This file contains some partial event contracts written without the sai::event
/// attribute, to avoid having several contracts with a same name/classhash,
/// as the test runner does not differenciate them.
/// These event contracts are used to test event upgrades in tests/event.cairo.

// This event is used as a base to create the "previous" version of an event to be upgraded.
#[derive(Introspect)]
struct FooBaseEvent {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

#[derive(Copy, Drop, Serde, Debug)]
#[sai::event]
pub struct FooEventBadLayoutType {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

#[derive(Copy, Drop, Serde, Debug)]
#[sai::event]
struct FooEventMemberRemoved {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

#[derive(Copy, Drop, Serde, Debug)]
#[sai::event]
struct FooEventMemberAddedButRemoved {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

#[derive(Copy, Drop, Serde, Debug)]
#[sai::event]
struct FooEventMemberAddedButMoved {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

#[derive(Copy, Drop, Serde, Debug)]
#[sai::event]
struct FooEventMemberAdded {
    #[key]
    pub caller: ContractAddress,
    pub a: felt252,
    pub b: u128,
}

pub fn deploy_world_for_event_upgrades() -> IWorldDispatcher {
    let namespace_def = NamespaceDef {
        namespace: "dojo", resources: [
            TestResource::Event(old_foo_event_bad_layout_type::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Event(e_FooEventMemberRemoved::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Event(
                e_FooEventMemberAddedButRemoved::TEST_CLASS_HASH.try_into().unwrap()
            ),
            TestResource::Event(e_FooEventMemberAddedButMoved::TEST_CLASS_HASH.try_into().unwrap()),
            TestResource::Event(e_FooEventMemberAdded::TEST_CLASS_HASH.try_into().unwrap()),
        ].span()
    };
    spawn_test_world([namespace_def].span()).dispatcher
}

#[starknet::contract]
pub mod old_foo_event_bad_layout_type {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DeployedEventImpl of sai::meta::interface::IDeployedResource<ContractState> {
        fn dojo_name(self: @ContractState) -> ByteArray {
            "FooEventBadLayoutType"
        }
    }

    #[abi(embed_v0)]
    impl StoredImpl of sai::meta::interface::IStoredResource<ContractState> {
        fn schema(self: @ContractState) -> sai::meta::introspect::Struct {
            if let sai::meta::introspect::Ty::Struct(mut s) =
                sai::meta::introspect::Introspect::<super::FooBaseEvent>::ty() {
                s.name = 'FooEventBadLayoutType';
                s
            } else {
                panic!("Unexpected schema.")
            }
        }

        fn layout(self: @ContractState) -> sai::meta::Layout {
            // Should never happen as sai::event always derive Introspect.
            sai::meta::Layout::Fixed([].span())
        }
    }
}