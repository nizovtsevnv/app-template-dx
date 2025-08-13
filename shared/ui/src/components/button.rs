use dioxus::prelude::*;

#[derive(Clone, PartialEq)]
pub enum ButtonVariant {
    Primary,
    Secondary,
    Outline,
    Destructive,
}

#[derive(Clone, PartialEq)]
pub enum ButtonSize {
    Small,
    Medium,
    Large,
}

#[derive(Props, Clone, PartialEq)]
pub struct ButtonProps {
    #[props(default = "Button".to_string())]
    pub text: String,
    #[props(default = ButtonVariant::Primary)]
    pub variant: ButtonVariant,
    #[props(default = ButtonSize::Medium)]
    pub size: ButtonSize,
    #[props(default = false)]
    pub disabled: bool,
    #[props(default)]
    pub onclick: Option<EventHandler<MouseEvent>>,
    #[props(default)]
    pub class: Option<String>,
}

impl ButtonVariant {
    fn to_classes(&self) -> &'static str {
        match self {
            ButtonVariant::Primary => {
                "bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500"
            }
            ButtonVariant::Secondary => {
                "bg-gray-200 hover:bg-gray-300 text-gray-900 focus:ring-gray-400"
            }
            ButtonVariant::Outline => {
                "border-2 border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white focus:ring-blue-500"
            }
            ButtonVariant::Destructive => {
                "bg-red-600 hover:bg-red-700 text-white focus:ring-red-500"
            }
        }
    }
}

impl ButtonSize {
    fn to_classes(&self) -> &'static str {
        match self {
            ButtonSize::Small => "px-3 py-1.5 text-sm",
            ButtonSize::Medium => "px-4 py-2 text-base",
            ButtonSize::Large => "px-6 py-3 text-lg",
        }
    }
}

#[component]
pub fn Button(props: ButtonProps) -> Element {
    let base_classes = "font-medium rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-opacity-50 disabled:opacity-50 disabled:cursor-not-allowed";
    let variant_classes = props.variant.to_classes();
    let size_classes = props.size.to_classes();
    let additional_classes = props.class.as_deref().unwrap_or("");

    let class_string = format!(
        "{} {} {} {}",
        base_classes, variant_classes, size_classes, additional_classes
    );

    rsx! {
        button {
            class: "{class_string}",
            disabled: props.disabled,
            onclick: move |evt| {
                if !props.disabled {
                    if let Some(handler) = &props.onclick {
                        handler.call(evt);
                    }
                }
            },
            "{props.text}"
        }
    }
}
