use starknet::{SyscallResultTrait, syscalls::{emit_event_syscall}};
use sai::{utils::serialize_inline, store::IdSet};

const ENTITY_UPDATE_EVENT_SELECTOR: felt252 = 0;
const ENTITIES_UPDATE_EVENT_SELECTOR: felt252 = 0;

// impl SpanSerdeImpl of Serde<Span<felt252>> {
//     fn serialize(self: @Span<felt252>, ref output: Array<felt252>) {
//         output.append((*self).len().into());
//         output.append_span(*self);
//     }

//     fn deserialize(ref serialized: Span<felt252>) -> Option<Span<felt252>> {
//         let len = (*serialized.pop_front().unwrap()).try_into().unwrap();
//         if len == serialized.len() - 1 {
//             Option::Some(serialized.slice(1, len))
//         } else {
//             Option::None
//         }
//     }
// }

pub fn emit_entity_update_event(
    table: felt252, index: felt252, field_selectors: Span<felt252>, values: Span<felt252>
) {
    emit_event_syscall(
        [ENTITY_UPDATE_EVENT_SELECTOR, table, index].span(),
        serialize_inline(@(values, field_selectors))
    )
        .unwrap_syscall();
}

pub fn emit_entities_update_event(
    table: felt252, field_selectors: Span<felt252>, entities: Array<IdSet>,
) {
    emit_event_syscall(
        [ENTITIES_UPDATE_EVENT_SELECTOR, table].span(),
        serialize_inline(@(field_selectors, entities)),
    )
        .unwrap_syscall();
}
