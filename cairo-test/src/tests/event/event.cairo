#[derive(Drop, Serde)]
#[sai::event]
struct FooEvent {
    #[key]
    k1: u8,
    #[key]
    k2: felt252,
    v1: u128,
    v2: u32
}

#[test]
fn test_event_definition() {
    let definition = sai::event::Event::<FooEvent>::definition();

    assert_eq!(definition.name, sai::event::Event::<FooEvent>::name());
    assert_eq!(definition.layout, sai::event::Event::<FooEvent>::layout());
    assert_eq!(definition.schema, sai::event::Event::<FooEvent>::schema());
}
