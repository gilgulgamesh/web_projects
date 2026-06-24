using Dates
using Hyperscript #my fork


@tags html head meta body style h1 h2 h4 span div article section

const banner = h1(id="banner", "Feng Shui of Life Blog")

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
