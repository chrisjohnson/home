if exists("g:afterstart_callbacks")
	for Fn in g:afterstart_callbacks
		call Fn()
	endfor
endif
