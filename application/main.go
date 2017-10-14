package main

import (
	"ExpenseTracker/application/database"
	"ExpenseTracker/application/server"
	"fmt"
	"os"
)

const (
	DB_NAME = "ET_DB"
)

var petName string

func main() {
	setupDB()
	setup()
}

func setup() {
	serv := server.NewServer()
	err := serv.Start()
	if err != nil {
		panic(err.Error())
	}
}

func setupDB() {
	dbUser := os.Getenv("DBUser")
	dbPassword := os.Getenv("DBPassword")
	dbHost := os.Getenv("DBHost")
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
	_, err = database.QueryUser(db, int64(1))
	if err != nil {
		panic("Failed to get user: " + err.Error())
	}
	petName = name
}
