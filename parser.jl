using Dates

using DelimitedFiles, HTMLSanitizer, Hyperscript, URIs #my fork

bannertext = "Feng Shui of Blog"
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
    c
end


function addpost!(postbody::String)
    prior,_ = readdlm(TSV_FILE, ' ', String, header=true)
    evilprior,_ = readdlm(EVIL_TSV_FILE, ' ', String, header=true)
    rowcount =  size(prior, 1)
    row = makerow(postbody, rowcount)
    row = replace.(row, '+' => ' ')
    row = unescapeuri.(row)
    # println("after escape", row)
    row = replace.(row, "&lt;" => '<', "&gt;" => '>', "&amp;" => '&',  ) #enough?
    # println("after replace",row)
    if row[2:end] == prior[end, 2:end] || row[2:end] == evilprior[end, 2:end]
        return Response(Plain, "we got it last time babes", status=400)
    end
    saferow = makesafe(row)
    saverow(row, saferow)
    println(" $EVIL_TSV_FILE: \n$row \n $TSV_FILE:\n$saferow  , ")
    updatehtml()
    println("updated $HTML_FILE, sending to $SITE_LOC")
    sendwait()
end

function filter(user, alphabet)
    tmp = ""
    for c in user
        if c in (alphabet)
            new_c = c
        else
            new_c = ""
        end
        tmp *= new_c
    end
    tmp
end

function makerow(postbody::String, rowcount::Int)
    title, user, content, tags = match(r"Title=(.+)?&User=(.+)&Content=(.+)&Tags=(.+)?", postbody).captures
    isnothing(title) ? title = "" : nothing
    isnothing(tags) ? tags = "" : nothing
    date = cutedate(Dates.now())
    user = filter(user, "abcdefghijklmnopqrstuvwxyz")
    postnumber = "#$(rowcount + 1)"
    row::Vector = [
        postnumber
        title
        user
        date
        content
        tags
    ]
end


NUMBER  = 1
TITLE  = 2
USER  = 3
DATE  = 4
CONTENT = 5
TAGS = 6


function makesafe(row::Vector)
    # upgrade to dompurify
    # consider limiting the limited one more for sanity
    saferow::Vector = [
        sanitize.(row[1:4], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[5], whitelist = HTMLSanitizer.WHITELIST)
        sanitize(row[6], whitelist = HTMLSanitizer.LIMITED)
    ]
end

function saverow(row::Vector,  saferow::Vector)
    if row != saferow
        # @show row saferow
        println("UNSAFE POST CENSORED see $EVIL_TSV_FILE \n $row \n $saferow")
        io2 = open(EVIL_TSV_FILE,  "a")
        writedlm(io2, permutedims(row), ' ')
        close(io2)
        saferow[TAGS] =  saferow[TAGS] * " unverified"
    end
    io1 = open(TSV_FILE,  "a")
    writedlm(io1, permutedims(saferow), ' ')
    close(io1)
end



getrows() = readdlm(TSV_FILE, ' ', String, header=true)[1]

function gettagposts()
    rows = getrows()
    tagposts = Dict()
    for row in eachrow(rows)
        a = get!(tagposts, filter(row[NUMBER], "1234567890"), [])
        push!(a, row)
    end
    for row in eachrow(rows)
        for tag in split(row[TAGS])
            a = get!(tagposts, filter(tag, "abcdefghijklmnopqrstuvwxyz1234567890"), [])
            push!(a, row)
        end
    end
    for row in eachrow(rows)
        a = get!(tagposts, filter(row[USER], "abcdefghijklmnopqrstuvwxyz"), [])
        push!(a, row)
    end
    tagposts
end

function getusers()
    rows = getrows()
    users = []
    for row in eachrow(rows)
        push!(users, filter(row[USER], "abcdefghijklmnopqrstuvwxyz"))
    end
    users
end



function updatehtml()
    rows  = getrows()
    tagposts = gettagposts()
    users = getusers()

    allboxed = []
    for i in 1:size(rows, 1)
        d = reverse(rows, dims=1)[i, 1:6]
        push!(allboxed, postbox(d))
    end

    htmlposts = formathtml(allboxed, users)
    write(HTML_FILE, htmlposts)

    for t in keys(tagposts)
        length(tagposts[t]) > 1 || continue
        posts = tagposts[t]
        tboxed = []
        for i in eachindex(posts)
            push!(tboxed, postbox(posts[i]))
            # println(uboxed)
        end
        users = []
        for p in posts
            push!(users, p[USER])
        end
        htmlposts = formathtml(tboxed, users)
        # @show t
        touch("pimkossible/private/pg/$t.html")
        write("pimkossible/private/pg/$t.html", htmlposts)

    end


end


function formathtml(allboxed, users)
    htmlposts = replace(string(Pretty(docubox(allboxed, users))),
        "<html><html>" => "<html>",
        "</html></html>" => "</html>" )
 end

#omfg i just want to cat, save, flip save flip cat. file systems are not arrays. good for personal things.
#format
#
const html = m("html")
const head = m("head")
const meta = m("meta")
const body = m("body")
const style = m("style")
const h1 = m("h1")
const h2 = m("h2")
const h4 = m("h4")
const spanlink = m("spanlink")
const article = m("article")
const section = m("section")
const iframe = m("iframe")
const video = m("video")
const a = m("a")
const span = m("span")
const div = m("div")
const sub = m("sub")
const link = m("link")
const sup = m("sup")

function at(t)
    t = filter(t, "abcdefghijklmnopqrstuvwxyz1234567890")
    l = length(gettagposts()[t])
    if l > 1
        return span.tag(a("$t", href="/pg/$t"))
    else
        return span.tag(t)
    end
end

function postbox(row)
    article(id=row[NUMBER][2:end], class=row[USER], #removes the #
        h2.heading(
            span.Title(row[TITLE])
        ),
        h4.subheading(
            span(" " * cutedate(row[DATE]))
        ),
        div.Content(row[CONTENT]),
        div.Tags(
            at(row[USER]),
            at(row[NUMBER]),
            at.(split(row[TAGS]))
        )
    )
end

function docubox(allboxed, users)
    html(
        head(
            meta(charset="UTF-8"),
            link(rel="stylesheet", href="/style.css"),
            style(makecss(users))
        ),
        body(
            div(id="bannertext",
                h1(a(bannertext, href="/")),
                h1(a(href="/build/post-editor.html", "Post Editor")),
                div(id="status",
                    h1("online?"),
                    iframe(src="https://content-edible.org/status.html";)
                ),
            ),
            section(id="posts",
                allboxed,
            ),
        ),
    )
end
