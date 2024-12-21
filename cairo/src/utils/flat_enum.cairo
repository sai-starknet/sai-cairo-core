#[derive(Copy, Drop, Debug, PartialEq)]
pub enum A<T> {
    #[default]
    T: T
}

impl ASerdeImpl<T, +Serde<T>> of Serde<A<T>> {
    fn serialize(self: @A<T>, ref output: Array<felt252>) {
        match self {
            A::T(t) => { Serde::<T>::serialize(t, ref output); }
        }
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<A<T>> {
        match Serde::<T>::deserialize(ref serialized) {
            Option::Some(t) => Option::Some(A::T(t)),
            Option::None => Option::None
        }
    }
}

impl AIntoT<T> of Into<A<T>, T> {
    fn into(self: A<T>) -> T {
        match self {
            A::T(t) => t
        }
    }
}

impl TIntoA<T> of Into<T, A<T>> {
    fn into(self: T) -> A<T> {
        A::T(self)
    }
}
