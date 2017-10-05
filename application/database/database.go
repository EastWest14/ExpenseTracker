package database

import (
	"database/sql"
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