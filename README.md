# booklibrary
Example application for book library

## Installing
Fetch repository with `--recursive` option (so that needed submodules are included):

```
git clone --recursive https://github.com/anssihalmeaho/booklibrary.git
```

## Demonstrating information based programming
Idea is to show how information stored as **facts** makes information handling
simple and flexible. Also consistency is taken care of by using transactions.

As information is stored as facts then logic programming type of queries
can be used for it (utilising [loqic](https://github.com/anssihalmeaho/loqic)).

[ValueZ value store](https://github.com/anssihalmeaho/fuvaluez) is used as permanent storage
for information.
In example **valuez** is used in in-memory mode only (data not stored to file).

## Build funla to include valuez
In order to include **valuez** data store to **funla** interpreter follow
instructions in [ValueZ installed as std-module](https://github.com/anssihalmeaho/fuvaluez).


## Running booklibrary example
**Note:** example assumes that **uuidgen** tool is found from OS (Linux/Unix).

Run:

```
funla books-example.fnl
```


Output is similar to this:
(book-id's and user-id's are UUID's which are generated at runtime)

```
Addind Bob Jackson 1st time succeeds: list(true, '')
Addind Bob Jackson 2nd time fails: list(false, 'user exists already')
borrow: list(false, 'book not found')
borrow: list(false, 'user not found')
borrow: list(true, '')
borrow: list(true, '')
borrow: list(false, 'book not available')

Books by author Alexandre Dumas: list('The Count of Monte Cristo', 'The Three Musketeers')

Show user Bob Jackson loans: list(map('Title' : 'The Call of the Wild', 'Book-id' : 'c0f08bea-4d99-4fed-a5e3-93888bad2896'))

All loans:
  User: Bob Jackson (user-id: 766e300a-b900-4e04-8ed6-92cfb55b3fc1)
  Book: The Call of the Wild (book-id: c0f08bea-4d99-4fed-a5e3-93888bad2896)

  User: Mary Jameson (user-id: f84f13d0-fd87-4439-af0c-bdf519be62c8)
  Book: The Old Man and the Sea (book-id: ba0ee90c-9369-47a0-81ab-9eeb35864f7b)


All users:
  Ben Johnson (user-id: aa013be7-fe22-46fa-b37b-45f4e2b579a4)
  Bob Jackson (user-id: 766e300a-b900-4e04-8ed6-92cfb55b3fc1)
  Mary Jameson (user-id: f84f13d0-fd87-4439-af0c-bdf519be62c8)

All books:
  Name: The Count of Monte Cristo, Author: Alexandre Dumas (book-id: b2b5de1e-ac81-4744-bf5b-d1152ab798df)
  Name: The Three Musketeers, Author: Alexandre Dumas (book-id: f1c79743-fa1b-42a0-b402-8c26c11c2190)
  Name: The Call of the Wild, Author: Jack London (book-id: c0f08bea-4d99-4fed-a5e3-93888bad2896)
  Name: The Old Man and the Sea, Author: Ernest Hemingway (book-id: ba0ee90c-9369-47a0-81ab-9eeb35864f7b)

true
```
