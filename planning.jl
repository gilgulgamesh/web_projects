

 js transcodes everything correctly. use json with name title and content
 -- the whole html section.

minimal version
 -- just splices the htmls. i back up.
 -- ok it saves each post too, and a copy of main

 full version
  -- json or xml? html?
  -- git back up changes
  -- database

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
