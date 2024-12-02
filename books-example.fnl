
ns main

import booklib
import stdfu

add-books = proc(add-book)
	call(add-book map(
		'title'            'The Count of Monte Cristo'
		'author-firstname' 'Alexandre'
		'author-lastname'  'Dumas'
	))
	call(add-book map(
		'title'            'The Three Musketeers'
		'author-firstname' 'Alexandre'
		'author-lastname'  'Dumas'
	))
	call(add-book map(
		'title'            'The Call of the Wild'
		'author-firstname' 'Jack'
		'author-lastname'  'London'
	))
	call(add-book map(
		'title'            'The Old Man and the Sea'
		'author-firstname' 'Ernest'
		'author-lastname'  'Hemingway'
	))
end

add-users = proc(add-user)
	print('Addind Bob Jackson 1st time succeeds: '
		call(add-user map(
			'firstname' 'Bob'
			'lastname'  'Jackson'
		))
	)
	call(add-user map(
		'firstname' 'Ben'
		'lastname'  'Johnson'
	))
	call(add-user map(
		'firstname' 'Mary'
		'lastname'  'Jameson'
	))
	print('Addind Bob Jackson 2nd time fails: '
		call(add-user map(
			'firstname' 'Bob'
			'lastname'  'Jackson'
		))
	)
end

main = proc()
	# get library object and its methods first
	library = call(booklib.new)
	add-book = get(library 'add-book')
	show-books = get(library 'show-books')
	add-user = get(library 'add-user')
	show-users = get(library 'show-users')
	borrow-book = get(library 'borrow-book')
	show-loans = get(library 'show-loans')
	show-user-loans = get(library 'show-user-loans')
	show-books-of-author = get(library 'show-books-of-author')

	# add books and users
	call(add-books add-book)
	call(add-users add-user)

	# borrow book title which does not exist
	print('borrow: ' call(borrow-book 'not a book' 'Bob' 'Jackson'))
	# borrow book by non-existing user
	print('borrow: ' call(borrow-book 'The Call of the Wild' 'Randy' 'Jackson'))
	# borrow book ok
	print('borrow: ' call(borrow-book 'The Call of the Wild' 'Bob' 'Jackson'))
	# borrow book ok
	print('borrow: ' call(borrow-book 'The Old Man and the Sea' 'Mary' 'Jameson'))
	# borrow book which is already borrowed
	print('borrow: ' call(borrow-book 'The Old Man and the Sea' 'Ben' 'Johnson'))

	print('\nBooks by author Alexandre Dumas: ' call(show-books-of-author 'Alexandre' 'Dumas'))
	print()
	print('Show user Bob Jackson loans: ' call(show-user-loans 'Bob' 'Jackson'))
	print()
	print('All loans: \n' call(stdfu.foreach call(show-loans) print-loan ''))
	print('All users: ' call(stdfu.foreach call(show-users) print-user '\n'))
	print('All books: ' call(stdfu.foreach call(show-books) print-book '\n'))
end

print-book = func(item printout)
	plus(
		printout
		sprintf(
			'  Name: %s, Author: %s %s (book-id: %s)\n'
			get(item 'title')
			get(item 'author-firstname')
			get(item 'author-lastname')
			get(item 'book-id')
		)
	)
end

print-user = func(item printout)
	plus(
		printout
		sprintf(
			'  %s %s (user-id: %s)\n'
			get(item 'firstname')
			get(item 'lastname')
			get(item 'user-id')
		)
	)
end

print-loan = func(item printout)
	plus(
		printout
		sprintf(
			'  User: %s (user-id: %s)\n  Book: %s (book-id: %s)\n\n'
			get(item 'User')
			get(item 'User-id')
			get(item 'Title')
			get(item 'Book-id')
		)
	)
end

endns

