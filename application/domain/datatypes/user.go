package datatypes

type User struct {
	id        int64
	firstName string
	lastName  string
}

func NewUser() *User {
	return &User{}
}

func (u *User) SetID(id int64) {
	u.id = id
}

func (u *User) ID() int64 {
	return u.id
}

func (u *User) SetFirstName(firstName string) {
	u.firstName = firstName
}

func (u *User) FirstName() (firstName string) {
	return u.firstName
}

func (u *User) SetLastName(lastName string) {
	u.lastName = lastName
}

func (u *User) LastName() (lastName string) {
	return u.lastName
}
