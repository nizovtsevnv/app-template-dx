use dioxus::prelude::*;
use shared_ui::*;

#[test]
fn test_button_component_compilation() {
    // Test that Button component compiles and can be instantiated
    #[allow(dead_code)]
    fn test_app() -> Element {
        rsx! {
            Button {
                text: "Test Button",
                onclick: |_| {}
            }
        }
    }

    // If this test compiles, the component is structurally correct
}

#[test]
fn test_button_props() {
    // Test that ButtonProps can be created with different configurations
    let _props1 = ButtonProps {
        text: "Click me".to_string(),
        onclick: None,
        variant: ButtonVariant::Primary,
        size: ButtonSize::Medium,
        disabled: false,
        class: None,
    };

    // Test with default values
    let _props2 = ButtonProps {
        text: "Another button".to_string(),
        onclick: None,
        variant: ButtonVariant::Secondary,
        size: ButtonSize::Small,
        disabled: false,
        class: Some("custom-class".to_string()),
    };
}
