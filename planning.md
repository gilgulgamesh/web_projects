# planning

 js transcodes everything correctly. use json with name title and content
 -- the whole html section.

minimal version
 -- just splices the htmls. i back up.
 -- ok it saves each post too, and a copy of main
 -- unmmmm maybe you wanna just copy it to back up? and do that after?
 
 full version
  -- json or xml? html?
  -- git back up changes
  -- database


## posting function

```jl
nextpost_text = read(package.txt, String) # will be req.body

function addpost!(nextpost_text::String)
    # get what's needed
    old_db_text = read("database.txt", String) # generalise, learn how to files

    #time
    postdate = Dates.now()
    datestring = replace(string(postdate), r":" => s";")

    #back up
    backup_name = "backup_" * datestring * ".txt"
    backup_file = open(backup_name, "w")
    write(backup_file, old_db_text)
    close(backup_file)

    # splice
    new_db_file = open(database.txt, "w")
    write(new_db_file, nextpost_text * "\n\n" * old_db_text) # make elaborate
    close(new_db_file)
end
```

# add errors
```jl
if  req.body ==
else
    Response(Plain, "That don't")
end
```


## security

for now
-
   0. log ip adresses, full requests, and just like do it more logically.
   
   1. **Sanitizer** (HTMLSanitizer.jl) — strips dangerous markup server-side before storage/display
   
   2. **Iframe allowlist** — only pre-approved domains can be embedded at all
   
   3. **Click-to-load**, fortified into a **review lock** — new iframe submissions stay fully hidden until you personally approve them, then become click-to-load for everyone after

later
-
   node dom thinger, 

   idk. the man with no name.


### logging
   save each request like i am into the file. that's good. dont really nee
