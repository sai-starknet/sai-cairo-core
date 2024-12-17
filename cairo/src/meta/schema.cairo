use sai::meta::FieldLayout;

pub type Schema = Span<FieldLayout>;

pub trait SchemaTrait<T> {
    fn schema() -> Schema;
    fn field_selectors() -> Span<felt252>;
}


mod implement {
    use sai::meta::{Introspect, Layout};
    use super::{SchemaTrait, Schema};
    pub impl SchemaImpl<T, +Introspect<T>> of SchemaTrait<T> {
        fn schema() -> Schema {
            match Introspect::<T>::layout() {
                Layout::Struct(fields) => { fields },
                _ => panic!("Unexpected model layout")
            }
        }

        fn field_selectors() -> Span<felt252> {
            let schema = Self::schema();
            let mut selectors = ArrayTrait::<felt252>::new();
            for field in schema {
                selectors.append(*field.selector);
            };
            selectors.span()
        }
    }
}

