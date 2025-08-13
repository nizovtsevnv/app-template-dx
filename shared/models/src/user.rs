use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct User {
    pub id: u64,
    pub name: String,
    pub email: String,
}

impl User {
    /// Create a new user with validation
    pub fn new(id: u64, name: String, email: String) -> Result<Self, String> {
        if name.trim().is_empty() {
            return Err("Name cannot be empty".to_string());
        }

        if !email.contains('@') {
            return Err("Invalid email format".to_string());
        }

        Ok(Self { id, name, email })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_user_creation_valid() {
        let user = User::new(1, "John Doe".to_string(), "john@example.com".to_string());
        assert!(user.is_ok());

        let user = user.unwrap();
        assert_eq!(user.id, 1);
        assert_eq!(user.name, "John Doe");
        assert_eq!(user.email, "john@example.com");
    }

    #[test]
    fn test_user_creation_empty_name() {
        let result = User::new(1, "".to_string(), "john@example.com".to_string());
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Name cannot be empty");
    }

    #[test]
    fn test_user_creation_invalid_email() {
        let result = User::new(1, "John Doe".to_string(), "invalid-email".to_string());
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Invalid email format");
    }
}
