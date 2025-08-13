use dioxus::prelude::*;

#[derive(Clone, PartialEq)]
pub enum InputType {
    Text,
    Email,
    Password,
    Number,
    Tel,
    Url,
}

impl InputType {
    fn to_str(&self) -> &'static str {
        match self {
            InputType::Text => "text",
            InputType::Email => "email",
            InputType::Password => "password",
            InputType::Number => "number",
            InputType::Tel => "tel",
            InputType::Url => "url",
        }
    }
}

#[derive(Props, Clone, PartialEq)]
pub struct InputProps {
    #[props(default = InputType::Text)]
    pub input_type: InputType,
    #[props(default)]
    pub placeholder: Option<String>,
    #[props(default)]
    pub value: Option<String>,
    #[props(default = false)]
    pub disabled: bool,
    #[props(default = false)]
    pub required: bool,
    #[props(default)]
    pub oninput: Option<EventHandler<FormEvent>>,
    #[props(default)]
    pub onchange: Option<EventHandler<FormEvent>>,
    #[props(default)]
    pub class: Option<String>,
    #[props(default)]
    pub id: Option<String>,
    #[props(default)]
    pub name: Option<String>,
}

#[derive(Props, Clone, PartialEq)]
pub struct LabelProps {
    #[props(default)]
    pub for_input: Option<String>,
    #[props(default)]
    pub required: bool,
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[component]
pub fn Input(props: InputProps) -> Element {
    let base_classes = "w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 disabled:opacity-50 disabled:cursor-not-allowed";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        input {
            r#type: props.input_type.to_str(),
            class: "{class_string}",
            placeholder: props.placeholder.as_deref().unwrap_or(""),
            value: props.value.as_deref().unwrap_or(""),
            disabled: props.disabled,
            required: props.required,
            id: props.id.as_deref().unwrap_or(""),
            name: props.name.as_deref().unwrap_or(""),
            oninput: move |evt| {
                if let Some(handler) = &props.oninput {
                    handler.call(evt);
                }
            },
            onchange: move |evt| {
                if let Some(handler) = &props.onchange {
                    handler.call(evt);
                }
            }
        }
    }
}

#[component]
pub fn Label(props: LabelProps) -> Element {
    let base_classes = "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        label {
            class: "{class_string}",
            r#for: props.for_input.as_deref().unwrap_or(""),
            {props.children}
            if props.required {
                span {
                    class: "text-red-500 ml-1",
                    "*"
                }
            }
        }
    }
}
