package datatypes

import (
	"testing"
)

func TestID(t *testing.T) {
	aUser := NewUser()
	if aUser.ID() != int64(0) {
		t.Errorf("Expected ID to be 0, got %d", aUser.ID())
	}

	aUser.SetID(100)
	if aUser.ID() != int64(100) {
		t.Errorf("Expected ID to be %d, got %d", 100, aUser.ID())
	}
}

func TestSetFirstName(t *testing.T) {
	aUser := NewUser()
	if aUser.FirstName() != "" {
		t.Errorf("Expected first name to be %s, got %s", "", aUser.FirstName())
	}

	aUser.SetFirstName("First_Name")
	if aUser.FirstName() != "First_Name" {
		t.Errorf("Expected first name to be %s, got %s", "First_Name", aUser.FirstName())
	}
}

func TestSetLastName(t *testing.T) {
	aUser := NewUser()
	if aUser.LastName() != "" {
		t.Errorf("Expected last name to be %s, got %s", "", aUser.LastName())
	}

	aUser.SetLastName("Last_Name")
	if aUser.LastName() != "Last_Name" {
		t.Errorf("Expected last name to be %s, got %s", "Last_Name", aUser.LastName())
	}
}
