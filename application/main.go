package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	//"ExpenseTracker/application/database"
	"net/http"
	"os"
)

const (
	DB_NAME = "ET_DB"
)

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
	db, err := sql.Open("mysql", dbUser+":"+dbPassword+"@tcp("+dbHost+":3306)/"+DB_NAME)
	err = db.Ping()
	if err != nil {
		panic(err.Error())
	}
	if err != nil {
		panic(err)
	}
	fmt.Println("Connected to DB")
	defer db.Close()
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi there!")
}
