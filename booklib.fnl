
ns booklib

new = proc()
	import valuez
	import stddbc
	import loqic
	import stdvar
	import stdfu

	generate-id = proc()
		import stdbytes
		import stdstr
		import stdos

		ok err out errout = call(stdos.exec 'uuidgen'):
		call(stddbc.assert ok sprintf('%v (%v)' err errout))
		call(stdstr.strip call(stdbytes.string out))
	end

	open-ok open-err db = call(valuez.open 'dbexample' map('in-mem' true)):
	call(stddbc.assert open-ok open-err)

	open-col = proc(colname)
		found _ col1 = call(valuez.get-col db colname):
		if(found
			col1
			call(proc()
				col-ok col-err col2 = call(valuez.new-col db colname):
				call(stddbc.assert col-ok col-err)
				col2
			end)
		)
	end

	col = call(open-col 'library')

	add-book = proc(book)
		book-item = list(
			'book'
			get(book 'title')
			get(book 'author-firstname')
			get(book 'author-lastname')
			call(generate-id)
		)
		call(valuez.put-value col book-item)
	end

	add-user = proc(user)
		user-firstname = get(user 'firstname')
		user-lastname = get(user 'lastname')
		user-item = list(
			'user'
			user-firstname
			user-lastname
			call(generate-id)
		)
		result = call(stdvar.new list(true ''))

		add-if-not-found = proc(txn)
			facts = call(valuez.items txn)
			user-results = call(loqic.match list('user' user-firstname user-lastname '?user-id') facts)
			if(empty(user-results)
				call(proc()
					call(valuez.put-value txn user-item)
					true
				end)

				call(proc()
					call(stdvar.set result list(false 'user exists already'))
					false
				end)
			)
		end

		call(valuez.trans col add-if-not-found)
		call(stdvar.value result)
	end

	show-books = proc()
		facts = call(valuez.items col)
		results = call(loqic.match list('book' '?title' '?author-firstname' '?author-lastname' '?book-id') facts)
		results
	end

	show-users = proc()
		facts = call(valuez.items col)
		results = call(loqic.match list('user' '?firstname' '?lastname' '?user-id') facts)
		results
	end

	borrow-book = proc(book-title user-firstname user-lastname)
		result = call(stdvar.new list(true ''))

		borrow = proc(txn)
			facts = call(valuez.items txn)
			book-results = call(loqic.match list('book' book-title '?author-firstname' '?author-lastname' '?book-id') facts)
			user-results = call(loqic.match list('user' user-firstname user-lastname '?user-id') facts)
			cond(
				empty(book-results)
				call(proc()
					call(stdvar.set result list(false 'book not found'))
					false
				end)

				empty(user-results)
				call(proc()
					call(stdvar.set result list(false 'user not found'))
					false
				end)

				call(proc()
					matches = call(loqic.match list('and'
						list('book' book-title '?author-firstname' '?author-lastname' '?book-id')
						list('user' user-firstname user-lastname '?user-id')
					) facts)

					borrowed-match = call(loqic.match list('and'
						list('book' book-title '?author-firstname' '?author-lastname' '?book-id')
						list('borrowing' '?id' '?book-id')
					) facts)

					if(empty(borrowed-match)
						call(proc()
							user-id = get(head(matches) 'user-id')
							book-id = get(head(matches) 'book-id')
							call(valuez.put-value txn list('borrowing' user-id book-id))
							true
						end)

						call(proc()
							call(stdvar.set result list(false 'book not available'))
							false
						end)
					)
				end)
			)
		end

		call(valuez.trans col borrow)
		call(stdvar.value result)
	end

	show-loans = proc()
		facts = call(valuez.items col)
		matches = call(loqic.match list('and'
			list('book' '?title' '?author-firstname' '?author-lastname' '?book-id')
			list('user' '?firstname' '?lastname' '?user-id')
			list('borrowing' '?user-id' '?book-id')
		) facts)

		call(stdfu.apply matches func(item)
			map(
				'Title'   get(item 'title')
				'Book-id' get(item 'book-id')
				'User-id' get(item 'user-id')
				'User'    plus(get(item 'firstname') ' ' get(item 'lastname'))
			)
		end)
	end

	show-user-loans = proc(user-firstname user-lastname)
		facts = call(valuez.items col)
		matches = call(loqic.match list('and'
			list('book' '?title' '?author-firstname' '?author-lastname' '?book-id')
			list('user' user-firstname user-lastname '?user-id')
			list('borrowing' '?user-id' '?book-id')
		) facts)

		call(stdfu.apply matches func(item)
			map(
				'Title'   get(item 'title')
				'Book-id' get(item 'book-id')
			)
		end)
	end

	show-books-of-author = proc(author-firstname author-lastname)
		facts = call(valuez.items col)
		matches = call(loqic.match list('book' '?title' author-firstname author-lastname '?book-id') facts)
		call(stdfu.apply matches func(item) get(item 'title') end)
	end

	# library object
	map(
		'add-book'        add-book
		'show-books'      show-books

		'add-user'        add-user
		'show-users'      show-users

		'borrow-book'          borrow-book
		'show-loans'           show-loans
		'show-user-loans'      show-user-loans
		'show-books-of-author' show-books-of-author
	)
end

endns

