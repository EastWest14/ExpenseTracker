package main

import (
	"ExpenseTracker/application/database"
	"fmt"
	"net/http"
	"os"
)

const (
	DB_NAME = "ET_DB"
)

var petName string

func main() {
	setup()
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

func setup() {
	dbUser := os.Getenv("DBUser")
	dbPassword := os.Getenv("DBPassword")
	dbHost := os.Getenv("DBHost")
	fmt.Println(dbUser + ":" + dbPassword + ":" + dbHost)
	db, err := database.CreateDBConnection(dbHost, dbUser, dbPassword, DB_NAME)
	if err != nil {
		panic("Failed to connect to DB: " + err.Error())
	}
	defer db.Close()
	fmt.Println("Connected to DB")
	name, err := database.QueryPetName(db)
	if err != nil {
		panic("Failed to get pet name: " + err.Error())
	}
	petName = name
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, petName)
}
