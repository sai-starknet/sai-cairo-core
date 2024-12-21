use starknet::{SyscallResultTrait, syscalls::{emit_event_syscall}};
use sai::utils::serialize_inline;

const ENTITY_UPDATE_EVENT_SELECTOR: felt252 = 0;
const ENTITIES_UPDATE_EVENT_SELECTOR: felt252 = 0;

pub fn emit_entity_update_event(
    table: felt252, schema: felt252, index: felt252, values: Span<felt252>
) {
    emit_event_syscall(
        [ENTITY_UPDATE_EVENT_SELECTOR, table, schema, index].span(), serialize_inline(@values)
    )
        .unwrap_syscall();
}
