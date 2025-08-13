use criterion::{Criterion, black_box, criterion_group, criterion_main};
use shared_models::User;

fn user_creation_benchmark(c: &mut Criterion) {
    c.bench_function("user creation", |b| {
        b.iter(|| {
            User::new(
                black_box(1),
                black_box("John Doe".to_string()),
                black_box("john@example.com".to_string()),
            )
        })
    });
}

fn user_serialization_benchmark(c: &mut Criterion) {
    let user = User {
        id: 1,
        name: "John Doe".to_string(),
        email: "john@example.com".to_string(),
    };

    c.bench_function("user serialization", |b| {
        b.iter(|| serde_json::to_string(black_box(&user)))
    });
}

fn user_deserialization_benchmark(c: &mut Criterion) {
    let json = r#"{"id":1,"name":"John Doe","email":"john@example.com"}"#;

    c.bench_function("user deserialization", |b| {
        b.iter(|| serde_json::from_str::<User>(black_box(json)))
    });
}

criterion_group!(
    benches,
    user_creation_benchmark,
    user_serialization_benchmark,
    user_deserialization_benchmark
);
criterion_main!(benches);
