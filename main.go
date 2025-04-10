package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

// Credentials struct to hold our application credentials
type Credentials struct {
	APIKey     string `json:"api_key"`
	APISecret  string `json:"api_secret"`
	DBPassword string `json:"db_password"`
}

// loadCredentials loads credentials from environment variables or a file
func loadCredentials() Credentials {
	creds := Credentials{
		APIKey:     os.Getenv("API_KEY"),
		APISecret:  os.Getenv("API_SECRET"),
		DBPassword: os.Getenv("DB_PASSWORD"),
	}

	// If environment variables are empty, try to load from file
	if creds.APIKey == "" && creds.APISecret == "" && creds.DBPassword == "" {
		credFile := os.Getenv("CREDENTIALS_FILE")
		if credFile != "" {
			if data, err := ioutil.ReadFile(credFile); err == nil {
				json.Unmarshal(data, &creds)
			} else {
				log.Printf("Warning: Could not read credentials file: %v", err)
			}
		}
	}

	return creds
}

func main() {
	// Get port from environment variable or default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Load credentials
	creds := loadCredentials()

	// Log credential status (not the values themselves)
	log.Println("Credential status:")
	log.Printf("- API Key: %s", maskString(creds.APIKey))
	log.Printf("- API Secret: %s", maskString(creds.APISecret))
	log.Printf("- DB Password: %s", maskString(creds.DBPassword))

	// Define HTTP handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})

	// Start HTTP server
	log.Printf("Server starting on port %s...\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Printf("Server failed to start: %v\n", err)
		os.Exit(1)
	}
}

// maskString masks a string for secure logging
func maskString(s string) string {
	if s == "" {
		return "not set"
	}
	if len(s) <= 4 {
		return "****"
	}
	return s[:2] + "****" + s[len(s)-2:]
}