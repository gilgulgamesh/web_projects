using Dates
using Hyperscript #my fork


@tags html head meta body style h1 h2 h4 span article section link
@tags_noescape div

banner = "Feng Shui of Life Blog"

include("posts.jl")

output = "pimkossible/posts.html"

function cutedate(dt)
    typeof(dt) == String && return dt

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


const postbox(tup) =
    article.post(id="#$(tup[1])",
        h2.title(
            span("#$(tup[1])" * " "),
            span.Title(tup[2])
        ),
        h4.subtitle(
            span.User(tup[3]),
            span(" " * cutedate(tup[4]))
        ),
        div.Content(tup[5])
    )

const docubox(allposts) =
html(
    head(
        meta(charset="UTF-8"),
        link(rel="stylesheet", href="style.css"),
    ),
    body(
        h1(id="banner", banner),
        section(id="posts",
            allposts,
            ),
        ),
    )



a = []
for i in length(Posts.posts):-1:1
     push!(a, postbox(Posts.posts[i]))
end

savehtml(output, Pretty(docubox(a)))
