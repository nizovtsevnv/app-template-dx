use dioxus::prelude::*;

#[derive(Props, Clone, PartialEq)]
pub struct CardProps {
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[derive(Props, Clone, PartialEq)]
pub struct CardHeaderProps {
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[derive(Props, Clone, PartialEq)]
pub struct CardContentProps {
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[component]
pub fn Card(props: CardProps) -> Element {
    let base_classes = "bg-white dark:bg-gray-800 shadow-lg border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        div {
            class: "{class_string}",
            {props.children}
        }
    }
}

#[component]
pub fn CardHeader(props: CardHeaderProps) -> Element {
    let base_classes = "px-6 py-4 border-b border-gray-200 dark:border-gray-700";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        div {
            class: "{class_string}",
            {props.children}
        }
    }
}

#[component]
pub fn CardContent(props: CardContentProps) -> Element {
    let base_classes = "px-6 py-4";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        div {
            class: "{class_string}",
            {props.children}
        }
    }
}
