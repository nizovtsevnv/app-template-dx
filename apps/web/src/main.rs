use dioxus::document;
use dioxus::prelude::*;
use shared_ui::{
    Button, ButtonSize, ButtonVariant, Card, CardContent, CardHeader, Header, Input, InputType,
    Label, Layout, Main,
};

fn main() {
    launch(App);
}

#[component]
fn App() -> Element {
    let mut count = use_signal(|| 0);
    let mut input_value = use_signal(String::new);
    let mut dark_mode = use_signal(|| false);

    rsx! {
        document::Stylesheet {
            href: asset!("/assets/generated.css")
        }
        div {
            class: if *dark_mode.read() { "dark" } else { "" },
            Layout {
            Header {
                title: "App Template DX",
                Button {
                    text: "Dark Mode",
                    variant: ButtonVariant::Outline,
                    size: ButtonSize::Small,
                    onclick: move |_| {
                        let current = *dark_mode.read();
                        dark_mode.set(!current);
                    }
                }
            }
            Main {
                div {
                    class: "space-y-8",

                    // Welcome section
                    Card {
                        CardHeader {
                            h2 {
                                class: "text-xl font-semibold text-gray-900 dark:text-white",
                                "Welcome to Dioxus with Tailwind CSS"
                            }
                        }
                        CardContent {
                            p {
                                class: "text-gray-600 dark:text-gray-300 mb-4",
                                "This is a modern Rust web application built with Dioxus and styled with Tailwind CSS.
                                 The components are fully reusable and follow a consistent design system."
                            }
                            div {
                                class: "flex flex-wrap gap-2",
                                Button {
                                    text: "Primary Button",
                                    variant: ButtonVariant::Primary,
                                    onclick: move |_| count += 1
                                }
                                Button {
                                    text: "Secondary Button",
                                    variant: ButtonVariant::Secondary
                                }
                                Button {
                                    text: "Outline Button",
                                    variant: ButtonVariant::Outline
                                }
                                Button {
                                    text: "Destructive Button",
                                    variant: ButtonVariant::Destructive
                                }
                            }
                        }
                    }

                    // Counter demo
                    Card {
                        CardHeader {
                            h3 {
                                class: "text-lg font-semibold text-gray-900 dark:text-white",
                                "Interactive Counter Demo"
                            }
                        }
                        CardContent {
                            div {
                                class: "text-center",
                                p {
                                    class: "text-2xl font-bold text-blue-600 dark:text-blue-400 mb-4",
                                    "Count: {count}"
                                }
                                div {
                                    class: "flex gap-2 justify-center",
                                    Button {
                                        text: "Increment",
                                        variant: ButtonVariant::Primary,
                                        onclick: move |_| count += 1
                                    }
                                    Button {
                                        text: "Decrement",
                                        variant: ButtonVariant::Secondary,
                                        onclick: move |_| count -= 1
                                    }
                                    Button {
                                        text: "Reset",
                                        variant: ButtonVariant::Outline,
                                        onclick: move |_| count.set(0)
                                    }
                                }
                            }
                        }
                    }

                    // Form demo
                    Card {
                        CardHeader {
                            h3 {
                                class: "text-lg font-semibold text-gray-900 dark:text-white",
                                "Form Components Demo"
                            }
                        }
                        CardContent {
                            div {
                                class: "max-w-md space-y-4",
                                div {
                                    Label {
                                        for_input: "demo-input",
                                        required: true,
                                        "Your Name"
                                    }
                                    Input {
                                        id: "demo-input",
                                        input_type: InputType::Text,
                                        placeholder: "Enter your name",
                                        value: input_value.read().clone(),
                                        oninput: move |evt: FormEvent| input_value.set(evt.value())
                                    }
                                }
                                div {
                                    Label {
                                        for_input: "demo-email",
                                        "Email Address"
                                    }
                                    Input {
                                        id: "demo-email",
                                        input_type: InputType::Email,
                                        placeholder: "Enter your email"
                                    }
                                }
                                div {
                                    Button {
                                        text: "Submit Form",
                                        variant: ButtonVariant::Primary,
                                        onclick: move |_| {
                                            // Form submission logic
                                        }
                                    }
                                }
                                if !input_value.read().is_empty() {
                                    div {
                                        class: "mt-4 p-3 bg-blue-50 dark:bg-blue-900 rounded-lg",
                                        p {
                                            class: "text-blue-700 dark:text-blue-300",
                                            "Hello, {input_value.read()}! Nice to meet you."
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            }
        }
    }
}
