use shared_models::*;

#[test]
fn test_user_serialization() {
    let user = User {
        id: 1,
        name: "John Doe".to_string(),
        email: "john@example.com".to_string(),
    };

    // Test serialization
    let json = serde_json::to_string(&user).expect("Failed to serialize user");
    assert!(json.contains("John Doe"));
    assert!(json.contains("john@example.com"));

    // Test deserialization
    let deserialized: User = serde_json::from_str(&json).expect("Failed to deserialize user");
    assert_eq!(user, deserialized);
}

#[test]
fn test_user_creation() {
    let user = User {
        id: 123,
        name: "Alice".to_string(),
        email: "alice@test.com".to_string(),
    };

    assert_eq!(user.id, 123);
    assert_eq!(user.name, "Alice");
    assert_eq!(user.email, "alice@test.com");
}
