use dioxus::prelude::*;

#[derive(Props, Clone, PartialEq)]
pub struct LayoutProps {
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[derive(Props, Clone, PartialEq)]
pub struct HeaderProps {
    #[props(default)]
    pub title: Option<String>,
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[derive(Props, Clone, PartialEq)]
pub struct MainProps {
    #[props(default)]
    pub class: Option<String>,
    children: Element,
}

#[component]
pub fn Layout(props: LayoutProps) -> Element {
    let base_classes = "min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col";
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
pub fn Header(props: HeaderProps) -> Element {
    let base_classes =
        "bg-white dark:bg-gray-800 shadow-sm border-b border-gray-200 dark:border-gray-700";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        header {
            class: "{class_string}",
            div {
                class: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8",
                div {
                    class: "flex justify-between items-center py-6",
                    if let Some(title) = &props.title {
                        h1 {
                            class: "text-2xl font-bold text-gray-900 dark:text-white",
                            "{title}"
                        }
                    }
                    {props.children}
                }
            }
        }
    }
}

#[component]
pub fn Main(props: MainProps) -> Element {
    let base_classes = "flex-1 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8";
    let additional_classes = props.class.as_deref().unwrap_or("");
    let class_string = format!("{} {}", base_classes, additional_classes);

    rsx! {
        main {
            class: "{class_string}",
            {props.children}
        }
    }
}
