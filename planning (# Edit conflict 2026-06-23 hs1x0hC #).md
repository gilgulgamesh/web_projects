# planning

 js transcodes everything correctly. use json with name title and content
 -- the whole html section.


 full version
  -- json or xml? html?
  -- git back up changes
  -- database

67

## security

for now

[x]  0. log ip adresses, full requests, and just like do it more logically.
   
   1. **Sanitizer** (HTMLSanitizer.jl) — strips dangerous markup server-side before storage/display
   
   2. **Iframe allowlist** — only pre-approved domains can be embedded at all
   
   3. **Click-to-load**, fortified into a **review lock** — new iframe submissions stay fully hidden until you personally approve them, then become click-to-load for everyone after

later
-
   node dom thinger, 

   idk. finn the man with no name.

 lol dates
 -
```jl
function cutedate(dt::DateTime) 
    a = Dates.format(dt, "p-d-u'yy") # use time of day to get 🌇🏙️🌆 or smn
    b = lowercase(string(a))
    
    c = replace( b, 
        "apr" => "april",
        "jun" => "june",
        "jul" => "july",
        "aug" => "august",
        "sep" => "sept"
    )
end
```

## html parsing


`Title=Hi &User=Me &Content=My post`

```html
<h2 class=Title>Hi</h2>
<h4 class=subtitle>
   <span class=User>Me</span>
   <span class=date>$day-$month-$year</span>
</h4>
<div class=Content>My post</div>

# gotta make them lowercase...............
```
Regex into title 

```jl

@tags html head meta body style h1 h2 h4 span div article section

banner = h1(id="banner")

const postbox(Title::String, User::String, Content::String, date, postnumber) = 
    article.post(id="#" * postnumber,
        h2.Title("$postnumber" *" "* Title),
        h4.subtitle(User *" "* cutedate(date)), 
        div.Content(Content)
    )


const docubox(allposts) = 
html(
    head(
        meta(charset="UTF-8"),
        style(src="https://pimkossible.neocities.org/style.css"),
    ),
    body(
        h1(id="banner"),
        section(id="posts", allposts),
        ),
    )
    

banner = h1(id="banner", "hi")

posts = 
    allposts = (post("hi"), post("bye"))
function addpost!(x)
    global allposts
    allposts = [x, allposts]





    







```
