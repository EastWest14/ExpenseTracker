package database

import (
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
