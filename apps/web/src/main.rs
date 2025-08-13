use dioxus::prelude::*;

fn main() {
    launch(App);
}

#[component]
fn App() -> Element {
    rsx! {
        div {
            h1 { "Hello, Dioxus!" }
            p { "Welcome to your modular app template." }
        }
    }
}
