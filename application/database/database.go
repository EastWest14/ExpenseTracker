package database

import (
	"ExpenseTracker/application/domain/datatypes"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)

//CreateDBConnection creates and verifies DB Connection.
func CreateDBConnection(dbHost, dbUser, dbPassword, dbName string) (dbConnection *sql.DB, err error) {
	dbConnection, err = sql.Open("mysql", dbUser+":"+dbPassword+"@tcp("+dbHost+":3306)/"+dbName)
	if err != nil {
		return nil, err
	}
	err = dbConnection.Ping()
	if err != nil {
		return nil, err
	}
	return dbConnection, nil
}

//Temporary function.
func QueryPetName(dbConnection *sql.DB) (string, error) {
	var name string

	rows, err := dbConnection.Query("select name from pet limit 1")
	if err != nil {
		return "", err
	}
	defer rows.Close()
	for rows.Next() {
		err := rows.Scan(&name)
		if err != nil {
			return "", err
		}
	}
	err = rows.Err()
	if err != nil {
		return "", err
	}
	return name, nil
}

func QueryUser(dbConnection *sql.DB, id int64) (*datatypes.User, error) {
	aUser := datatypes.NewUser()
	var firstName, lastName string
	var tempId int64

	rows, err := dbConnection.Query("select id, first_name, last_name from user where id = ?", id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		err := rows.Scan(&tempId, &firstName, &lastName)
		if err != nil {
			return nil, err
		}
		aUser.SetID(tempId)
		aUser.SetFirstName(firstName)
		aUser.SetLastName(lastName)
	}
	err = rows.Err()
	if err != nil {
		return nil, err
	}
	return aUser, nil
}
